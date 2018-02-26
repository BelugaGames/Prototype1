using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour {

    [SerializeField]
    public int points = 0;

    [SerializeField]
    private Text pointsText,
        speedText;

    [SerializeField]
    private float 
        speedStage1 = 10.0f,
        speedStage2 = 30.0f,
        speedStage3 = 50.0f;

    [SerializeField]
    private Rigidbody player;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        pointsText.text = "Points: " + points.ToString();
        speedText.text = "Speed: " + getSpeedLevel(player.GetComponent<Rigidbody>().velocity.magnitude).ToString();
	}

    public int getSpeedLevel(float velocity)
    {
        if (velocity < speedStage1) return 0;
        if (velocity < speedStage2) return 1;
        if (velocity < speedStage3) return 2;
        else return 3;
    }
}
