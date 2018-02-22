/**
 * Author: Lee Hailey
 **/


using System;
using System.Reflection;
using System.ComponentModel;
using Extensions.Enumerable;


/// <summary>
/// General Extensions for C# enum type
/// </summary>
namespace Extensions.Enum
{
   public static class Extension
   {
      /// <summary>
      /// Get objects description attribute or object name if it does not exist
      /// </summary>
      /// <param name="value"></param>
      public static string GetDescription(this Object value)
      {
         FieldInfo fi = value.GetType().GetField(value.ToString());

         var attributes = (DescriptionAttribute[])fi.GetCustomAttributes(
             typeof(DescriptionAttribute),
             false);

         return attributes.IsNullOrEmpty() ? value.ToString() : attributes[0].Description;
      }
   }
}