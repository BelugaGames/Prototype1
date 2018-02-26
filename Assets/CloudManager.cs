using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudManager : MonoBehaviour
{

    [SerializeField]
    float step = 0.1f;

    [SerializeField]
    GameObject cloudParticleObj;

    SimplexNoiseGenerator simplexNoise;

    // Use this for initialization
    void Start()
    {
        simplexNoise = new SimplexNoiseGenerator();

        for (float x = 0; x < 10; x += step)
        {
            for (float y = 0; y < 10; y += step)
            {
                for (float z = 0; z < 10; z += step)
                {
                    int density = simplexNoise.getDensity(new Vector3(x, y, z));
                    Debug.Log(density);
                    if (density > 127)
                    {
                        GameObject.Instantiate(cloudParticleObj, transform.position + new Vector3(x, y, z), Quaternion.identity, transform);
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
