using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTargeter : MonoBehaviour {

    struct PosRot
    {
        public Vector3 position;
        public Quaternion rotation;

        public PosRot(Transform _t)
        {
            position = _t.position;
            rotation = _t.rotation;
        }
    }


    [SerializeField]
    private Transform currentTarget;

    private bool finishedTransition = true;

    private PosRot? oldTarget;
    private float lerpT = 0.0f;
    private float duration = 1.0f;


	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
        lerpT += Time.deltaTime / duration;
        
        if (lerpT >= 1.0f)
        {
            finishedTransition = true;
            oldTarget = null;
        }

        if (!finishedTransition && oldTarget.HasValue)
        {
            PosRot _oldTarget = oldTarget.Value;

            transform.position = Vector3.Lerp(_oldTarget.position, currentTarget.position, lerpT);
            transform.rotation = Quaternion.Slerp(_oldTarget.rotation, currentTarget.rotation, lerpT);
        }
	}

    public void ChangeTarget(Transform _newTarget, float _duration)
    {
        oldTarget = new PosRot(currentTarget);
        currentTarget = _newTarget;
        duration = _duration;
        finishedTransition = false;
        lerpT = 0.0f;
    }
}
