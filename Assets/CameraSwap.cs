using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSwap : MonoBehaviour {

    [SerializeField]
    private static GameObject prefabDefaultCamera;

    [SerializeField]
    private Camera firstCamera;

    [SerializeField]
    private Camera secondCamera;

    private Camera thisCamera;

    private bool finishedTransition = true;
    
    private float lerpT = 0.0f;
    private float duration = 1.0f;


	// Use this for initialization
	void Start () {
        thisCamera = GetComponent<Camera>();
	}
	
	// Update is called once per frame
	void Update () {
        lerpT += Time.deltaTime / duration;
        
        if (lerpT >= 1.0f)
        {
            finishedTransition = true;
            secondCamera.enabled = true;
            GameObject.Destroy(this);
        }

        float smoothT = Util.LerpSmooth(lerpT);

        transform.position = Vector3.Lerp(firstCamera.transform.position, secondCamera.transform.position, smoothT);
        transform.rotation = Quaternion.Slerp(firstCamera.transform.rotation, secondCamera.transform.rotation, smoothT);

        thisCamera.fieldOfView = Mathf.Lerp(firstCamera.fieldOfView, secondCamera.fieldOfView, smoothT);
        thisCamera.nearClipPlane = Mathf.Lerp(firstCamera.nearClipPlane, secondCamera.nearClipPlane, smoothT);
        thisCamera.farClipPlane = Mathf.Lerp(firstCamera.farClipPlane, secondCamera.farClipPlane, smoothT);
    }

    public static void SmoothCameraSwap(Camera currentCamera, Camera newCamera, float _duration)
    {
        currentCamera.enabled = false;

        GameObject tempCamera = GameObject.Instantiate<GameObject>(prefabDefaultCamera);
        var cameraSwap = tempCamera.AddComponent<CameraSwap>();
        cameraSwap.firstCamera = currentCamera;
        cameraSwap.secondCamera = newCamera;
        cameraSwap.duration = _duration;
    }
}
