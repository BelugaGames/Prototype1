using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class OceanGUI : ShaderGUI
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
        GUILayout.Label("Ocean Colour", EditorStyles.boldLabel);
        SetColour();
      

        EditorGUILayout.Space();
        GUILayout.Label("Ocean Normals", EditorStyles.boldLabel);
        SetNormals();

        EditorGUILayout.Space();
        GUILayout.Label("Ocean Waves", EditorStyles.boldLabel);
        SetWaves();
    }

    void SetColour()
    {

        GUILayout.Label("Colours", EditorStyles.miniBoldLabel);
        MaterialProperty DeepColour = FindProperty("_DeepColour");
        editor.ShaderProperty(DeepColour, MakeLabel(DeepColour));
        MaterialProperty PeakColour = FindProperty("_Peak");
        editor.ShaderProperty(PeakColour, MakeLabel(PeakColour));
        EditorGUILayout.Space();
        MaterialProperty _PeakTransitionHeight = FindProperty("_PeakTransitionHeight");
        editor.ShaderProperty(_PeakTransitionHeight, MakeLabel(_PeakTransitionHeight));
        MaterialProperty _PeakTransitionratio = FindProperty("_PeakTransitionratio");
        editor.ShaderProperty(_PeakTransitionratio, MakeLabel(_PeakTransitionratio));



        EditorGUILayout.Space();

        GUILayout.Label("White Caps", EditorStyles.miniBoldLabel);
        MaterialProperty mainTex = FindProperty("_WhitecapTex");
        editor.TexturePropertySingleLine(
         MakeLabel(mainTex), mainTex);
        EditorGUI.indentLevel += 2;
        MaterialProperty _WhitecapIntensity = FindProperty("_WhitecapIntensity");
        editor.ShaderProperty(_WhitecapIntensity, MakeLabel(_WhitecapIntensity));
        MaterialProperty _WhitecapSpread = FindProperty("_WhitecapSpread");
        editor.ShaderProperty(_WhitecapSpread, MakeLabel(_WhitecapSpread));
        MaterialProperty _WhitecapTiling = FindProperty("_WhitecapTiling");
        editor.ShaderProperty(_WhitecapTiling, MakeLabel(_WhitecapTiling));
        EditorGUI.indentLevel -= 2;

        EditorGUILayout.Space();
        GUILayout.Label("Foam", EditorStyles.miniBoldLabel);
        MaterialProperty FoamTex = FindProperty("_Foam");
        editor.TexturePropertySingleLine(
         MakeLabel(FoamTex), FoamTex);
        EditorGUI.indentLevel += 2;
        MaterialProperty _FoamVspeed = FindProperty("_FoamVspeed");
        editor.ShaderProperty(_FoamVspeed, MakeLabel(_FoamVspeed));
        MaterialProperty _FoamHspeed = FindProperty("_FoamHspeed");
        editor.ShaderProperty(_FoamHspeed, MakeLabel(_FoamHspeed));

        MaterialProperty _FoamSpread = FindProperty("_FoamSpread");
        editor.ShaderProperty(_FoamSpread, MakeLabel(_FoamSpread));
        MaterialProperty _FoamoutlineFalloff = FindProperty("_FoamoutlineFalloff");
        editor.ShaderProperty(_FoamoutlineFalloff, MakeLabel(_FoamoutlineFalloff));
        MaterialProperty _FoamIntensity = FindProperty("_FoamIntensity");
        editor.ShaderProperty(_FoamIntensity, MakeLabel(_FoamIntensity));
        MaterialProperty _FoamFalloff = FindProperty("_FoamFalloff");
        editor.ShaderProperty(_FoamFalloff, MakeLabel(_FoamFalloff));

        MaterialProperty _EdgeLineWidth = FindProperty("_EdgeLineWidth");
        editor.ShaderProperty(_EdgeLineWidth, MakeLabel(_EdgeLineWidth));
        MaterialProperty _Depth = FindProperty("_Depth");
        editor.ShaderProperty(_Depth, MakeLabel(_Depth));


        EditorGUILayout.Space();
        SetMetallic();
        SetSmoothness();
        EditorGUI.indentLevel -= 2;
    }

    void SetWaves()
    {
        GUILayout.Label("Wave 1:  ", EditorStyles.miniBoldLabel);
        MaterialProperty _W1Direction = FindProperty("_W1Direction");
        editor.ShaderProperty(_W1Direction, MakeLabel(_W1Direction));
        MaterialProperty _W1WaveLength = FindProperty("_W1WaveLength");
        editor.ShaderProperty(_W1WaveLength, MakeLabel(_W1WaveLength));
        MaterialProperty _W1WaveAmplitude = FindProperty("_W1WaveAmplitude");
        editor.ShaderProperty(_W1WaveAmplitude, MakeLabel(_W1WaveAmplitude));
        MaterialProperty _W1NumofWaves = FindProperty("_W1NumofWaves");
        editor.ShaderProperty(_W1NumofWaves, MakeLabel(_W1NumofWaves));
        MaterialProperty _W1Speed = FindProperty("_W1Speed");
        editor.ShaderProperty(_W1Speed, MakeLabel(_W1Speed));
        MaterialProperty _W1Steepness = FindProperty("_W1Steepness");
        editor.ShaderProperty(_W1Steepness, MakeLabel(_W1Steepness));

        EditorGUILayout.Space();
        GUILayout.Label("Wave 2:  ", EditorStyles.miniBoldLabel);
        MaterialProperty _W2Direction = FindProperty("_W2Direction");
        editor.ShaderProperty(_W2Direction, MakeLabel(_W2Direction));
        MaterialProperty _W2WaveLength = FindProperty("_W2WaveLength");
        editor.ShaderProperty(_W2WaveLength, MakeLabel(_W2WaveLength));
        MaterialProperty _W2WaveAmplitude = FindProperty("_W2WaveAmplitude");
        editor.ShaderProperty(_W2WaveAmplitude, MakeLabel(_W2WaveAmplitude));
        MaterialProperty _W2NumofWaves = FindProperty("_W2NumofWaves");
        editor.ShaderProperty(_W2NumofWaves, MakeLabel(_W2NumofWaves));
        MaterialProperty _W2Speed = FindProperty("_W2Speed");
        editor.ShaderProperty(_W2Speed, MakeLabel(_W2Speed));
        MaterialProperty _W2Steepness = FindProperty("_W2Steepness");
        editor.ShaderProperty(_W2Steepness, MakeLabel(_W2Steepness));


        MaterialProperty _SwayFrequency = FindProperty("_SwayFrequency");
        editor.ShaderProperty(_SwayFrequency, MakeLabel(_SwayFrequency));
    }

    void SetMetallic()
    {
        MaterialProperty slider = FindProperty("_OceanMetallic");
        editor.ShaderProperty(slider, MakeLabel(slider));
    }

    void SetSmoothness()
    {
        MaterialProperty slider = FindProperty("_OceanSmoothness");
        editor.ShaderProperty(slider, MakeLabel(slider));
    }

    void SetNormals()
    {
        ///Main Normal Map
        MaterialProperty map = FindProperty("_BaseNormal");
        editor.TexturePropertySingleLine(MakeLabel(map), map, map.textureValue ? FindProperty("_MidWaveScale") : null);
        MaterialProperty MidWaveIntensity = FindProperty("_MidWaveIntensity");

        EditorGUI.indentLevel += 2;
        editor.ShaderProperty(MidWaveIntensity, MakeLabel(MidWaveIntensity));
        MaterialProperty MidTime = FindProperty("_MidTime");
        editor.ShaderProperty(MidTime, MakeLabel(MidTime));
        MaterialProperty _MidWaveSpeed = FindProperty("_MidWaveSpeed");
        editor.ShaderProperty(_MidWaveSpeed, MakeLabel(_MidWaveSpeed));
        EditorGUI.indentLevel -= 2;


        ///Macro Normal Map
        EditorGUILayout.Space();
        GUILayout.Label("Macro Normal", EditorStyles.miniBoldLabel);
        MaterialProperty Macromap = FindProperty("_MacroNormal");
        editor.TexturePropertySingleLine(MakeLabel(Macromap), Macromap, Macromap.textureValue ? FindProperty("_MacroScale") : null);
        MaterialProperty MacroDistortion = FindProperty("_MacroDistortionSpeed");
        EditorGUI.indentLevel += 2;
        editor.ShaderProperty(MacroDistortion, MakeLabel(MacroDistortion));
        MaterialProperty MacroIntensity = FindProperty("_MacroIntensity");
        editor.ShaderProperty(MacroIntensity, MakeLabel(MacroIntensity));
        EditorGUI.indentLevel -= 2;


        ///Micro Normal Map
        EditorGUILayout.Space();
        GUILayout.Label("Micro Normal", EditorStyles.miniBoldLabel);
        MaterialProperty Micromap = FindProperty("_MicroNormal");
        editor.TexturePropertySingleLine(MakeLabel(Micromap), Micromap, Micromap.textureValue ? FindProperty("_MicroScale") : null);
        MaterialProperty MicroDistortion = FindProperty("_MicroDistortionSpeed");
        EditorGUI.indentLevel += 2;
        editor.ShaderProperty(MicroDistortion, MakeLabel(MicroDistortion));
        MaterialProperty MicroIntensity = FindProperty("_MicroIntensity");
        editor.ShaderProperty(MicroIntensity, MakeLabel(MicroIntensity));
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
