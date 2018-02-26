using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudParticleController : MonoBehaviour {

    Vector3 scaleBase;
    float timeOffset;

    [SerializeField]
    public float radius = 0.4f;

    [SerializeField]
    private Transform player;

    private Vector3 velocity;

	// Use this for initialization
	void Start () {
        scaleBase = transform.localScale;
        timeOffset = Random.Range(0.0f, 10.0f);
	}
	
	// Update is called once per frame
	void Update () {
        transform.LookAt(Camera.main.transform);
        //transform.localScale = scaleBase + Mathf.Sin(Time.fixedTime + timeOffset) * 0.1f * Vector3.one;
	}

    void FixedUpdate()
    {
        velocity *= 0.9f;

        Vector3 del = player.position - transform.position;
        float d2 = del.sqrMagnitude;

        if (d2 < (radius * transform.localScale.x) * (radius * transform.localScale.x))
        {
            Vector3 delNorm = del.normalized;
            velocity -= delNorm * 2.0f;
            transform.position = player.position - delNorm * (d2 + 0.01f);
        }
    }
}
