using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEngine;

class GameUtil
{
    public static float LerpSmooth(float t)
    {
        return t * t * t * (t * (6f * t - 15f) + 10f);
    }

    public static float PerlinNoise(float x, float y, float z)
    {
        float noiseXY = Mathf.PerlinNoise(x, y);
        float noiseZ = Mathf.PerlinNoise(z + 1000, 0.0f);

        return (noiseXY + noiseZ) / 2.0f;
    }
}