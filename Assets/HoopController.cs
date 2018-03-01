using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoopController : MonoBehaviour {

    [SerializeField]
    public LevelManager levelManager;

    public GameObject bird;

    [SerializeField]
    public int requiredSpeedLevel = 0;

    [SerializeField]
    private GameObject hoopModel;

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
            hoopModel.GetComponent<MeshRenderer>().material = green;
        }
        else if (requiredSpeedLevel == 2)
        {
            hoopModel.GetComponent<MeshRenderer>().material = blue;
        }
        else if (requiredSpeedLevel == 3)
        {
            hoopModel.GetComponent<MeshRenderer>().material = red;
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