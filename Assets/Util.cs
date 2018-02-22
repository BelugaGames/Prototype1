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
}