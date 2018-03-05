using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudParticleController : MonoBehaviour, IQuadTreeObject {

    //Vector3 scaleBase;
    //float timeOffset;

    //[SerializeField]
    //public float radius = 0.4f;

    //public Vector3 velocity;

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

    //void Update()
    //{
    //    //float dist2 = (transform.position - Camera.main.transform.position).sqrMagnitude;
    //    //if (dist2 < visibilityDist2)
    //    //{
    //    //    if (!renderer.enabled)
    //    //        renderer.enabled = true;
    //    //}
    //    //else
    //    //{
    //    //    if (renderer.enabled)
    //    //        renderer.enabled = false;
    //    //}
    //    //renderer.enabled = dist2 < visibilityDist2;


    //}

        // Update is called once per frame
        //void Update () {
        //       //transform.LookAt(Camera.main.transform);
        //       //transform.localScale = scaleBase + Mathf.Sin(Time.fixedTime + timeOffset) * 0.1f * Vector3.one;
        //}

        //void FixedUpdate()
        //{
        //    velocity *= 0.9f;

        //    transform.position += velocity;
        //}

        public Vector2 GetQTPosition()
    {
        return new Vector2(transform.position.x, transform.position.z);
    }

    //public void addVel(Vector3 vel)
    //{

    //}
}
