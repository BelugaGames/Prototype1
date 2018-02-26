using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour {

    [SerializeField]
    public int points = 0;

    [SerializeField]
    public Text text;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        text.text = "Points: " + points.ToString();
	}

    public static int getSpeedLevel(float velocity)
    {
        if (velocity < 10) return 0;
        if (velocity < 30) return 1;
        if (velocity < 50) return 2;
        if (velocity < 70) return 3;
        else return 4;
        //10
        //30
        //50
        //70
    }
}
