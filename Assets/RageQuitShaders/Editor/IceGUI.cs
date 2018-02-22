using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class IceGUI : ShaderGUI
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
      
        EditorGUILayout.Space();
        GUILayout.Label("Colour", EditorStyles.boldLabel);
        SetColour();
      

        EditorGUILayout.Space();
        GUILayout.Label("Ocean Normals", EditorStyles.boldLabel);
        SetNormals();

    }

    void SetColour()
    {

        GUILayout.Label("Colours", EditorStyles.miniBoldLabel);
        MaterialProperty _IceColour = FindProperty("_IceColour");
        editor.ShaderProperty(_IceColour, MakeLabel(_IceColour));
        EditorGUILayout.Space();
        MaterialProperty mainTex = FindProperty("_MainTex");
        editor.TexturePropertySingleLine(
         MakeLabel(mainTex), mainTex);
        MaterialProperty _CubeMap = FindProperty("_CubeMap");
        editor.TexturePropertySingleLine(
         MakeLabel(_CubeMap), _CubeMap);
        EditorGUI.indentLevel += 2;
        MaterialProperty _FresPower = FindProperty("_FresPower");
        editor.ShaderProperty(_FresPower, MakeLabel(_FresPower));
        MaterialProperty _Intensity = FindProperty("_Intensity");
        editor.ShaderProperty(_Intensity, MakeLabel(_Intensity));
        MaterialProperty _Opacity = FindProperty("_Opacity");
        editor.ShaderProperty(_Opacity, MakeLabel(_Opacity));
       

        EditorGUILayout.Space();
        SetMetallic();
        EditorGUI.indentLevel -= 2;
        SetSmoothness();
        MaterialProperty AOC = FindProperty("_AmbientOcclusion");
        editor.TexturePropertySingleLine(
         MakeLabel(AOC), AOC);
    }

    void SetMetallic()
    {
        MaterialProperty slider = FindProperty("_Metallic");
        editor.ShaderProperty(slider, MakeLabel(slider));
    }

    void SetSmoothness()
    {
        MaterialProperty mainTex = FindProperty("_RoughnessMap");
        editor.TexturePropertySingleLine(
         MakeLabel(mainTex), mainTex);
        EditorGUI.indentLevel += 2;
        MaterialProperty slider = FindProperty("_Smoothness");
        editor.ShaderProperty(slider, MakeLabel(slider));
        EditorGUI.indentLevel -= 2;
    }

    void SetNormals()
    {
        ///Main Normal Map
        MaterialProperty map = FindProperty("_Normal");
        editor.TexturePropertySingleLine(MakeLabel(map), map, map.textureValue ? FindProperty("_NormalScale") : null);
        EditorGUI.indentLevel += 2;
        MaterialProperty Distortion = FindProperty("_Distortion");
        editor.ShaderProperty(Distortion, MakeLabel(Distortion));
        EditorGUI.indentLevel -= 2;

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
