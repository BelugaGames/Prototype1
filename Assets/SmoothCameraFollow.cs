using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmoothCameraFollow : MonoBehaviour {
    [SerializeField]
    private Transform targetObject;

    [SerializeField]
    private Vector3 targetOffset;

    [SerializeField]
    private Vector3 followOffset;

    private Vector3 lastTargetPosition;
    private Vector3 lastFollowPosition;

	// Use this for initialization
	void Start () {
        lastTargetPosition = targetObject.position + targetObject.rotation * targetOffset;
        lastFollowPosition = targetObject.position + targetObject.rotation * followOffset;
	}
	
	// Update is called once per frame
	void Update () {
        Vector3 targetPosition = targetObject.position + targetObject.rotation * targetOffset;
        Vector3 followPosition = targetObject.position + targetObject.rotation * followOffset;

        //Lerp between positions
        transform.position = Vector3.Lerp(lastFollowPosition, followPosition, Util.LerpSmooth(0.75f));

        Vector3 targetMidpoint = Vector3.Lerp(lastTargetPosition, targetPosition, Util.LerpSmooth(0.75f));

        transform.LookAt(targetMidpoint);

        //Update last variables
        lastTargetPosition = targetMidpoint;
        lastFollowPosition = transform.position;
    }
}
