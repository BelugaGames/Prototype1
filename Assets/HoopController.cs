using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoopController : MonoBehaviour {

    [SerializeField]
    public LevelManager levelManager;

    [SerializeField]
    public int requiredSpeedLevel = 0;

    [SerializeField]
    private GameObject hoopModel;

    public Material green;
    public Material blue;
    public Material red;

    // Use this for initialization
    void Start () {

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
	void Update () {
		
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
        }

        Debug.Log("Hoop triggered");
    }
}
