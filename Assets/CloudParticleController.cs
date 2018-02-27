using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudParticleController : MonoBehaviour, IQuadTreeObject {

    //Vector3 scaleBase;
    //float timeOffset;

    //[SerializeField]
    //public float radius = 0.4f;

    //private Vector3 velocity;

    //private bool updateThisFrame;

	// Use this for initialization
	//void Start () {
 //       scaleBase = transform.localScale;
 //       timeOffset = Random.Range(0.0f, 10.0f);
 //       updateThisFrame = Random.value < 0.5f;
	//}

    void Start()
    {
        float randScale = Random.Range(0.5f, 1.5f);
        GetComponent<MeshRenderer>().material.SetFloat("_ScaleX", transform.localScale.x * randScale);
        GetComponent<MeshRenderer>().material.SetFloat("_ScaleY", transform.localScale.y * randScale);
    }
	
	// Update is called once per frame
	//void Update () {
 //       //transform.LookAt(Camera.main.transform);
 //       //transform.localScale = scaleBase + Mathf.Sin(Time.fixedTime + timeOffset) * 0.1f * Vector3.one;
	//}

    //void FixedUpdate()
    //{
    //        //velocity *= 0.9f;

    //        //Vector3 del = player.position - transform.position;
    //        //float d2 = del.sqrMagnitude;

    //        //if (d2 < (radius * transform.localScale.x) * (radius * transform.localScale.x))
    //        //{
    //        //    Vector3 delNorm = del.normalized;
    //        //    velocity -= delNorm * 2.0f;
    //        //    transform.position = player.position - delNorm * (d2 + 0.01f);
    //        //}
    //}

    public Vector2 GetQTPosition()
    {
        return new Vector2(transform.position.x, transform.position.z);
    }

    //public void addVel(Vector3 vel)
    //{

    //}
}
