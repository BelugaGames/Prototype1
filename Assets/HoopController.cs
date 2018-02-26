using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoopController : MonoBehaviour {

    [SerializeField]
    public LevelManager levelManager;

    [SerializeField]
    public int requiredSpeedLevel = 0;

	// Use this for initialization
	void Start () {
		
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
