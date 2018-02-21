/**
 * The MIT License (MIT)
 * Copyright (c) 2013 Banbury
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Origin: https://github.com/Banbury/UnitySpritesAndBones
 */
/**
 * Substantial rework for vertex color editing
 * Author: Lee Hailey
 * Date: 2016
 */


#pragma warning disable 0162

using System;
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using Extensions.Enum;
using Extensions.Unity;




using TChannelLocks = System.Collections.Generic.Dictionary<EditorExtension.EChannel, bool>;
using HSBColor = Util.HSBColor;
using Mods = UnityEngine.EventModifiers;
using System.Reflection;

namespace EditorExtension
{
   /// <summary>
   /// Container for
   /// </summary>
   public struct Hotkey
   {
      public UnityEngine.EventType EventType;
      public UnityEngine.KeyCode Key;
      public UnityEngine.EventModifiers Modifiers;

      public override String ToString()
      {
         return String.Format(" ({0}{1}{2})",
            Modifiers,
            EventType == EventType.scrollWheel ? "+" + "MouseWheel" : "",
            Key != KeyCode.None ? "+" + Key.ToString().Replace("Alpha", "") : "");
      }
   };

   /// <summary>
   /// Vertex edit modes. Currently only supporting vertex color editing.
   /// </summary>
   public enum EBrushMode
   {
      VertexColor, WeightIndex, BoneInfluence
   }

   /// <summary>
   /// Channel lock modes
   /// </summary>
   public enum EChannelLockMode
   {
      RGB, HSV//, V
   }

   /// <summary>
   /// Available color channels
   /// </summary>
   public enum EChannel
   {
      [Description("Red")]                R,
      [Description("Green")]              G,
      [Description("Blue")]               B,
      [Description("Hue")]                H,
      [Description("Saturation")]         S,
      [Description("Value/Brightness")]   V,
      [Description("Alpha")]              A
   }

   /// <summary>
   /// Available hotkey actions
   /// </summary>
   public enum EHotkeyAction
   {
      TogglePaint,
      SaveMesh,
      ToggleSaveMeshMode,
      ToggleShowVertColor,
      ToggleBackFaceEditing,
      ResizeBrush,
      RescaleStrength,
      None
   }

   /// <summary>
   /// Supported brush stroke types
   /// </summary>
   public enum EBrushFunction
   {
      [Description("Apply selected color")]
      Value,
      [Description("Add to vertex color")]
      Add,
      [Description("Subtract from vertex color")]
      Subtract,
      //[Description("Add to vertex color in steps")]
      //StepAdd,
      //[Description("Subtract from vertex color in steps")]
      //StepSubtract,
      //[Description("StepRound")]
      //StepRound,
      [Description("Average affected vertices")]
      Average,
      [Description("Apply random color to each vertex")]
      Random
   }


   /// <summary>
   /// Vertex paint editor which supports a variety of brush types and flexible channel editing controls
   /// </summary>
   public class VertexPaintEditor : EditorWindow
   {
      /// <summary>
      /// Mapping for color mode to its available channels
      /// </summary>
      public Dictionary<EChannelLockMode, EChannel[]> ModeChannels = new Dictionary<EChannelLockMode, EChannel[]>
      {
         {EChannelLockMode.RGB,    new EChannel[]{EChannel.R, EChannel.G, EChannel.B, EChannel.A}},
         {EChannelLockMode.HSV,    new EChannel[]{EChannel.H, EChannel.S, EChannel.V, EChannel.A}},
         //{EColorMode.V,      new EChannel[]{EChannel.V, EChannel.A}}
      };

      /// <summary>
      /// Hotkey definitions mapped to actions
      /// </summary>
      public Dictionary<EHotkeyAction, Hotkey> HotKeys = new Dictionary<EHotkeyAction, Hotkey>
      {
         {  EHotkeyAction.TogglePaint,
            new Hotkey { EventType = EventType.KeyDown,       Key = KeyCode.Alpha1,   Modifiers = Mods.Alt } },

         {  EHotkeyAction.ToggleShowVertColor,
            new Hotkey { EventType = EventType.KeyDown,       Key = KeyCode.Alpha2,   Modifiers = Mods.Alt } },

         {  EHotkeyAction.ToggleBackFaceEditing,
            new Hotkey { EventType = EventType.KeyDown,       Key = KeyCode.Alpha3,   Modifiers = Mods.Alt } },

         {  EHotkeyAction.ToggleSaveMeshMode,
            new Hotkey { EventType = EventType.KeyDown,       Key = KeyCode.Alpha4,   Modifiers = Mods.Alt } },

         {  EHotkeyAction.SaveMesh,
            new Hotkey { EventType = EventType.KeyDown,       Key = KeyCode.Alpha5,   Modifiers = Mods.Alt } },

         {  EHotkeyAction.ResizeBrush,
            new Hotkey { EventType = EventType.ScrollWheel,   Key = KeyCode.None,     Modifiers = Mods.Shift } },

         {  EHotkeyAction.RescaleStrength,
            new Hotkey { EventType = EventType.ScrollWheel,   Key = KeyCode.None,     Modifiers = Mods.Alt } }
      };

