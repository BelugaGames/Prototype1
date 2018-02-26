using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudManager : MonoBehaviour
{

    [SerializeField]
    float step = 0.1f;

    [SerializeField]
    GameObject cloudParticleObj;

    [SerializeField]
    Vector3 cloudSize;

    [SerializeField]
    private Transform player;

    // Use this for initialization
    void Start()
    {
        for (float x = -cloudSize.x / 2; x < cloudSize.x / 2; x += step)
        {
            float densityX = Mathf.Abs(x) / (cloudSize.x / 2.0f);

            for (float z = -cloudSize.z / 2; z < cloudSize.z / 2; z += step)
            {
                float densityZ = Mathf.Abs(z) / (cloudSize.z / 2.0f);

                float h = Mathf.PerlinNoise(x, z);
                for (float y = -cloudSize.y / 2; y < h * cloudSize.y / 2; y += step)
                {
                    float densityY = Mathf.Abs(y) / (cloudSize.y / 2.0f);

                    float densityAvg = Mathf.Max(densityX * densityX, densityY * densityY, densityZ * densityZ);
                    Debug.Log(densityAvg);

                    densityAvg = 1.0f - densityAvg;

                    if (Random.Range(0.0f, 1.0f) < 0.33f * densityAvg)
                    {
                        var particle = GameObject.Instantiate(cloudParticleObj, transform.position + new Vector3(x, y, z), Quaternion.identity, transform);
                        particle.GetComponent<CloudParticleController>().player = player;
                    }
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {

    }
}
