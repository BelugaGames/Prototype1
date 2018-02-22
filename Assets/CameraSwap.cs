using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSwap : MonoBehaviour {
    [SerializeField]
    private Camera firstCamera;

    [SerializeField]
    private Camera secondCamera;

    private Camera thisCamera;
    
    private float lerpT = 0.0f;
    private float duration = 1.0f;

    private bool finishedTransition = true;


	// Use this for initialization
	void Start () {
        thisCamera = GetComponent<Camera>();
	}
	
	// Update is called once per frame
	void Update () {
        if (!finishedTransition)
        {
            lerpT += Time.deltaTime / duration;

            if (lerpT >= 1.0f)
            {
                secondCamera.enabled = true;
                thisCamera.enabled = false;
                finishedTransition = true;
            }

            float smoothT = GameUtil.LerpSmooth(lerpT);

            transform.position = Vector3.Lerp(firstCamera.transform.position, secondCamera.transform.position, smoothT);
            transform.rotation = Quaternion.Slerp(firstCamera.transform.rotation, secondCamera.transform.rotation, smoothT);

            thisCamera.fieldOfView = Mathf.Lerp(firstCamera.fieldOfView, secondCamera.fieldOfView, smoothT);
            thisCamera.nearClipPlane = Mathf.Lerp(firstCamera.nearClipPlane, secondCamera.nearClipPlane, smoothT);
            thisCamera.farClipPlane = Mathf.Lerp(firstCamera.farClipPlane, secondCamera.farClipPlane, smoothT);
        }
    }

    public void SmoothCameraSwap(Camera _firstCamera, Camera _secondCamera, float _duration)
    {
        thisCamera.CopyFrom(_firstCamera);

        _firstCamera.enabled = false;
        thisCamera.enabled = true;
        
        firstCamera = _firstCamera;
        secondCamera = _secondCamera;
        duration = _duration;

        lerpT = 0.0f;

        finishedTransition = false;
    }
}