      /// <summary>
      /// Container for all editor field
      /// </summary>
      public class VertexColorEditorControls
      {
         public EBrushMode BrushMode = EBrushMode.VertexColor;
         public EChannelLockMode ChannelMode = EChannelLockMode.RGB;
         public EBrushFunction BrushFunction = EBrushFunction.Value;
         public bool BackFaceEditing = true;
         public float Size = 10f;
         public int IntervalMs = 10;
         public int BoneIndex = 0;
         public int WeightIndex = 1;
         public float Strength = 1.0f;
         public bool Falloff = false;
         public Color32 Color = new Color(1, 1, 1, 1);
         public TChannelLocks ChannelLocks =
               Enum.GetValues(typeof(EChannel)).Cast<EChannel>().
               ToDictionary(channel => channel, channel => false);
         public long LastBrushTick = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
      }


      #region Variables

      // Constants
      public const String MenuTitle = "Mend Vertex Painter";
      public const String EditorTitle = "Mend Paint";
      public const String UnlitVertexColorShader = "Unlit/Vertex Colors";

      // Instance
      public static VertexPaintEditor wnd = null;

      // Containers
      public VertexColorEditorControls brushCtrl = new VertexColorEditorControls();
      protected BrushHandle brush = new BrushHandle { BrushSize = 0.5f };

      // References
      protected GameObject gameObj = null;
      protected GameObject gameObjPrev = null;
      protected Mesh mesh = null;
      protected SkinnedMeshRenderer skin = null;
      protected Renderer renderer = null;
      protected Color32[] vertColorsUnedited = null;
      protected Tool previousTool = Tool.None;
      protected Shader editVertexShader = Shader.Find(UnlitVertexColorShader);
      protected Shader origVertexShader = null;
      protected HashSet<int> strokedVerts = new HashSet<int>();

      // States
      protected bool isPainting = false;
      protected bool isPaintingPrev = false;
      protected bool unbufferedEditing = false;
      protected bool isDrawing = false;
      protected bool changesUnsaved = false;
      protected bool isUniformStroke = false;
      protected bool isBoneActive = true;
      protected bool isShowingVertColor = true;
      public bool IsShowingVertColor
      {
         get { return isShowingVertColor; }
         set
         {
            if (isShowingVertColor != value) {
               isShowingVertColor = value;
               if (value)
                  replaceShader(gameObj);
               else
                  restoreShader(gameObj);
            }
         }
      }

      #endregion Variables


      #region Methods

      /// <summary>
      /// Initialize editor window
      /// </summary>
      [MenuItem("Window/"+ MenuTitle)]
      protected static void init()
      {
         wnd = GetWindow<VertexPaintEditor>();
#if UNITY_5_3_OR_NEWER
         wnd.titleContent.text = EditorTitle;
#else
         wnd.title = EditorTitle;
#endif
         wnd.Show();

         SceneView.onSceneGUIDelegate -= wnd.handlePainting;
         SceneView.onSceneGUIDelegate += wnd.handlePainting;
      }

      /// <summary>
      /// Clean up resources
      /// </summary>
      public void OnDestroy()
      {
         SceneView.onSceneGUIDelegate -= handlePainting;
         isPainting = false;
         handleStateUpdate();
      }

      /// <summary>
      /// Update as needed after Unity's scripts reloaded event
      /// </summary>
      [UnityEditor.Callbacks.DidReloadScripts]
      private static void updatePaintDelegate()
      {
         // get reference of MeshPaintEditor
         wnd = wnd ?? Resources.FindObjectsOfTypeAll(typeof(VertexPaintEditor))
                               .FirstOrDefault() as VertexPaintEditor;

         if (wnd != null) {
            // delegates need to be renewed on script reload
            wnd.handleStateUpdate();
            wnd.brush = new BrushHandle() {BrushSize = wnd.brush.BrushSize, BackFaceEditing = wnd.brush.BackFaceEditing};
            SceneView.onSceneGUIDelegate -= wnd.handlePainting;
            SceneView.onSceneGUIDelegate += wnd.handlePainting;
            Undo.undoRedoPerformed -= wnd.UndoCallback;
            Undo.undoRedoPerformed += wnd.UndoCallback;
         }
      }

