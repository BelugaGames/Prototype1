/**
* Author: Lee Hailey
**/


using System;

/// <summary>
/// General Extensions for Unity
/// </summary>
namespace Extensions.Unity
{
   using Color32 = UnityEngine.Color32;

   public static class Extension
   {
      /// <summary>
      /// Create clone of Color32
      /// </summary>
      /// <param name="src"></param>
      public static Color32 Clone(this Color32 src)
      {
         Color32 dest = new Color32(src.r, src.g, src.b, src.a);
         return dest;
      }
   }
}
