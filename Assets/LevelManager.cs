using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour {

    [SerializeField]
    public int points = 0;

    [SerializeField]
    private Text text;

    [SerializeField]
    private float 
        speedStage1 = 10.0f,
        speedStage2 = 30.0f,
        speedStage3 = 50.0f;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        text.text = "Points: " + points.ToString();
	}

    public int getSpeedLevel(float velocity)
    {
        if (velocity < speedStage1) return 0;
        if (velocity < speedStage2) return 1;
        if (velocity < speedStage3) return 2;
        else return 3;
    }
}
