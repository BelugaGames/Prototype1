using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class LavaGUI : ShaderGUI
{
    MaterialEditor editor;
    MaterialProperty[] properties;


    public override void OnGUI(
        MaterialEditor editor, MaterialProperty[] properties
    )
    {
        this.editor = editor;
        this.properties = properties;
        DoMain();

    }

    void DoMain()
    {
        GUILayout.Label("Tessellation", EditorStyles.boldLabel);
        MaterialProperty _TessValue = FindProperty("_TessValue");
        editor.ShaderProperty(_TessValue, MakeLabel(_TessValue));
        MaterialProperty _TessMin = FindProperty("_TessMin");
        editor.ShaderProperty(_TessMin, MakeLabel(_TessMin));
        MaterialProperty _TessMax = FindProperty("_TessMax");
        editor.ShaderProperty(_TessMax, MakeLabel(_TessMax));
 

        EditorGUILayout.Space();
        GUILayout.Label("Lava Colour", EditorStyles.boldLabel);
        SetColour();
      

        EditorGUILayout.Space();
        GUILayout.Label("Lava Normals", EditorStyles.boldLabel);
        SetNormals();

        EditorGUILayout.Space();
        GUILayout.Label("Lava Displacement", EditorStyles.boldLabel);
        SetDisplacement();
    }

    void SetColour()
    {
        GUILayout.Label("Magma", EditorStyles.miniBoldLabel);
        MaterialProperty mainTex = FindProperty("_MagmaTexture");
        editor.TexturePropertySingleLine(
         MakeLabel(mainTex), mainTex);

        EditorGUILayout.Space();
        MaterialProperty _MagmaTransitionHeight = FindProperty("_MagmaTransitionHeight");
        editor.ShaderProperty(_MagmaTransitionHeight, MakeLabel(_MagmaTransitionHeight));
        MaterialProperty _MagmaTransitionRatio = FindProperty("_MagmaTransitionRatio");
        editor.ShaderProperty(_MagmaTransitionRatio, MakeLabel(_MagmaTransitionRatio));
        MaterialProperty _SurfaceTransitionHeight = FindProperty("_SurfaceTransitionHeight");
        editor.ShaderProperty(_SurfaceTransitionHeight, MakeLabel(_SurfaceTransitionHeight));
        MaterialProperty _SurfaceTransitionRatio = FindProperty("_SurfaceTransitionRatio");
        editor.ShaderProperty(_SurfaceTransitionRatio, MakeLabel(_SurfaceTransitionRatio));
     

        EditorGUILayout.Space();
        GUILayout.Label("Lava", EditorStyles.miniBoldLabel);
        MaterialProperty _flowTex = FindProperty("_LavaFlowTexture");
        editor.TexturePropertySingleLine(
         MakeLabel(_flowTex), _flowTex);
        MaterialProperty _CrackTex = FindProperty("_CrackLavaTexture");
        editor.TexturePropertySingleLine(
         MakeLabel(_CrackTex), _CrackTex);
        MaterialProperty _CrackFire = FindProperty("_FireFlowTexture");
        editor.TexturePropertySingleLine(
         MakeLabel(_CrackFire), _CrackFire);


        MaterialProperty _LavaFlowTiling = FindProperty("_LavaFlowTiling");
        editor.ShaderProperty(_LavaFlowTiling, MakeLabel(_LavaFlowTiling));
        EditorGUILayout.Space();
        MaterialProperty _LavaFlowDirection = FindProperty("_LavaFlowDirection");
        editor.ShaderProperty(_LavaFlowDirection, MakeLabel(_LavaFlowDirection));
   
        MaterialProperty _LavaCrackHeight = FindProperty("_LavaCrackHeight");
        editor.ShaderProperty(_LavaCrackHeight, MakeLabel(_LavaCrackHeight));
        MaterialProperty _LavacrackTransitionRatio = FindProperty("_LavacrackTransitionRatio");
        editor.ShaderProperty(_LavacrackTransitionRatio, MakeLabel(_LavacrackTransitionRatio));
        

        EditorGUILayout.Space();
        GUILayout.Label("Details", EditorStyles.miniBoldLabel);
        MaterialProperty _HardCrackTexture = FindProperty("_HardCrackTexture");
        editor.TexturePropertySingleLine(
         MakeLabel(_HardCrackTexture), _HardCrackTexture);
        EditorGUILayout.Space();


        MaterialProperty _HardCrackTiling = FindProperty("_HardCrackTiling");
        editor.ShaderProperty(_HardCrackTiling, MakeLabel(_HardCrackTiling));
        MaterialProperty _HardCrackRatio = FindProperty("_HardCrackRatio");
        editor.ShaderProperty(_HardCrackRatio, MakeLabel(_HardCrackRatio));
 
      
        EditorGUILayout.Space();
        SetMetallic();
        SetSmoothness();
      
    }

    void SetDisplacement()
    {
        GUILayout.Label("Main: ", EditorStyles.miniBoldLabel);
        MaterialProperty _MainHeightMap = FindProperty("_MainHeightMap");
        editor.TexturePropertySingleLine(
         MakeLabel(_MainHeightMap), _MainHeightMap);
        EditorGUILayout.Space();
        MaterialProperty _DisplacementTiling = FindProperty("_DisplacementTiling");
        editor.ShaderProperty(_DisplacementTiling, MakeLabel(_DisplacementTiling));
        MaterialProperty _MainDisplacementSpeed = FindProperty("_MainDisplacementSpeed");
        editor.ShaderProperty(_MainDisplacementSpeed, MakeLabel(_MainDisplacementSpeed));
        MaterialProperty _MainDisplacementHeight = FindProperty("_MainDisplacementHeight");
        editor.ShaderProperty(_MainDisplacementHeight, MakeLabel(_MainDisplacementHeight));

        EditorGUILayout.Space();
        GUILayout.Label("Detail:  ", EditorStyles.miniBoldLabel);
        MaterialProperty _DetailHeightmap = FindProperty("_DetailHeightmap");
        editor.TexturePropertySingleLine(
         MakeLabel(_DetailHeightmap), _DetailHeightmap);
        EditorGUILayout.Space();
        MaterialProperty _DetailTiling = FindProperty("_DetailTiling");
        editor.ShaderProperty(_DetailTiling, MakeLabel(_DetailTiling));
        MaterialProperty _DetailDisplacementspeed = FindProperty("_DetailDisplacementspeed");
        editor.ShaderProperty(_DetailDisplacementspeed, MakeLabel(_DetailDisplacementspeed));
        MaterialProperty _DetailDisplacementHeight = FindProperty("_DetailDisplacementHeight");
        editor.ShaderProperty(_DetailDisplacementHeight, MakeLabel(_DetailDisplacementHeight)); 
    }

    void SetMetallic()
    {
        MaterialProperty slider = FindProperty("_Metallic");
        editor.ShaderProperty(slider, MakeLabel(slider));
    }

    void SetSmoothness()
    {
        MaterialProperty slider = FindProperty("_Smoothness");
        editor.ShaderProperty(slider, MakeLabel(slider));
    }

    void SetNormals()
    {
        ///Main Normal Map
        MaterialProperty _LavaNormal = FindProperty("_LavaNormal");
        editor.TexturePropertySingleLine(MakeLabel(_LavaNormal), _LavaNormal, _LavaNormal.textureValue ? FindProperty("_LavaNormalScale") : null);
      

       
        MaterialProperty _LavaNormalTiling = FindProperty("_LavaNormalTiling");
        editor.ShaderProperty(_LavaNormalTiling, MakeLabel(_LavaNormalTiling));
       


        ///Macro Normal Map
        EditorGUILayout.Space();
        MaterialProperty _Magmanormal = FindProperty("_Magmanormal");
        editor.TexturePropertySingleLine(MakeLabel(_Magmanormal), _Magmanormal, _Magmanormal.textureValue ? FindProperty("_Magmascale") : null);
      
        MaterialProperty _MagmaNormalTiling = FindProperty("_MagmaNormalTiling");
        editor.ShaderProperty(_MagmaNormalTiling, MakeLabel(_MagmaNormalTiling));
      


        ///Micro Normal Map
        EditorGUILayout.Space();
        MaterialProperty _LavaHardCrackNormal = FindProperty("_LavaHardCrackNormal");
        editor.TexturePropertySingleLine(MakeLabel(_LavaHardCrackNormal), _LavaHardCrackNormal, _LavaHardCrackNormal.textureValue ? FindProperty("_HardCrackScale") : null);
      
        EditorGUILayout.Space();
        
        MaterialProperty _NormalTransitionHeight = FindProperty("_NormalTransitionHeight");
        editor.ShaderProperty(_NormalTransitionHeight, MakeLabel(_NormalTransitionHeight));
        MaterialProperty _NormalTransitionRatio = FindProperty("_NormalTransitionRatio");
        editor.ShaderProperty(_NormalTransitionRatio, MakeLabel(_NormalTransitionRatio));
      
    }

    MaterialProperty FindProperty(string name)
    {
        return FindProperty(name, properties);
    }

    static GUIContent staticLabel = new GUIContent();

    static GUIContent MakeLabel(
         MaterialProperty property, 
         string tooltip = null
     )
    {
        staticLabel.text = property.displayName;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }
}
