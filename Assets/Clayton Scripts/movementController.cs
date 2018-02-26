using System;
using UnityEngine;
using System.Collections;

public class movementController : MonoBehaviour {

    [SerializeField]
    private SmoothCameraFollow followCamera;
    [SerializeField]
    private Camera camera1;
    
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

    private float fov = 0.0f;

    private float timerL;
    private int counterL;
    private float timerR;
    private int counterR;

    bool canCountL;
    bool canCountR;

    // Use this for initialization
    void Start () {
        GetComponent<Rigidbody>().AddForce((transform.rotation * new Vector3(0, 0.707f, 0.707f)) * 600.0f);
        fov = Camera.main.fieldOfView;
        counterL = 0;
        counterR = 0;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        target.z = horRotConstant * Input.GetAxis("Horizontal");
        target.x = verRotConstant * Input.GetAxis("Vertical");

        transform.rotation *= Quaternion.AngleAxis(target.z, new Vector3(0, 0, 1));

        float zRotation = transform.rotation.eulerAngles.z;

        float additionalXFromBanking;

        float bankFactor = Math.Max(0.0f,
            1.0f - Mathf.Pow((zRotation - 180) / (90 + pullUpRange), 2.0f)
            );
        additionalXFromBanking = bankFactor * 2.0f;

        transform.rotation *= Quaternion.AngleAxis(target.x - additionalXFromBanking, new Vector3(1, 0, 0));

        liftVector = calculateL();
        liftCoefficient = calculateLCoefficient(GetComponent<Rigidbody>().velocity, liftVector);
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

        var angleBetween = Mathf.Deg2Rad * Vector3.Angle(transform.rotation * new Vector3(0, 0, 1), new Vector3(0, -1, 0));

        float forceInLookDir = lookDirForceConstant * Mathf.Abs(Mathf.Cos(angleBetween));

        if (angleBetween > Mathf.PI / 2.0f)
        {
            float factor = (angleBetween - Mathf.PI / 2.0f) / (Mathf.PI / 2.0f);
            forceInLookDir *= factor * Mathf.Max(0, Vector3.Dot(GetComponent<Rigidbody>().velocity, transform.rotation * new Vector3(0, 0, 1)));
        }

        Vector3 velocity2 = GetComponent<Rigidbody>().velocity;
        velocity2.y = 0;
        if (velocity2.magnitude > 5.0f)
        {
            compensateXZ();
        }

        Vector3 velocity = GetComponent<Rigidbody>().velocity;
        velocity.y = 0;
        GetComponent<Rigidbody>().AddForce(20.0f * Physics.gravity * (1.0f / (velocity.magnitude + 10.0f)));

        Vector3 locE = transform.localEulerAngles;

        // clamping z rotation
        //if (locE.z > 90.0f && locE.z < 100.0f)
        //{
        //    transform.localEulerAngles = new Vector3(locE.x, locE.y, 90.0f);
        //}
        //if (locE.z < 270.0f && locE.z > 200.0f)
        //{
        //    transform.localEulerAngles = new Vector3(locE.x, locE.y, 270.0f);
        //}

        //if (Input.GetAxis("Horizontal") < 0.2f && Input.GetAxis("Horizontal") > -0.2f && (transform.localEulerAngles.z > 2 || (transform.localEulerAngles.z < 358.0f && transform.localEulerAngles.z > 200.0f)))
        //{
        //    StartCoroutine(cooldown(1.0f));
        //}

        //Debug.Log(velocity.magnitude);

        followCamera.followOffset = new Vector3(0, 0, -10) +
            new Vector3(0, 0, -0.5f) * (GetComponent<Rigidbody>().velocity.magnitude / 4);

        float speed = GetComponent<Rigidbody>().velocity.magnitude / 4;
        if (camera1.fieldOfView - speed > 20.0f || camera1.fieldOfView - speed < 100.0f)
        {
            camera1.fieldOfView = fov + speed;
        }

        // double tap left to barrel roll
        //if (Input.GetAxis("Horizontal") == 1.0f && canCountL)
        //{
        //    timerL = 0.0f;
        //    ++counterL;
        //    canCountL = false;
        //}
        //if (timerL >= 0.2f)
        //{
        //    counterL = 0;
        //    timerL = 0.0f;
        //}
        //if (counterL == 2)
        //{
        //    Debug.Log("ROLL L");
        //}

        //// double tap right to barrel roll
        //if (Input.GetAxis("Horizontal") == -1.0f && canCountR)
        //{
        //    timerR = 0.0f;
        //    ++counterR;
        //    canCountR = false;
        //}
        //if (timerR >= 0.2f)
        //{
        //    counterR = 0;
        //    timerR = 0.0f;
        //}
        //if (counterR == 2)
        //{
        //    Debug.Log("ROLL R");
        //}
        
        //if (Input.GetAxis("Horizontal") < 0.2f && Input.GetAxis("Horizontal") > -0.2f)
        //{
        //    canCountL = true;
        //    canCountR = true;
        //}

        //timerL += Time.deltaTime;
        //timerR += Time.deltaTime;
    }

    IEnumerator cooldown(float _time)
    {
        yield return new WaitForSeconds(_time);
        CorrectRotation();
    }

    void CorrectRotation()
    {
        Vector3 locE = transform.localEulerAngles;

        // correcting rotation
        if (locE.z > 2 && locE.z < 100.0f)
        {
            transform.localEulerAngles = new Vector3(locE.x, locE.y, locE.z - 2.0f);
        }
        if (locE.z < 360 - 2 && locE.z > 200.0f)
        {
            transform.localEulerAngles = new Vector3(locE.x, locE.y, locE.z + 2.0f);
        }
    }

    void compensateXZ()
    {
        //COMPENSATE ONLY IN XZ PLANE
        Vector3 lookDirection = transform.rotation * new Vector3(0, 0, 1);

        Vector3 velocity = GetComponent<Rigidbody>().velocity;

        float desiredSpeed = Mathf.Min(maxSpeedXZPlane,
            Mathf.Sqrt(
                Mathf.Pow(velocity.y, 2.0f) 
                + Mathf.Pow(velocity.x, 2.0f)
                + Mathf.Pow(velocity.z, 2.0f)
            )
        );


        Vector3 CompenVec = ((lookDirection * desiredSpeed) - velocity) * 0.5f;

        GetComponent<Rigidbody>().velocity += CompenVec;
    }

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
