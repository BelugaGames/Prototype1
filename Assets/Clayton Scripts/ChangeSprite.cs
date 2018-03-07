using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ChangeSprite : MonoBehaviour {

    public GameObject player;
    public Sprite unticked, ticked;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (player.GetComponent<movementController>().invertY == true)
        {
            gameObject.GetComponent<Image>().sprite = ticked;
        }
        else
        {
            gameObject.GetComponent<Image>().sprite = unticked;
        }
	}
}
