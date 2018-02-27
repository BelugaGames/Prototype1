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

    [SerializeField]
    private float particleSize;

    private QuadTree<CloudParticleController> cloudQT;
    private float particleCollisionDist2;

    // Use this for initialization
    void Start()
    {
        cloudQT = new QuadTree<CloudParticleController>(10, new Rect(-1300, -1300, 1300 * 2, 1300 * 2));

        particleCollisionDist2 = 0.4f * particleSize;
        particleCollisionDist2 *= particleCollisionDist2;


        for (float x = -cloudSize.x / 2; x < cloudSize.x / 2; x += step)
        {
            float distX = Mathf.Abs(x);

            for (float z = -cloudSize.z / 2; z < cloudSize.z / 2; z += step)
            {
                float distZ = Mathf.Abs(z);

                float n = Mathf.PerlinNoise(-x * 25.01f, -z * 25.01f);
                Debug.Log(n);
                //if (n < 0.75) continue;

                if (distX * distX + distZ * distZ > Mathf.Pow(cloudSize.x / 2, 2.0f)) continue;

                float h = Mathf.PerlinNoise(x * 50.01f, z * 50.01f);
                for (float y = 0; y < h * cloudSize.y; y += step)
                {
                    float densityY = Mathf.Abs(y) / (cloudSize.y / 2.0f);


                    //float densityAvg = Mathf.Max(densityX * densityX, densityY * densityY, densityZ * densityZ);

                    // densityAvg = 1.0f - densityAvg;


                    if (Random.Range(0.0f, 1.0f) < 1.0f)
                    {
                        var particle = GameObject.Instantiate(cloudParticleObj, transform.position + new Vector3(x, y, z), Quaternion.identity, transform);
                        particle.transform.localScale = new Vector3(particleSize, particleSize, particleSize);
                        var cloudParticleController = particle.GetComponent<CloudParticleController>();
                        //cloudParticleController.player = player;
                        cloudQT.Insert(cloudParticleController);
                    }
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

    void FixedUpdate()
    {
        Vector3 playerPosition = player.transform.position;
        const float bufferSize = 5.0f;

        var particles = cloudQT.RetrieveObjectsInArea(new Rect(playerPosition.x - bufferSize, playerPosition.z - bufferSize, 2.0f * bufferSize, 2.0f * bufferSize));
        foreach (CloudParticleController particle in particles)
        {
            //Check for collision
            Vector3 particlePosition = particle.transform.position;

            Vector3 del = playerPosition - particlePosition;
            float d2 = del.sqrMagnitude;

            if (d2 < particleCollisionDist2)
            {
                Vector3 delNorm = del.normalized;
                //particle.addVel(-delNorm * 2.0f);
                particle.transform.position = player.position - delNorm * (d2 + 0.25f);
            }
        }
    }
}
