using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestScript : MonoBehaviour {

    [SerializeField]
    public Camera cam2;

	// Use this for initialization
	void Start () {
        Debug.Log("Test script started");
        GameObject.Find("CameraSwapper").GetComponent<CameraSwap>().SmoothCameraSwap(Camera.main, cam2, 1.0f);
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
