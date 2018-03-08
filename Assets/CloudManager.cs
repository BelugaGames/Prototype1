using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudManager : MonoBehaviour
{

    [SerializeField]
    float step = 0.1f;

    [SerializeField]
    GameObject[] cloudParticleObjs;

    [SerializeField]
    Vector3 cloudSize;

    [SerializeField]
    private Transform player;

    [SerializeField]
    private float[] particleSize;

    private QuadTree<CloudParticleController> cloudQT;
    private float particleCollisionDist;
    private float particleCollisionDist2;

    [SerializeField]
    private float visibilityDist = 750;


    public bool destroyingClouds = false;
    private int currentIndex = 0;
    float timerAccum = 0.0f;
    float timeMax = 0.001f;
    private int indexStep;


    // Use this for initialization
    void Start()
    {
        cloudQT = new QuadTree<CloudParticleController>(10, new Rect(-1500, -1500, 1500 * 2, 1500 * 2));

        particleCollisionDist = 0.4f * particleSize[0];
        particleCollisionDist2 = particleCollisionDist * particleCollisionDist;


        for (float x = -cloudSize.x / 2; x < cloudSize.x / 2; x += step)
        {
            //float distX = Mathf.Abs(x);

            for (float z = -cloudSize.z / 2; z < cloudSize.z / 2; z += step)
            {
                //float distZ = Mathf.Abs(z);

                float n = Mathf.PerlinNoise(-x * 25.01f, -z * 25.01f);
                //Debug.Log(n);
                //if (n < 0.75) continue;

                //if (distX * distX + distZ * distZ > Mathf.Pow(cloudSize.x / 2, 2.0f)) continue;

                float h = Mathf.PerlinNoise(x * 1.1f, z * 1.1f) * 2.0f;
                for (float y = 0; y < h * cloudSize.y; y += step)
                {
                    float densityY = Mathf.Abs(y) / (cloudSize.y / 2.0f);


                    //float densityAvg = Mathf.Max(densityX * densityX, densityY * densityY, densityZ * densityZ);

                    // densityAvg = 1.0f - densityAvg;


                    if (Random.Range(0.0f, 1.0f) < 1.0f)
                    {
                        int particleIndex = (int)Random.Range(0.0f, (float)cloudParticleObjs.Length - 0.00001f);
                        var particlePrefab = cloudParticleObjs[particleIndex];

                        var randomVec = Random.insideUnitSphere * step;

                        var particle = GameObject.Instantiate(particlePrefab, transform.position + new Vector3(x, y, z) + randomVec, Random.rotation, transform);
                        
                        particle.transform.localScale = new Vector3(
                            particleSize[particleIndex] * Random.Range(0.5f, 1.5f), 
                            particleSize[particleIndex] * Random.Range(0.5f, 1.5f), 
                            particleSize[particleIndex] * Random.Range(0.5f, 1.5f));
                        var cloudParticleController = particle.GetComponent<CloudParticleController>();
                        //cloudParticleController.player = player;
                        cloudQT.Insert(cloudParticleController);
                    }
                }
            }
        }

        float[] cullDistances = new float[32];
        cullDistances[LayerMask.NameToLayer("Clouds")] = visibilityDist;
        Camera.main.layerCullDistances = cullDistances;

        indexStep = transform.childCount / 500;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            destroyingClouds = true;
        }

        if (destroyingClouds)
        {
            Debug.Log(currentIndex);

            if (timerAccum >= timeMax)
            {
                int numTimes = (int)(timerAccum / timeMax);

                for (int i = 0; i < numTimes; ++i)
                {
                    if (currentIndex >= transform.childCount - 1)
                    {
                        currentIndex = 0;
                    }

                    int stopIndex = Mathf.Min(currentIndex + indexStep, transform.childCount - 1);

                    for (; currentIndex < stopIndex; ++currentIndex)
                    {
                        if (Random.Range(0.0f, 1.0f) < 0.25f)
                        {
                            transform.GetChild(currentIndex).gameObject.SetActive(false);
                        }
                    }
                }                

                timerAccum = 0.0f;
            }

            timerAccum += Time.deltaTime;
        }
    }

    void FixedUpdate()
    {
        Vector3 playerPosition = player.transform.position;
        float bufferSize = particleCollisionDist + 2.0f;

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
                //particle.velocity += -delNorm * 2.0f;
                particle.transform.position = player.position - delNorm * (Mathf.Sqrt(d2) + 5.0f);
            }
        }
    }
}
