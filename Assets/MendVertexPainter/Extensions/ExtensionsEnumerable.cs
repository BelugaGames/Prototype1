/**
 * Author: Lee Hailey
 **/


using System.Collections.Generic;
using System.Linq;

/// <summary>
/// General Extensions for C# enumerable and array types
/// </summary>
namespace Extensions.Enumerable
{
   public static class Extension
   {
      /// <summary>
      /// Return true if empty
      /// </summary>
      /// <param name="source"></param>
      public static bool IsEmpty<T>(this IEnumerable<T> source)
      {
         return source.Count() == 0;
      }

      /// <summary>
      /// Return true if null
      /// </summary>
      /// <param name="source"></param>
      public static bool IsNull<T>(this IEnumerable<T> source)
      {
         return source == null;
      }

      /// <summary>
      /// Return true if null or empty
      /// </summary>
      /// <param name="source"></param>
      public static bool IsNullOrEmpty<T>(this IEnumerable<T> source)
      {
         return source == null || source.Count() == 0;
      }

      /// <summary>
      /// Return true if empty
      /// </summary>
      /// <param name="source"></param>
      public static bool IsEmpty<T>(this T[] source)
      {
         return source.Count() == 0;
      }

      /// <summary>
      /// Return true if null
      /// </summary>
      /// <param name="source"></param>
      public static bool IsNull<T>(this T[] source)
      {
         return source == null;
      }

      /// <summary>
      /// Return true if null or empty
      /// </summary>
      /// <param name="source"></param>
      public static bool IsNullOrEmpty<T>(this T[] source)
      {
         return source == null || source.Count() == 0;
      }
   }
}