      /// <summary>
      /// Draws all gui elements contructing menu as modes dictate
      /// </summary>
      public void OnGUI()
      {
         // Show selection pane
         EditorGUILayout.BeginVertical("box");
         GUIStyle labelStyle = EditorStyles.largeLabel;
         labelStyle.fontStyle = FontStyle.Bold;
         EditorGUILayout.LabelField("Selection", labelStyle);
         EditorGUIUtility.labelWidth = 106;

         // show editor object selection field
         var label = new GUIContent("Game Object", "Game object containing a mesh");
         gameObj = EditorGUILayout.ObjectField(label, gameObj, typeof(GameObject), true) as GameObject;

         // buffering/saving mode control group
         EditorGUILayout.BeginHorizontal();
         {
            if (unbufferedEditing) {
               // show save mesh button when buffering vertex colors
               GUI.enabled = false;
               label = new GUIContent("Target Mesh", "Game object containing a mesh");
               EditorGUILayout.ObjectField(label, mesh, typeof(Mesh), true);

            } else {
               // show active mesh as immutable field when editing vertex colors directly
               EditorGUILayout.LabelField("Target Mesh", GUILayout.Width( EditorGUIUtility.labelWidth - 4 ) );
               GUI.enabled = (mesh != null);
               label = new GUIContent("Save Buffer", "Save mesh to file" + HotKeys[EHotkeyAction.SaveMesh]);
               if (GUILayout.Button(label, GUILayout.MinWidth(55)))
                  SaveMesh (mesh, mesh.name, true, true);
            }

            // show button to toggle buffering/saving edits
            GUI.enabled = (mesh != null);
            var layoutOptions = new GUILayoutOption[]{GUILayout.MinWidth(70),GUILayout.ExpandWidth(false)};
            label = new GUIContent( unbufferedEditing ? "Saving" : "Buffering",
                                    "Toggle mesh save mode" + HotKeys[EHotkeyAction.ToggleSaveMeshMode]);
            if (GUILayout.Button(label, layoutOptions)) {
               unbufferedEditing = !unbufferedEditing;
               changesUnsaved &= (unbufferedEditing == false);
               if (unbufferedEditing && mesh != null && mesh.colors32 != null)
                  vertColorsUnedited = mesh.colors32;
            }
         }
         EditorGUILayout.EndHorizontal();


         // show paint toggle button; handle changes to state
         GUI.enabled = (mesh != null);
         label = new GUIContent("Paint", (mesh != null ? "Enable vertex painting"
                                                       : "Game object is null or has no mesh.") + HotKeys[EHotkeyAction.TogglePaint]);
         GUI.color = isPainting ? Color.blue : Color.white;

         // Apply border above paint button
         GUI.backgroundColor = new Color(0, 0, 0, 0);
         GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(8) });
         GUI.backgroundColor = Color.white;

         if (GUILayout.Button(label)) {
            isPainting = !isPainting;
            isDrawing = false;
            //(PrefabUtility.GetPrefabObject(gameObj) as Mesh).bounds;
         }
         GUI.color = Color.white;

