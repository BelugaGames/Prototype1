using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoopCollectionManager : MonoBehaviour {

    [SerializeField]
    private BoxCollider colliderToRemove;

    bool ringsHaveGone = false;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (transform.childCount == 0 && !ringsHaveGone)
        {
            ringsHaveGone = true;

            // do the thing after getting all the rings
            Debug.Log("The Rings are gone!");

            colliderToRemove.enabled = false;
        }
	}
}
