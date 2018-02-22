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

    [SerializeField]
    private float objectCollisionBufferSize = 1.0f;

    private Vector3 lastTargetPosition;
    private Vector3 lastFollowPosition;

	// Use this for initialization
	void Start () {
        lastTargetPosition = targetObject.position + targetObject.rotation * targetOffset;
        lastFollowPosition = targetObject.position + targetObject.rotation * followOffset;
	}

    // Update is called once per frame
    void Update()
    {
        //CURRENT POSITIONS
        Vector3 targetPosition = targetObject.position + targetObject.rotation * targetOffset;

        Vector3 followPosition = targetObject.position + targetObject.rotation * followOffset;

        //FIND MIDPOINT POSITIONS
        Vector3 followMidpoint = Vector3.Lerp(lastFollowPosition, followPosition, GameUtil.LerpSmooth(0.25f));
        Vector3 targetMidpoint = Vector3.Lerp(lastTargetPosition, targetPosition, GameUtil.LerpSmooth(0.25f));

        Vector3 followMidpointWithRaycast = followMidpoint;

        //Raycast for follow position midpoint
        Debug.DrawRay(targetMidpoint, followMidpoint - targetMidpoint);
        RaycastHit hit;
        if (Physics.Raycast(targetMidpoint, followMidpoint - targetMidpoint, out hit, (followMidpoint - targetMidpoint).magnitude))
        {
            //We hit an object
            Vector3 hitPosition = hit.point;
            followMidpointWithRaycast = hitPosition + hit.normal * objectCollisionBufferSize;
        }

        //SET POSITIONS
        transform.position = followMidpointWithRaycast;
        transform.LookAt(targetMidpoint);

        //Update last variables
        lastTargetPosition = targetMidpoint;
        lastFollowPosition = followMidpoint;
    }
}
