using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudParticleController : MonoBehaviour {

    Vector3 scaleBase;
    Rigidbody rigidbody;

	// Use this for initialization
	void Start () {
        scaleBase = transform.localScale;
        rigidbody = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () {
        transform.LookAt(Camera.main.transform);
        transform.localScale = scaleBase + Mathf.Sin(Time.fixedTime) * 0.1f * Vector3.one;
	}

    void FixedUpdate()
    {
        rigidbody.velocity *= 0.9f;
    }
}
