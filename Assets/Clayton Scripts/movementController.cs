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

    public float flapDuration = 1.0f;
    float flapProgress = 100000.0f;

    // Use this for initialization
    void Start () {
        GetComponent<Rigidbody>().AddForce(new Vector3(0, 0, 10000));
    }
	
	// Update is called once per frame
	void FixedUpdate () {
        target.z = 4.0f * Input.GetAxis("Horizontal");
        target.x = 4.0f * Input.GetAxis("Vertical");

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
        //transform.rotation *= Quaternion.AngleAxis(target.y, new Vector3(0, 1, 0));
        transform.rotation *= Quaternion.AngleAxis(target.z, /*transform.rotation **/ new Vector3(0, 0, 1));
        transform.rotation *= Quaternion.AngleAxis(target.x, /*transform.rotation **/ new Vector3(1, 0, 0));

        //Vector3 eulerAnglesRot = yzxRotQuat.eulerAngles;
        ////eulerAnglesRot.x = Mathf.Clamp(eulerAnglesRot.x, -89.0f, 89.0f);
        //
        //transform.rotation *= Quaternion.Euler(eulerAnglesRot);



        liftVector = calculateL();
        liftCoefficient = calculateLCoefficient(GetComponent<Rigidbody>().velocity, liftVector);
        //liftCoefficient *= liftCoefficient;
        liftMagnitude = calculateLMag(GetComponent<Rigidbody>().velocity.magnitude);

        if (liftMagnitude > 10000)
        {
            liftMagnitude = 10000;
        }

       GetComponent<Rigidbody>().AddForceAtPosition(liftVector * liftMagnitude, transform.position + new Vector3(0, 0, 0.0f));

        if (flapProgress <= flapDuration)
        {
            flapProgress += Time.fixedDeltaTime;

            GetComponent<Rigidbody>().AddForce((transform.rotation * new Vector3(0, 0.707f, 0.707f)) * flapFunc(flapProgress / flapDuration) * 40000.0f);
        }
        else
        {
            if (Input.GetButtonDown("Flap"))
            {
                flapProgress = 0.0f;
            }
        }

        var dragCoefficient = liftCoefficient;

        Debug.Log(dragCoefficient);

        GetComponent<Rigidbody>().velocity.Scale(new Vector3(1.0f - (0.5f * dragCoefficient), 1.0f, 1.0f - (0.5f * dragCoefficient)));
        //GetComponent<Rigidbody>().velocity.Scale(new Vector3(dragCoefficient > 0 ? 0.0f : 1.0f, 1.0f, dragCoefficient > 0 ? 0.0f : 1.0f));
    }

    Vector3 calculateL()
    {
        return (transform.rotation * new Vector3(0, 1, 0.2f)).normalized;
    }

    float calculateLCoefficient(Vector3 _velocity, Vector3 _lift)
    {
        return (Mathf.Abs(Mathf.Sin(Mathf.Deg2Rad * Vector3.Angle(_velocity, _lift))));
    }

    float calculateLMag(float _velocity)
    {
        return (lMagConstant * Mathf.Pow(_velocity, 2) * liftCoefficient);
    }

    float flapFunc(float _t)
    {
        return -Mathf.Pow((_t * 2.0f) - 1.0f, 2) + 1.0f;
    }
}