         // Apply border below paint button
         GUI.backgroundColor = new Color(0, 0, 0, 0);
         GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(8) });
         GUI.backgroundColor = Color.white;

         // Show brush control pane
         EditorGUILayout.BeginVertical("box");
         EditorGUILayout.LabelField("Brush Controls", labelStyle);

         // show vertex color visibility checkbox
         label = new GUIContent("Show Vert Colors", "Override mesh shader to show vertex color" + HotKeys[EHotkeyAction.ToggleBackFaceEditing]);
         IsShowingVertColor = EditorGUILayout.Toggle(label, IsShowingVertColor);

         // show back face editing checkbox
         label = new GUIContent("Back Faces", "Allow painting back facing verts" + HotKeys[EHotkeyAction.ToggleBackFaceEditing]);
         brush.BackFaceEditing = brushCtrl.BackFaceEditing = EditorGUILayout.Toggle(label, brushCtrl.BackFaceEditing);

         // show brush size field
         label = new GUIContent("Brush Size", "Brush screen size percentage" + HotKeys[EHotkeyAction.ResizeBrush]);
         brush.BrushSize = brushCtrl.Size = EditorGUILayout.FloatField(label, brushCtrl.Size);

         // show brush waight field
         label = new GUIContent("Strength", "Brushing application strength" + HotKeys[EHotkeyAction.RescaleStrength]);
         brushCtrl.Strength = EditorGUILayout.FloatField(label, brushCtrl.Strength);

         // show brush application frequency field
         label = new GUIContent("Frequency (ms)", "Brush application frequency");
         brushCtrl.IntervalMs = EditorGUILayout.IntField(label, brushCtrl.IntervalMs);

         // show uniform stroke checkbox
         label = new GUIContent("Uniform Stroke", "Affect each vertex once per stroke");
         isUniformStroke = EditorGUILayout.Toggle(label, isUniformStroke);

         // show brush function selector
         label = new GUIContent("Brush Function", brushCtrl.BrushFunction.GetDescription());
         brushCtrl.BrushFunction = (EBrushFunction)EditorGUILayout.EnumPopup(label, brushCtrl.BrushFunction);

         //GUI.enabled = true;
         //brushCtrl.BrushMode = (EBrushMode)EditorGUILayout.EnumPopup("Brush Mode", brushCtrl.BrushMode);

         // Handle all brush mode gui controls
         switch (brushCtrl.BrushMode) {
         case EBrushMode.VertexColor:

            // show brush color picker
            // disable color inputs if brush function operates without
            GUI.enabled &= (brushCtrl.BrushFunction != EBrushFunction.Average
                        &&  brushCtrl.BrushFunction != EBrushFunction.Random
                        /*&&  brushCtrl.BrushFunction != EBrushFunction.StepRound*/);
            label = new GUIContent("Color", "Brush application color");
            brushCtrl.Color = EditorGUILayout.ColorField(label, brushCtrl.Color);
            GUI.enabled = (mesh != null);

            int lastIndex = ModeChannels[ brushCtrl.ChannelMode ].Length-1;
            GUIStyle guiStyle = EditorStyles.miniButtonLeft;

            // show channel locks as custom button group
            EditorGUILayout.BeginHorizontal();

               // show color mode selector
               EditorStyles.popup.fixedWidth = 55;
               label = new GUIContent("Channel Locks", "Limit edits to select channels");
               brushCtrl.ChannelMode = (EChannelLockMode)EditorGUILayout.EnumPopup(label, brushCtrl.ChannelMode);
               EditorStyles.popup.fixedWidth = 0;

               // style each button based on its position
               foreach (var channel in ModeChannels[ brushCtrl.ChannelMode ]) {

                  // init button style as left; style button as right if last; default to mid button
                  if (channel == ModeChannels[brushCtrl.ChannelMode][lastIndex])
                     guiStyle = EditorStyles.miniButtonRight;
                  if (lastIndex == 0)
                     guiStyle = EditorStyles.miniButton;
                  guiStyle.normal = guiStyle.hover = brushCtrl.ChannelLocks[channel] ? EditorStyles.miniButton.normal
                                                                                     : guiStyle.active;

                  // show channel lock toggle buttons
                  label = new GUIContent(Enum.GetName(typeof(EChannel), channel), channel.GetDescription());
                  if (GUILayout.Button (label, guiStyle))
                     brushCtrl.ChannelLocks[channel] = !brushCtrl.ChannelLocks[channel];

                  guiStyle = EditorStyles.miniButtonMid;
               }
            EditorGUILayout.EndHorizontal ();
            break;

         case EBrushMode.BoneInfluence:
            // Currently unsupporting mode
            throw new NotImplementedException();

            // slider for intensity value
            string[] bones = skin.bones.Select(b => b.gameObject.name).ToArray();
            brushCtrl.WeightIndex = EditorGUILayout.Popup("Bone Selection", brushCtrl.WeightIndex, bones);
            break;

         case EBrushMode.WeightIndex:
            // Currently unsupporting mode
            throw new NotImplementedException();

            var weightIndexes = Enumerable.Range(1, 4).ToList();
            brushCtrl.WeightIndex = EditorGUILayout.IntPopup(  "Weight Index",
                                                               brushCtrl.WeightIndex,
                                                               weightIndexes.Select(x=>x.ToString()).ToArray(),
                                                               weightIndexes.ToArray());
            break;
         }

         EditorGUILayout.EndVertical();
         EditorGUILayout.EndVertical();

         // enforce limits
         brushCtrl.Strength = Mathf.Clamp(brushCtrl.Strength, 0, 1);
         brushCtrl.Size = Mathf.Clamp(brushCtrl.Size, 1, 100);
         brushCtrl.IntervalMs = Mathf.Clamp(brushCtrl.IntervalMs, 1, 4000);

         handleStateUpdate();
      }

      /// <summary>
      /// After game object selection changes handle mesh, skin, shader references and gui states
      /// </summary>
      private void handleStateUpdate()
      {
         // synchronize editor window GameObject selection and sceneview selection
         GameObject objSelected = Selection.activeGameObject;
         if (gameObjPrev != gameObj) {
            Selection.objects = new UnityEngine.Object[1] { gameObj };
         } else if (objSelected != gameObj) {
            gameObj = objSelected;
         }


         // Prompt user on changing game object unsaved changes
         if (changesUnsaved && gameObj != gameObjPrev) {

            if (! EditorUtility.DisplayDialog(  "Mend Vertex Painter",
                                                "Unsaved edits detected.\n\nDeselection of " +
                                                gameObjPrev.name + " will discard changes made to its mesh " +
                                                "vertex color. Click OK to continue with deselection?",
                                                "OK",
                                                "Cancel")) {
               // return selection to game object and exit
               gameObj = gameObjPrev;
               Selection.objects = new UnityEngine.Object[1] { gameObjPrev };
               return;

            } else if (mesh != null && mesh.colors32 != null) {
               // restore unedited mesh vertex colors
               mesh.colors32 = vertColorsUnedited;
               changesUnsaved = false;
            }
         }


         // disable painting with no object selected
         isPainting &= (mesh != null);

         // update component references when game object changes
         if (gameObj != gameObjPrev) {

            // nullify references for null GameObj
            restoreShader();

            mesh = null;
            skin = null;
            origVertexShader = null;
            isDrawing = false;

            // set references for GameObj mesh and skin
            if (gameObj != null) {
               renderer = gameObj.GetComponent<Renderer>();

               skin = gameObj.GetComponent<SkinnedMeshRenderer>();
               if (skin != null)
                  mesh = skin.sharedMesh;

               MeshFilter meshFilter = gameObj.GetComponent<MeshFilter>();
               if (meshFilter != null)
                  mesh = meshFilter.sharedMesh;

               vertColorsUnedited = (mesh != null ? mesh.colors32 : null);
               replaceShader();
            }

            // redraw gui controls
            wnd.Repaint();
         }

         // handle update to painting state
         else if((isPaintingPrev == false) && isPainting) {
            replaceShader();
         } else if((isPaintingPrev) && (isPainting == false)) {
            restoreShader();
         }

         // update previous states
         gameObjPrev = gameObj;
         isPaintingPrev = isPainting;
      }
      /// <summary>
      /// Replace a game object shader for editing
      /// </summary>
      private void replaceShader(GameObject editedGameObj = null)
      {
         editedGameObj = editedGameObj ?? gameObj;
         var objRenderer = (editedGameObj != null ? editedGameObj.GetComponent<Renderer>() : null);

         editVertexShader = Shader.Find(UnlitVertexColorShader);
         if (objRenderer != null && isPainting && IsShowingVertColor) {
            origVertexShader = objRenderer.sharedMaterial.shader;
            if (editVertexShader != null) {
               objRenderer.sharedMaterial.shader = editVertexShader;
               previousTool = Tools.current;
            }
         }
      }

      /// <summary>
      /// Restore a game object shader after editing
      /// </summary>
      private void restoreShader(GameObject editedGameObj = null)
      {
         editedGameObj = editedGameObj ?? gameObjPrev;
         var objRenderer = (editedGameObj != null ? editedGameObj.GetComponent<Renderer>() : null);

         if (objRenderer != null
         &&  isPaintingPrev
         //&&  IsShowingVertColor
         &&  editVertexShader != null
         &&  objRenderer.sharedMaterial.shader == editVertexShader) {
            objRenderer.sharedMaterial.shader = origVertexShader;
            Tools.current = previousTool;
         }
      }

      /// <summary>
      /// Save mesh to a file
      /// </summary>
      /// <param name="mesh"></param>
      /// <param name="name"></param>
      /// <param name="makeNewInstance"></param>
      /// <param name="optimizeMesh"></param>
      public static void SaveMesh (Mesh mesh, string name, bool makeNewInstance, bool optimizeMesh)
      {
         // identify current path
         string path = AssetDatabase.GetAssetPath(mesh);
         string[] pathDirs = path.Split('/');
         pathDirs[pathDirs.Length-1] = String.Empty;
         path = String.Join("/", pathDirs);

         // prompt user for save location
         path = EditorUtility.SaveFilePanel(
            "Save mesh asset to file",
            path != "" ? path : "Assets/",
            name,
            "asset");
         if (string.IsNullOrEmpty(path)) return;
         path = FileUtil.GetProjectRelativePath(path);
         if (! path.StartsWith("Assets/"))
            Debug.LogWarning("Mend Vertex Painter - Unity asset database requires assets to be saved under the project Assets folder.");

         // save mesh to select target path
         Mesh meshToSave = (makeNewInstance) ? UnityEngine.Object.Instantiate(mesh) as Mesh : mesh;
         AssetDatabase.CreateAsset(meshToSave, path);
         AssetDatabase.SaveAssets();
      }

      /// <summary>
      /// Update as needed after Unity's scripts reloaded event
      /// </summary>
      public void UndoCallback()
      {
         // get reference of MeshPaintEditor
         wnd = wnd ?? Resources.FindObjectsOfTypeAll(typeof(VertexPaintEditor))
                               .FirstOrDefault() as VertexPaintEditor;

         if (wnd != null && wnd.mesh != null)
            wnd.flushUndoState(wnd.mesh);
      }

      /// <summary>
      /// Bugs in unity; http://answers.unity3d.com/questions/975578/undoredo-on-meshes-this-code-works-but-how.html
      /// </summary>
      /// <param name="mesh"></param>
      private void flushUndoState(Mesh mesh)
      {
         for (int a = 0; a < 3; a++) {
            Color32[] vertColors = mesh.colors32;
            mesh.colors32 = vertColors;
         }
      }


      #region Interface Logic Methods

      /// <summary>
      /// Apply shortcut inputs
      /// </summary>
      public void handleShortcuts()
      {
         // Select action based on event hotkey
         EHotkeyAction action = EHotkeyAction.None;
         Event current = Event.current;
         foreach (var hotkey in HotKeys) {
            if (current.type == hotkey.Value.EventType
            &&  current.keyCode == hotkey.Value.Key
            &&  current.modifiers == hotkey.Value.Modifiers)
               action = hotkey.Key;
         }

         // handle action if hotkey was detected
         switch (action) {
            case EHotkeyAction.TogglePaint:
               wnd.isPainting = !wnd.isPainting;
               break;

            case EHotkeyAction.ToggleShowVertColor:
               wnd.IsShowingVertColor = !wnd.IsShowingVertColor;
               break;

            case EHotkeyAction.ToggleBackFaceEditing:
               wnd.brushCtrl.BackFaceEditing = !wnd.brushCtrl.BackFaceEditing;
               break;

            case EHotkeyAction.ToggleSaveMeshMode:
               wnd.unbufferedEditing = !wnd.unbufferedEditing;
               break;

            case EHotkeyAction.SaveMesh:
               if (!unbufferedEditing && mesh != null)
                  SaveMesh(mesh, mesh.name, true, true);
               break;

            case EHotkeyAction.ResizeBrush:
               wnd.brushCtrl.Size = Mathf.Clamp(wnd.brushCtrl.Size + (float)Math.Round(-current.delta.y, 2), 0, float.MaxValue);
               break;

            case EHotkeyAction.RescaleStrength:
               wnd.brushCtrl.Strength = Mathf.Clamp(wnd.brushCtrl.Strength + (float)Math.Round(-current.delta.y*.01, 2), 0, float.MaxValue);
               break;

            default:
               break;
         }

         // consume event and update editor gui
         if (action != EHotkeyAction.None) {
            Repaint();
            current.Use();
         }
      }

      /// <summary>
      /// Handle mouse events when vertex painting is enabled and the mouse is in the scene view
      /// </summary>
      /// <param name="sceneView"></param>
      public void handlePainting(SceneView sceneView)
      {
         // exit condition
         if (wnd == null)
            return;

         // update on object reselection
         wnd.handleStateUpdate();
         handleShortcuts();

         // showing and applying brush should only happen during mouseover sceneview
         if (! wnd.isPainting
         ||  mesh == null
         ||  SceneView.mouseOverWindow == null
         ||  SceneView.mouseOverWindow.GetType() != typeof(SceneView))
            return;

         HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));
         Tools.current = Tool.None;

         // display brush at mouse position
         Ray mouseRay = BrushHandle.GetMouseRay();
         wnd.brush.showBrush(mouseRay);

         // determine if vert colors are being edited
         Event current = Event.current;
         if (current.button == 0) {
            isDrawing |= (current.type == EventType.mouseDown || current.type == EventType.mouseDrag);
            isDrawing &= !(current.type == EventType.mouseUp || current.type == EventType.mouseMove);
            if (current.type == EventType.mouseUp || current.type == EventType.mouseMove) {
               wnd.brushCtrl.LastBrushTick = 0;
               strokedVerts.Clear();
            }
         }

         // while left mouse down get verts in brush radius and apply the a brush function
         if (isDrawing) {
            wnd.brush.BackFaceEditing = brushCtrl.BackFaceEditing;
            Dictionary<int, float> affectedVerts;

            if (skin == null) {
               affectedVerts = wnd.brush.GetEnclosedVerts(mesh, gameObj.transform, mouseRay);

            } else {
               Transform dbgXfrm = skin.transform;
               Mesh skinnedMesh = new Mesh();
               skin.BakeMesh(skinnedMesh);
               affectedVerts = wnd.brush.GetEnclosedVerts(skinnedMesh, dbgXfrm, mouseRay);
            }

            wnd.ApplyBrushAction(mesh, affectedVerts);
         }
      }

      /// <summary>
      /// Apply brush stroke function to a set of vertices to the enabled color channels
      /// </summary>
      /// <param name="mesh"></param>
      /// <param name="vertBrushWeights"></param>
      private void ApplyBrushAction(Mesh mesh, Dictionary<int, float> vertBrushWeights)
      {
         // restrict brush application for some cases
         long now = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
         if (now < wnd.brushCtrl.LastBrushTick + wnd.brushCtrl.IntervalMs || vertBrushWeights.Count == 0)
            return;
         wnd.brushCtrl.LastBrushTick = now;

         // handle uniform stroke option, affecting each vertex once per stroke
         if (isUniformStroke) {
            vertBrushWeights = vertBrushWeights.
               Where(kv => !strokedVerts.Contains(kv.Key)).
               ToDictionary(kv => kv.Key, kv => kv.Value);
            strokedVerts.UnionWith(vertBrushWeights.Keys);
         }

         // change will occur; track state
         changesUnsaved = !unbufferedEditing;
         Undo.RecordObject(mesh, String.Format("Vertex Paint - {0}", wnd.brushCtrl.BrushFunction));


         // initialization
         Color32[] vertColors = mesh.colors32;
         Color32 prevColor32 = new Color32(), vertColor32 = new Color32();

         if (mesh.colors32 == null || mesh.colors32.Length < mesh.vertexCount)
            vertColors = Enumerable.Repeat((Color32)Color.white, mesh.vertexCount).ToArray();
#if UNITY_5_4_OR_NEWER
         UnityEngine.Random.InitState(42);
#else
         UnityEngine.Random.seed++;
#endif

         // switch case for all brush modes
         switch (brushCtrl.BrushMode) {

            case EBrushMode.VertexColor:
               // get average of all brush affected verts
               Color avgColor = new Color();
               if (brushCtrl.BrushFunction == EBrushFunction.Average
               &&  vertBrushWeights.Count > 0) {

                  // get channel color sums of the brush affected verts
                  // currently not affected by falloff weight
                  int rSum = 0, gSum = 0, bSum = 0, aSum = 0;
                  foreach (var vertIndex in vertBrushWeights.Keys) {
                     rSum += vertColors[vertIndex].r;
                     gSum += vertColors[vertIndex].g;
                     bSum += vertColors[vertIndex].b;
                     aSum += vertColors[vertIndex].a;
                  }

                  // create averaged color from channel color sums
                  avgColor = new Color32(){
                     r=(byte)((float)rSum/(float)vertBrushWeights.Count),
                     g=(byte)((float)gSum/(float)vertBrushWeights.Count),
                     b=(byte)((float)bSum/(float)vertBrushWeights.Count),
                     a=(byte)((float)aSum/(float)vertBrushWeights.Count),
                  };
               }

               // modify brushed vert colors based on brush function and channel locks
               HSBColor vertColorHsb = new HSBColor();
               HSBColor prevColorHsb = new HSBColor();
               foreach (var vertIndex in vertBrushWeights.Keys) {

                  float falloffValue = (brushCtrl.Falloff ? vertBrushWeights[vertIndex] : 1.0f);
                  vertColor32 = vertColors[vertIndex];
                  prevColor32 = vertColor32.Clone();

                  // implement all brush function
                  if (brushCtrl.BrushFunction == EBrushFunction.Value) {
                     vertColors[vertIndex] = Color32.Lerp(vertColors[vertIndex], brushCtrl.Color, brushCtrl.Strength*falloffValue);

                  } else if (brushCtrl.BrushFunction == EBrushFunction.Average) {
                     vertColors[vertIndex] = Color32.Lerp(vertColors[vertIndex], avgColor, brushCtrl.Strength*falloffValue);

                  } else if (brushCtrl.BrushFunction == EBrushFunction.Add) {
                     vertColors[vertIndex] = (Color32)( ((Color)vertColors[vertIndex]) + ((Color)brushCtrl.Color*brushCtrl.Strength*falloffValue) );

                  } else if (brushCtrl.BrushFunction == EBrushFunction.Subtract) {
                     vertColors[vertIndex] = (Color32)( ((Color)vertColors[vertIndex]) - ((Color)brushCtrl.Color*brushCtrl.Strength*falloffValue) );

                  //} else if (brushCtrl.BrushFunction == EBrushFunction.StepAdd) {
                  //   vertColors[vertIndex] = (Color32)( ((Color)vertColors[vertIndex]) + ((Color)vertColor32*brushCtrl.Weight*falloffValue) );

                  //} else if (brushCtrl.BrushFunction == EBrushFunction.StepSubtract) {
                  //   vertColors[vertIndex] = (Color32)( ((Color)vertColors[vertIndex]) - ((Color)vertColor32*brushCtrl.Weight*falloffValue) );

                  } else if (brushCtrl.BrushFunction == EBrushFunction.Random) {
                     vertColors[vertIndex] = Color32.Lerp(
                        vertColors[vertIndex],
                        (Color32)new Color(
                           UnityEngine.Random.value,
                           UnityEngine.Random.value,
                           UnityEngine.Random.value,
                           UnityEngine.Random.value),
                        brushCtrl.Strength*falloffValue);
                  }


                  // handle edits to locked channels
                  if (brushCtrl.ChannelMode == EChannelLockMode.RGB) {
                     // backout rgb channel locks
                     if (brushCtrl.ChannelLocks[EChannel.R])
                        vertColors[vertIndex].r = prevColor32.r;
                     if (brushCtrl.ChannelLocks[EChannel.B])
                        vertColors[vertIndex].b = prevColor32.b;
                     if (brushCtrl.ChannelLocks[EChannel.G])
                        vertColors[vertIndex].g = prevColor32.g;

                  } else {
                     // backout hsv channel locks
                     vertColorHsb.FromColor_(vertColors[vertIndex]);
                     prevColorHsb.FromColor_(prevColor32);

                     if (brushCtrl.ChannelMode == EChannelLockMode.HSV) {
                        if (brushCtrl.ChannelLocks[EChannel.H])
                           vertColorHsb.h = prevColorHsb.h;
                        if (brushCtrl.ChannelLocks[EChannel.S])
                           vertColorHsb.s = prevColorHsb.s;
                     //} else if (brushCtrl.ColorMode == EColorMode.V) {
                     //   vertColorHsb.s = 0;
                     }
                     if (brushCtrl.ChannelLocks[EChannel.V])
                        vertColorHsb.b = prevColorHsb.b;

                     vertColors[vertIndex] = vertColorHsb.ToColor();
                  }


                  // backout alpha channel lock
                  if (brushCtrl.ChannelLocks[EChannel.A])
                     vertColors[vertIndex].a = prevColor32.a;
               }
               mesh.colors32 = vertColors;
               break;

            case EBrushMode.WeightIndex:
               // Currently unsupporting mode
               throw new NotImplementedException();
               break;

            case EBrushMode.BoneInfluence:
               // Currently unsupporting mode
               throw new NotImplementedException();

               //var affectedVerts = brush.applyVerts(editorMesh, skin.transform, mouseRay);
               BoneWeight[] boneWeights = mesh.boneWeights;
               foreach (var affectedVert in vertBrushWeights) {
                  BoneWeight iBoneWeight = boneWeights[affectedVert.Key];
                  if (! isBoneActive) {
                     // without bone index
                     switch (brushCtrl.BrushFunction) {
                     case EBrushFunction.Add:
                        boneWeights[affectedVert.Key].weight0 += brushCtrl.Strength;
                        break;

                     case EBrushFunction.Subtract:
                        boneWeights[affectedVert.Key].weight0 -= brushCtrl.Strength;
                        break;
                     }
                     boneWeights[affectedVert.Key].weight0 = Mathf.Clamp(boneWeights[affectedVert.Key].weight0, 0, 1);
                  } else {
                     // with bone index
                     if (brushCtrl.BoneIndex == iBoneWeight.boneIndex0) {}
                     if (brushCtrl.BoneIndex == iBoneWeight.boneIndex1) {}
                     if (brushCtrl.BoneIndex == iBoneWeight.boneIndex2) {}
                     if (brushCtrl.BoneIndex == iBoneWeight.boneIndex3) {}
                  }
               }
               mesh.boneWeights = boneWeights;
               break;
         }
      }

#endregion Brush Logic Methods

#endregion Methods
   }
}
