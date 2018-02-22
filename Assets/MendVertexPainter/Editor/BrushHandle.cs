/**
 * Author: Lee Hailey
 * Date: 2016
 */

using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace EditorExtension
{

   /// <summary>
   /// Class for translating mouse inputs into scene view space.
   /// It contains methods to choose the vertices that a brush of a given size should affect.
   /// </summary>
   public class BrushHandle
   {
      #region Variables

      // constants
      const float ScreenFovUnitConversion = .0062f;

      // control properties
      public bool BackFaceEditing { get; set; }
      public Color BrushColor { get; set; }
      public float BrushSize
      {
         get {return brushSizeEditorFovPercentage;}
         set
         {
            brushSizeEditorFovPercentage = value;
            brushFovSize = value / 100f;
         }
      }

      // member vars
      protected float brushSizeEditorFovPercentage;
      protected float brushFovSize;
      Transform bufferedXfrm = null;
      protected Vector3[] bufferedXfrmVerts = null;
      protected Vector3[] bufferedXfrmNorms = null;

      #endregion Variables


      #region Methods

      /// <summary>
      /// Constructor
      /// </summary>
      public BrushHandle()
      {
         BrushColor = Color.blue;
      }

      /// <summary>
      /// Get the ray cast from the SceneView camera from the mouse position.
      /// Handles both perspective and orthographic view.
      /// </summary>
      /// <param name="mousePos"></param>
      /// <returns></returns>
      public static Ray GetMouseRay(Vector2? mousePos = null)
      {
         mousePos = mousePos ?? Event.current.mousePosition;
         Ray mouseRay = HandleUtility.GUIPointToWorldRay(mousePos.Value);

         return mouseRay;
      }

      /// <summary>
      /// Show brush in scene view at the mouse position
      /// </summary>
      /// <param name="mouseRay"></param>
      public void showBrush(Ray? mouseRay = null)
      {
         mouseRay = mouseRay ?? GetMouseRay();
         Camera sceneCam = SceneView.currentDrawingSceneView.camera;

         // draw circle representing brush with a radius that matches
         if (sceneCam.orthographic) {
            Vector3 endPoint = mouseRay.Value.origin + (mouseRay.Value.direction * 100);
            float factor2DToGeometric = SceneView.currentDrawingSceneView.camera.pixelRect.height
               * HandleUtility.GetHandleSize(endPoint)
               * ScreenFovUnitConversion;

            Handles.color = BrushColor;
            Handles.DrawWireDisc(
               mouseRay.Value.origin + (mouseRay.Value.direction * 100),
               mouseRay.Value.direction,
               brushFovSize * factor2DToGeometric);
            SceneView.currentDrawingSceneView.Repaint();

         } else {
            float discSize = Mathf.Tan(Mathf.Deg2Rad * brushFovSize * sceneCam.fieldOfView / 2);

            Handles.color = BrushColor;
            Handles.DrawWireDisc(
               sceneCam.transform.position + (mouseRay.Value.direction),
               sceneCam.transform.rotation * Vector3.forward,
               discSize);
         }

         SceneView.currentDrawingSceneView.Repaint();
      }

      /// <summary>
      /// Get the set of verts in the brush radius and the brush stroke weights for given brush configuration
      /// </summary>
      /// <param name="mesh"></param>
      /// <param name="meshTransform"></param>
      /// <param name="ray"></param>
      /// <returns></returns>
      public Dictionary<int, float> GetEnclosedVerts(Mesh mesh, Transform meshTransform, Ray ray)
      {
         // Assume the mesh will not change frequently and cach the mesh with applied transforms
         if (! meshTransform.Equals(bufferedXfrm)) {
            bufferedXfrmVerts = new Vector3[mesh.vertices.Length];
            for (int v = 0; v < bufferedXfrmVerts.Length; v++) {
               bufferedXfrmVerts[v] = meshTransform.TransformPoint(mesh.vertices[v]);
            }

            bufferedXfrmNorms = new Vector3[mesh.normals.Length];
            for (int n = 0; n < bufferedXfrmNorms.Length; n++) {
               bufferedXfrmNorms[n] = meshTransform.TransformPoint(mesh.normals[n]);
            }
            bufferedXfrm = meshTransform;
         }
         return GetEnclosedVerts(bufferedXfrmVerts, bufferedXfrmNorms, ray);
      }

      /// <summary>
      /// Get the set of verts in the brush radius and the brush stroke weights for given brush configuration
      /// </summary>
      /// <param name="mesh"></param>
      /// <param name="ray"></param>
      /// <returns></returns>
      public Dictionary<int, float> GetEnclosedVerts(Mesh mesh, Ray ray)
      {
         // exit condition
         if (mesh == null || mesh.vertices == null || mesh.normals == null) {
            Debug.LogError("Mesh or mesh vertices or mesh normals is null.");
            return null;
         }
         return GetEnclosedVerts(mesh.vertices, mesh.normals, ray);
      }

      /// <summary>
      /// Get the set of verts in the brush radius and the brush stroke weights for given brush configuration
      /// </summary>
      /// <param name="verts"></param>
      /// <param name="norms"></param>
      /// <param name="mouseRay"></param>
      /// <returns></returns>
      public Dictionary<int, float> GetEnclosedVerts(Vector3[] verts, Vector3[] norms, Ray mouseRay)
      {
         // exit condition
         if (verts == null || norms == null) {
            Debug.LogError("Vertices or normals is null.");
            return null;
         }
         if (verts.Length > norms.Length) {
            Debug.LogError("Found more vertices than normals.");
            return null;
         }

         // define inputs
         Vector3 A = mouseRay.origin;
         Vector3 B = mouseRay.origin + (mouseRay.direction * 100);
         Camera sceneCam = SceneView.currentDrawingSceneView.camera;
         // compute brush size to geometric size; screen size * vert z depth size * screen FOV unit size conversion
         float factor2DToGeometric = sceneCam.pixelRect.height * HandleUtility.GetHandleSize(B) * ScreenFovUnitConversion;
         float distBrush = brushFovSize * factor2DToGeometric;
         bool isOrthographic = sceneCam.orthographic;
         int v = 0;
         //Debug.Log(String.Format("ray.direction: {2}  A: {0};  B: {1}", A, B, ray.direction));

         // find all brush affected verts and their distance from mouse ray as result
         var brushedVerts = new Dictionary<int, float>();
         foreach (var vert in verts) {

            // the points for distance calculation will be denoted as: c=camera, p=vertex, i=mouselineinstersect
            // may be a simpler faster way of doing pathagorean calculation
            float distPI = HandleUtility.DistancePointLine(vert, A, B);
            float distCP = Vector3.Distance(A, vert);
            float distCI = Mathf.Sqrt(distCP*distCP - distPI*distPI);

            // must recalculate vertex brush distance in perspective view
            if (!isOrthographic) {
               distBrush = distCI * Mathf.Tan(Mathf.Deg2Rad * brushFovSize * sceneCam.fieldOfView/2);
               //Debug.Log(String.Format("|CP|: {0:F2}  |CI|: {1:F2}  |PI|: {2:F2}\ndistBrush: {3:F2}\nfov: {4:F3}\nfov%: {5}\ntanratio: {6}",
               //   distCP, distCI, distPI, distBrush, sceneCam.fieldOfView, brushFovPercentage, Mathf.Tan(Mathf.Deg2Rad * brushFovPercentage * sceneCam.fieldOfView/2)));
            }

            // add {vert index, dist} to dictionary result if within brush bounds; ignore back facing verts if needed
            if (distPI < distBrush
            &&  (BackFaceEditing
            ||   Vector3.Dot(norms[v], mouseRay.direction) <= 0f)) {
               brushedVerts.Add(v, (brushFovSize - distPI) / brushFovSize);
            }

            v++;
         }

         return brushedVerts;
      }

      #endregion Methods
   }
}
