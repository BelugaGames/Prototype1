﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoopController : MonoBehaviour {

    [SerializeField]
    public LevelManager levelManager;

    [SerializeField]
    private AudioSource hoopPos, hoopNeg;

    public GameObject bird;

    [SerializeField]
    public int requiredSpeedLevel = 0;

    [SerializeField]
    private GameObject hoopModel;
    [SerializeField]
    private GameObject hoopModel2;

    public Material green;
    public Material blue;
    public Material red;

    public bool grantSpeed;
    bool boosting;
    public float flapDuration = 1.0f;
    float flapProgress = 100000.0f;
    public float flapForce = 120.0f;

    // Use this for initialization
    void Start () {
        levelManager.numHoops++;

		if (requiredSpeedLevel == 1)
        {
            hoopModel.GetComponent<MeshRenderer>().material.SetColor("_glowcolor", new Color(0, 1, 0));
            hoopModel2.GetComponent<MeshRenderer>().material.SetColor("_glowcolor", new Color(0, 1, 0));
        }
        else if (requiredSpeedLevel == 2)
        {
            hoopModel.GetComponent<MeshRenderer>().material.SetColor("_glowcolor", new Color(0, 0, 1));
            hoopModel2.GetComponent<MeshRenderer>().material.SetColor("_glowcolor", new Color(0, 0, 1));
        }
        else if (requiredSpeedLevel == 3)
        {
            hoopModel.GetComponent<MeshRenderer>().material.SetColor("_glowcolor", new Color(1, 0, 0));
            hoopModel2.GetComponent<MeshRenderer>().material.SetColor("_glowcolor", new Color(1, 0, 0));
        }
    }
	
	// Update is called once per frame
	void FixedUpdate () {
        if (boosting)
        {
            if (flapProgress <= flapDuration)
            {
                flapProgress += Time.fixedDeltaTime;
                bird.GetComponent<Rigidbody>().AddForce((transform.rotation * new Vector3(0, 1.0f, 0)) * flapFunc(flapProgress / flapDuration) * flapForce);
            }
            else
            {
                boosting = false;
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            int playerSpeedLevel = levelManager.getSpeedLevel(other.GetComponent<Rigidbody>().velocity.magnitude);

            if (playerSpeedLevel >= requiredSpeedLevel)
            {
                levelManager.points += 1;
                GameObject.Destroy(gameObject);
                hoopPos.Play();
            }
            else
            {
                hoopNeg.Play();
            }

            if (grantSpeed)
            {
                flapProgress = 0.0f;
                boosting = true;
            }
        }
    }

    float flapFunc(float _t)
    {
        return -Mathf.Pow((_t * 2.0f) - 1.0f, 2) + 1.0f;
    }
}