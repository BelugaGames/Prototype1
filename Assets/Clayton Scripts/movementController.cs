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
        target.z += 0.1f * Input.GetAxis("Horizontal") * tiltAngle;
        target.x += 0.1f * Input.GetAxis("Vertical") * tiltAngle;
        

        if (Input.GetAxis("Horizontal_right") < 0)
        {
           // rotAroundY = GetComponent<Transform>().rotation.y - 0.1f;
            target.y -= 1.0f;
        }
        else if (Input.GetAxis("Horizontal_right") > 0)
        {
           // rotAroundY = GetComponent<Transform>().rotation.y + 0.1f;
            target.y += 1.0f;
        }

        //target = new Vector3(tiltAroundX, target.y, tiltAroundZ);
        // transform.rotation = new Quaternion(transform.rotation.x, transform.rotation.y, transform.rotation.z, 1.0f);
        //transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.Euler(target), Time.deltaTime * smooth);

        transform.rotation = Quaternion.Euler(target);

        liftVector = calculateL();
        liftCoefficient = calculateLCoefficient(GetComponent<Rigidbody>().velocity, liftVector);
        liftMagnitude = calculateLMag(GetComponent<Rigidbody>().velocity.magnitude);

        if (liftMagnitude > 8000)
        {
            liftMagnitude = 8000;
        }

       GetComponent<Rigidbody>().AddForceAtPosition(liftVector * liftMagnitude, transform.position + new Vector3(0, 0, 0.0f));

        if (flapProgress <= flapDuration)
        {
            flapProgress += Time.fixedDeltaTime;

            GetComponent<Rigidbody>().AddForce(liftVector * flapFunc(flapProgress / flapDuration) * 20000.0f);
        }
        else
        {
            if (Input.GetButtonDown("Flap"))
            {
                flapProgress = 0.0f;
            }
        }
    }

    Vector3 calculateL()
    {
        return (transform.rotation * new Vector3(0, 1, 0)).normalized;
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
