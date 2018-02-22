using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class movementController : MonoBehaviour {

    public float smooth = 2.0F;
    public float tiltAngle = 30.0F;
    float tiltAroundZ;
    float tiltAroundX;
    float rotAroundY;
    float tilt;
    Vector3 liftVector;
    public float liftCoefficient;
    public float liftMagnitude;
    public float lMagConstant;
    Vector3 target;

    public float lookDirForceConstant = 1.0f;
    public float downDirForceConstant = 1.0f;

    public float flapDuration = 1.0f;
    float flapProgress = 100000.0f;
    public float flapForce = 12.0f;

    public float brakeDuration = 1.0f;
    float brakeProgress = 100000.0f;
    public float brakeForce = 12.0f;

    public float maxSpeedXZPlane = 60.0f;
    public float pullUpRange = 45.0f;

    public float horRotConstant = 4.0f;
    public float verRotConstant = 2.0f;

    [SerializeField]
    private Animator animator;

    // Use this for initialization
    void Start () {
        GetComponent<Rigidbody>().AddForce((transform.rotation * new Vector3(0, 0.707f, 0.707f)) * 600.0f);
    }
	
	// Update is called once per frame
	void FixedUpdate () {
        target.z = horRotConstant * Input.GetAxis("Horizontal");
        target.x = verRotConstant * Input.GetAxis("Vertical");

        //target.z = Mathf.Clamp(target.z, -tiltAngle, tiltAngle);
        //target.x = Mathf.Clamp(target.x, -tiltAngle, tiltAngle);


        if (Input.GetAxis("Horizontal_right") < 0)
        {
           // rotAroundY = GetComponent<Transform>().rotation.y - 0.1f;
            target.y = -1.0f;
        }
        else if (Input.GetAxis("Horizontal_right") > 0)
        {
           // rotAroundY = GetComponent<Transform>().rotation.y + 0.1f;
            target.y = 1.0f;
        }

        //target = new Vector3(tiltAroundX, target.y, tiltAroundZ);
        // transform.rotation = new Quaternion(transform.rotation.x, transform.rotation.y, transform.rotation.z, 1.0f);
        //transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.Euler(target), Time.deltaTime * smooth);

        //transform.rotation = Quaternion.Euler(target);

        //float additionalYFromBanking = Mathf.Abs(transform.rotation.z) * 0.85f;
        //transform.rotation *= Quaternion.AngleAxis(target.y + additionalYFromBanking, transform.rotation * new Vector3(0, 1, 0));

        transform.rotation *= Quaternion.AngleAxis(target.z, /*transform.rotation **/ new Vector3(0, 0, 1));


        float zRotation = transform.rotation.eulerAngles.z;
        //zRotation %= 180.0f;

        float additionalXFromBanking;

        //if (90.0f - pullUpRange <= Mathf.Abs(zRotation) && Mathf.Abs(zRotation) <= 90.0f + pullUpRange)
        //{
        //    additionalXFromBanking = Mathf.Abs(zRotation) * 0.002f;
        //}
        //else
        //{
        //    additionalXFromBanking = 0.0f;
        //}

        float bankFactor = Math.Max(0.0f,
            1.0f - Mathf.Pow((zRotation - 180) / (90 + pullUpRange), 2.0f)
            );
        additionalXFromBanking = bankFactor * 2.0f;
        

        transform.rotation *= Quaternion.AngleAxis(target.x - additionalXFromBanking, /*transform.rotation **/ new Vector3(1, 0, 0));

        //Vector3 eulerAnglesRot = yzxRotQuat.eulerAngles;
        ////eulerAnglesRot.x = Mathf.Clamp(eulerAnglesRot.x, -89.0f, 89.0f);
        //
        //transform.rotation *= Quaternion.Euler(eulerAnglesRot);



        liftVector = calculateL();
        liftCoefficient = calculateLCoefficient(GetComponent<Rigidbody>().velocity, liftVector);
        //liftCoefficient *= liftCoefficient;
        liftMagnitude = calculateLMag(GetComponent<Rigidbody>().velocity.magnitude);

        GetComponent<Rigidbody>().AddForce(liftVector * liftMagnitude);

        if (flapProgress <= flapDuration)
        {
            flapProgress += Time.fixedDeltaTime;

            GetComponent<Rigidbody>().AddForce((transform.rotation * new Vector3(0, 0, 1.0f)) * flapFunc(flapProgress / flapDuration) * flapForce);
        }
        else
        {
            if (Input.GetButtonDown("Flap"))
            {
                animator.SetTrigger("Flapped");
                flapProgress = 0.0f;
            }
        }

        if (brakeProgress <= brakeDuration)
        {
            brakeProgress += Time.fixedDeltaTime;

            GetComponent<Rigidbody>().AddForce((transform.rotation * new Vector3(0, 0, -1.0f)) * flapFunc(brakeProgress / brakeDuration) * brakeForce);
        }
        else
        {
            if (Input.GetButtonDown("Brake"))
            {
                animator.SetTrigger("Flapped");
                brakeProgress = 0.0f;
            }
        }

        //var dragCoefficient = liftCoefficient;

        //Debug.Log(dragCoefficient);

        //GetComponent<Rigidbody>().velocity.Scale(new Vector3(0.3f, 0.9f, 0.3f));

        //GetComponent<Rigidbody>().velocity.Scale(new Vector3(1.0f - (0.5f * dragCoefficient), 1.0f, 1.0f - (0.5f * dragCoefficient)));
        //GetComponent<Rigidbody>().velocity.Scale(new Vector3(dragCoefficient > 0 ? 0.0f : 1.0f, 1.0f, dragCoefficient > 0 ? 0.0f : 1.0f));

        //0 -> 1
        //90 -> 0
        //180 -> -1

        var angleBetween = Mathf.Deg2Rad * Vector3.Angle(transform.rotation * new Vector3(0, 0, 1), new Vector3(0, -1, 0));

        float forceInLookDir = lookDirForceConstant * Mathf.Abs(Mathf.Cos(angleBetween));

        if (angleBetween > Mathf.PI / 2.0f)
        {
            float factor = (angleBetween - Mathf.PI / 2.0f) / (Mathf.PI / 2.0f);
            forceInLookDir *= factor * Mathf.Max(0, Vector3.Dot(GetComponent<Rigidbody>().velocity, transform.rotation * new Vector3(0, 0, 1)));
        }
        //float forceInDownDir = downDirForceConstant * Mathf.Cos(Mathf.Deg2Rad * Vector3.Angle(transform.rotation * new Vector3(0, 0, 1), new Vector3(0, -1, 0)));
        //Debug.Log(forceInLookDir);
        //Debug.Log(forceInDownDir);

        //GetComponent<Rigidbody>().AddForce(transform.rotation * new Vector3(0, 0, 1) /*liftVector*/ * forceInLookDir);
        //GetComponent<Rigidbody>().AddForce(new Vector3(0, -1, 0) * forceInDownDir);

        Vector3 velocity2 = GetComponent<Rigidbody>().velocity;
        velocity2.y = 0;
        if (velocity2.magnitude > 5.0f)
        {
            compensateXZ();
        }
        //compensateY();

        //
        //
        //Debug.Log(velocity);
        //GetComponent<Rigidbody>().AddForce(-velocity * 1.0f);


        Vector3 velocity = GetComponent<Rigidbody>().velocity;
        velocity.y = 0;
        GetComponent<Rigidbody>().AddForce(20.0f * Physics.gravity * (1.0f / (velocity.magnitude + 10.0f)));

        Debug.Log(GetComponent<Rigidbody>().velocity.magnitude);
    }

    void compensateXZ()
    {
        //COMPENSATE ONLY IN XZ PLANE
        Vector3 lookDirection = transform.rotation * new Vector3(0, 0, 1);
        //lookDirection.y = 0;
        //lookDirection.Normalize();

        Vector3 velocity = GetComponent<Rigidbody>().velocity;
        //velocity.y = 0.0f;

        float desiredSpeed = Mathf.Min(maxSpeedXZPlane,
            //velocity.magnitude
            Mathf.Sqrt(
                Mathf.Pow(velocity.y, 2.0f) 
                + Mathf.Pow(velocity.x, 2.0f)
                + Mathf.Pow(velocity.z, 2.0f)
            )
        );


        Vector3 CompenVec = ((lookDirection * desiredSpeed) - velocity) * 0.5f;

        GetComponent<Rigidbody>().velocity += CompenVec;
        
        //Debug.Log(CompenVec);
    }

    //void compensateY()
    //{
    //    //COMPENSATE ONLY IN Y DIR
    //    Vector3 lookDirection = transform.rotation * new Vector3(0, 0, 1);

    //    float velocityY = GetComponent<Rigidbody>().velocity.y;

    //    float s = velocityY - 0.3f * Physics.gravity.magnitude;


    //    Vector3 CompenVecY = ((lookDirectionInYPlane * s) - velocityY * new Vector3(0, 1.0f, 0)) * 0.5f;

    //    GetComponent<Rigidbody>().velocity += CompenVecY;

    //    Debug.Log("Y:");
    //    Debug.Log(CompenVecY);
    //}

    Vector3 calculateL()
    {
        return (transform.rotation * new Vector3(0, 1, 0)).normalized;
    }

    float calculateLCoefficient(Vector3 _velocity, Vector3 _lift)
    {
        return GetComponent<Rigidbody>().velocity.magnitude * 0.1f * (-Mathf.Cos(Mathf.Deg2Rad * Vector3.Angle(_velocity, _lift)));
    }

    float calculateLMag(float _velocity)
    {
        return (lMagConstant * liftCoefficient);
    }

    float flapFunc(float _t)
    {
        return -Mathf.Pow((_t * 2.0f) - 1.0f, 2) + 1.0f;
    }
}
