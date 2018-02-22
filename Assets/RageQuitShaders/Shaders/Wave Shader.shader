// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Gerstner WaveShader"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 200
		_SwayFrequency("Sway Frequency", Float) = 0.05
		_OceanMetallic("Ocean Metallic", Range( 0 , 1)) = 0
		_W1WaveLength("W1: WaveLength", Float) = 1
		_W2Speed("W2: Speed", Float) = 1
		_W1Speed("W1: Speed", Float) = 1
		_W2NumofWaves("W2: Num of Waves ", Float) = 1
		_W1WaveAmplitude("W1: Wave Amplitude", Float) = 1
		_W2WaveAmplitude("W2: Wave Amplitude", Float) = 1
		_W2Steepness("W2: Steepness", Float) = 1
		_W1NumofWaves("W1: Num of Waves", Float) = 1
		_W1Steepness("W1: Steepness", Float) = 1
		_W2WaveLength("W2: WaveLength", Float) = 1
		_W2Direction("W2: Direction", Vector) = (1,1,0,0)
		_W1Direction("W1:  Direction", Vector) = (1,1,0,0)
		_BaseNormal("Base Normal", 2D) = "bump" {}
		_MidWaveScale("Mid Wave Scale", Float) = 1
		_MidWaveIntensity("Mid Wave Intensity", Vector) = (1,1,1,0)
		_MidTime("Mid Time", Float) = 0.01
		_MicroNormal("Micro Normal", 2D) = "white" {}
		_MacroNormal("Macro Normal", 2D) = "bump" {}
		_MicroScale("Micro Scale", Float) = 0.5
		_MacroScale("Macro Scale", Float) = 1
		_MicroDistortionSpeed("Micro Distortion Speed", Float) = 1
		_MicroIntensity("Micro Intensity", Float) = 0
		_MacroDistortionSpeed("Macro Distortion Speed", Float) = 1
		_MacroIntensity("Macro Intensity", Float) = 0
		_WhitecapTex("Whitecap Tex", 2D) = "white" {}
		_PeakTransitionHeight("Peak Transition Height", Float) = 0
		_WhitecapIntensity("Whitecap Intensity", Float) = 10
		_PeakTransitionratio("Peak Transition ratio", Range( 0 , 0.1)) = 0.54
		_FoamVspeed("Foam V speed", Float) = 0
		_Depth("Depth", Float) = 0
		_FoamSpread("Foam Spread", Float) = 0
		_FoamHspeed("Foam H speed", Float) = 0
		_Foam("Foam", 2D) = "white" {}
		_FoamoutlineFalloff("Foam outline Falloff", Float) = 77.8
		_DeepColour("Deep Colour", Color) = (0,0,0,1)
		_EdgeLineWidth("EdgeLine Width", Float) = 0
		_FoamIntensity("Foam Intensity", Float) = 0
		_OceanSmoothness("Ocean Smoothness", Range( 0 , 1)) = 1
		_OceanOpacity("Ocean Opacity", Range( 0.8 , 1)) = 0.8
		_WhitecapSpread("Whitecap Spread", Float) = 0
		_WhitecapTiling("Whitecap Tiling", Float) = 0
		_Peak("Peak", Color) = (0,0,0,0)
		_MidWaveSpeed("Mid Wave Speed", Float) = 0
		_FoamFalloff("Foam Falloff", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha , One One
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 5.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
		};

		uniform sampler2D _BaseNormal;
		uniform float _SwayFrequency;
		uniform float _MidTime;
		uniform float _MidWaveSpeed;
		uniform float _MidWaveScale;
		uniform float3 _MidWaveIntensity;
		uniform sampler2D _MicroNormal;
		uniform float _MicroScale;
		uniform float _MicroDistortionSpeed;
		uniform float _MicroIntensity;
		uniform sampler2D _MacroNormal;
		uniform float _MacroScale;
		uniform float _MacroDistortionSpeed;
		uniform float _MacroIntensity;
		uniform float4 _DeepColour;
		uniform float4 _Peak;
		uniform float _PeakTransitionHeight;
		uniform sampler2D _WhitecapTex;
		uniform float _WhitecapTiling;
		uniform float _WhitecapSpread;
		uniform float _WhitecapIntensity;
		uniform float _PeakTransitionratio;
		uniform float _FoamSpread;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Depth;
		uniform float _FoamFalloff;
		uniform sampler2D _Foam;
		uniform float _FoamVspeed;
		uniform float _FoamHspeed;
		uniform float _EdgeLineWidth;
		uniform float _FoamoutlineFalloff;
		uniform float _FoamIntensity;
		uniform float _OceanMetallic;
		uniform float _OceanSmoothness;
		uniform float _OceanOpacity;
		uniform float2 _W1Direction;
		uniform float _W1WaveLength;
		uniform float _W1Speed;
		uniform float _W1Steepness;
		uniform float _W1NumofWaves;
		uniform float _W1WaveAmplitude;
		uniform float2 _W2Direction;
		uniform float _W2WaveLength;
		uniform float _W2Speed;
		uniform float _W2Steepness;
		uniform float _W2NumofWaves;
		uniform float _W2WaveAmplitude;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 appendResult16_g74 = (float2(_W1Direction.x , _W1Direction.y));
			float2 normalizeResult18_g74 = normalize( appendResult16_g74 );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float dotResult23_g74 = dot( normalizeResult18_g74 , (ase_worldPos).xz );
			float temp_output_19_0_g74 = ( 6.28318548202515 / _W1WaveLength );
			float temp_output_10_0 = ( ( 0.2004711 * sin( ( _SwayFrequency * 6.28318548202515 * _Time.y ) ) ) + _Time.y );
			float temp_output_34_0_g74 = ( ( dotResult23_g74 * temp_output_19_0_g74 ) + ( temp_output_10_0 * ( temp_output_19_0_g74 * _W1Speed ) ) );
			float temp_output_37_0_g74 = cos( temp_output_34_0_g74 );
			float temp_output_446_0 = ( _W1Steepness * 1E+07 );
			float temp_output_407_0 = ( _W1NumofWaves * 1E+07 );
			float temp_output_27_0_g74 = _W1WaveAmplitude;
			float temp_output_41_0_g74 = ( ( temp_output_446_0 / ( ( temp_output_407_0 * 6.28318548202515 ) * ( temp_output_19_0_g74 * temp_output_27_0_g74 ) ) ) * temp_output_27_0_g74 );
			float3 appendResult46_g74 = (float3(( ( _W1Direction.x * temp_output_37_0_g74 ) * temp_output_41_0_g74 ) , ( sin( temp_output_34_0_g74 ) * ( temp_output_27_0_g74 * 0.5 ) ) , ( temp_output_41_0_g74 * ( temp_output_37_0_g74 * 1.0 ) )));
			float2 appendResult16_g73 = (float2(( _W1Direction * 1.75 ).x , ( _W1Direction * 1.75 ).y));
			float2 normalizeResult18_g73 = normalize( appendResult16_g73 );
			float dotResult23_g73 = dot( normalizeResult18_g73 , (ase_worldPos).xz );
			float temp_output_19_0_g73 = ( 6.28318548202515 / ( _W1WaveLength * 0.75 ) );
			float temp_output_34_0_g73 = ( ( dotResult23_g73 * temp_output_19_0_g73 ) + ( temp_output_10_0 * ( temp_output_19_0_g73 * ( _W1Speed * 2.75 ) ) ) );
			float temp_output_37_0_g73 = cos( temp_output_34_0_g73 );
			float temp_output_27_0_g73 = ( _W1WaveAmplitude * 0.75 );
			float temp_output_41_0_g73 = ( ( temp_output_446_0 / ( ( temp_output_407_0 * 6.28318548202515 ) * ( temp_output_19_0_g73 * temp_output_27_0_g73 ) ) ) * temp_output_27_0_g73 );
			float3 appendResult46_g73 = (float3(( ( ( _W1Direction * 1.75 ).x * temp_output_37_0_g73 ) * temp_output_41_0_g73 ) , ( sin( temp_output_34_0_g73 ) * ( temp_output_27_0_g73 * 0.5 ) ) , ( temp_output_41_0_g73 * ( temp_output_37_0_g73 * 1.0 ) )));
			float2 appendResult16_g70 = (float2(( _W2Direction * 3.5 ).x , ( _W2Direction * 3.5 ).y));
			float2 normalizeResult18_g70 = normalize( appendResult16_g70 );
			float dotResult23_g70 = dot( normalizeResult18_g70 , (ase_worldPos).xz );
			float temp_output_19_0_g70 = ( 6.28318548202515 / ( _W2WaveLength * 0.25 ) );
			float temp_output_34_0_g70 = ( ( dotResult23_g70 * temp_output_19_0_g70 ) + ( temp_output_10_0 * ( temp_output_19_0_g70 * ( _W2Speed * 0.5 ) ) ) );
			float temp_output_37_0_g70 = cos( temp_output_34_0_g70 );
			float temp_output_447_0 = ( _W2Steepness * 1E+07 );
			float temp_output_416_0 = ( _W2NumofWaves * 1E+07 );
			float temp_output_27_0_g70 = ( _W2WaveAmplitude * 0.5 );
			float temp_output_41_0_g70 = ( ( temp_output_447_0 / ( ( temp_output_416_0 * 6.28318548202515 ) * ( temp_output_19_0_g70 * temp_output_27_0_g70 ) ) ) * temp_output_27_0_g70 );
			float3 appendResult46_g70 = (float3(( ( ( _W2Direction * 3.5 ).x * temp_output_37_0_g70 ) * temp_output_41_0_g70 ) , ( sin( temp_output_34_0_g70 ) * ( temp_output_27_0_g70 * 0.5 ) ) , ( temp_output_41_0_g70 * ( temp_output_37_0_g70 * 1.0 ) )));
			float2 appendResult16_g69 = (float2(_W2Direction.x , _W2Direction.y));
			float2 normalizeResult18_g69 = normalize( appendResult16_g69 );
			float dotResult23_g69 = dot( normalizeResult18_g69 , (ase_worldPos).xz );
			float temp_output_19_0_g69 = ( 6.28318548202515 / _W2WaveLength );
			float temp_output_34_0_g69 = ( ( dotResult23_g69 * temp_output_19_0_g69 ) + ( temp_output_10_0 * ( temp_output_19_0_g69 * _W2Speed ) ) );
			float temp_output_37_0_g69 = cos( temp_output_34_0_g69 );
			float temp_output_27_0_g69 = _W2WaveAmplitude;
			float temp_output_41_0_g69 = ( ( temp_output_447_0 / ( ( temp_output_416_0 * 6.28318548202515 ) * ( temp_output_19_0_g69 * temp_output_27_0_g69 ) ) ) * temp_output_27_0_g69 );
			float3 appendResult46_g69 = (float3(( ( _W2Direction.x * temp_output_37_0_g69 ) * temp_output_41_0_g69 ) , ( sin( temp_output_34_0_g69 ) * ( temp_output_27_0_g69 * 0.5 ) ) , ( temp_output_41_0_g69 * ( temp_output_37_0_g69 * 1.0 ) )));
			v.vertex.xyz += ( ( appendResult46_g74 + appendResult46_g73 ) + ( appendResult46_g70 + appendResult46_g69 ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_10_0 = ( ( 0.2004711 * sin( ( _SwayFrequency * 6.28318548202515 * _Time.y ) ) ) + _Time.y );
			float temp_output_78_0 = ( temp_output_10_0 * _MidTime );
			float2 temp_cast_0 = (_MidWaveSpeed).xx;
			float2 uv_TexCoord171 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner79 = ( ( uv_TexCoord171 * _MidWaveScale ) + temp_output_78_0 * temp_cast_0);
			float cos81 = cos( temp_output_78_0 );
			float sin81 = sin( temp_output_78_0 );
			float2 rotator81 = mul( panner79 - float2( 0.5,0 ) , float2x2( cos81 , -sin81 , sin81 , cos81 )) + float2( 0.5,0 );
			float3 tex2DNode82 = UnpackNormal( tex2D( _BaseNormal, rotator81 ) );
			float temp_output_4_0_g72 = _MicroScale;
			float2 uv_TexCoord173 = i.uv_texcoord * float2( 60,60 ) + float2( 0,0 );
			float2 panner225 = ( uv_TexCoord173 + 1.0 * _Time.y * float2( 0,0 ));
			float2 temp_output_28_0_g72 = panner225;
			float temp_output_6_0_g72 = _MicroDistortionSpeed;
			float temp_output_5_0_g72 = temp_output_10_0;
			float temp_output_7_0_g72 = ( temp_output_6_0_g72 * temp_output_5_0_g72 );
			float2 temp_cast_1 = (temp_output_6_0_g72).xx;
			float2 temp_output_15_0_g72 = ( uv_TexCoord173 * temp_output_4_0_g72 );
			float2 panner23_g72 = ( ( temp_output_15_0_g72 + temp_output_15_0_g72 ) + ( temp_output_7_0_g72 + temp_output_7_0_g72 ) * temp_cast_1);
			float2 temp_output_29_0_g72 = ( temp_output_28_0_g72 + panner23_g72 );
			float2 temp_cast_2 = (temp_output_6_0_g72).xx;
			float2 panner24_g72 = ( ( float2( 3,3 ) + temp_output_15_0_g72 ) + ( temp_output_7_0_g72 + 0.025 ) * temp_cast_2);
			float2 temp_output_30_0_g72 = ( temp_output_28_0_g72 + panner24_g72 );
			float temp_output_57_0_g72 = ( temp_output_5_0_g72 * 5E-08 );
			float cos37_g72 = cos( temp_output_57_0_g72 );
			float sin37_g72 = sin( temp_output_57_0_g72 );
			float2 rotator37_g72 = mul( temp_output_30_0_g72 - float2( 0,0 ) , float2x2( cos37_g72 , -sin37_g72 , sin37_g72 , cos37_g72 )) + float2( 0,0 );
			float2 temp_cast_3 = (temp_output_6_0_g72).xx;
			float2 panner27_g72 = ( ( float2( 0.5,0.5 ) + temp_output_15_0_g72 ) + ( temp_output_7_0_g72 + 0.05 ) * temp_cast_3);
			float2 temp_output_31_0_g72 = ( temp_output_28_0_g72 + panner27_g72 );
			float2 temp_cast_4 = (temp_output_6_0_g72).xx;
			float2 panner26_g72 = ( ( float2( 0.2,0.2 ) + temp_output_15_0_g72 ) + ( temp_output_7_0_g72 + 0.075 ) * temp_cast_4);
			float2 temp_output_32_0_g72 = ( temp_output_28_0_g72 + panner26_g72 );
			float cos36_g72 = cos( temp_output_57_0_g72 );
			float sin36_g72 = sin( temp_output_57_0_g72 );
			float2 rotator36_g72 = mul( temp_output_32_0_g72 - float2( 0,0 ) , float2x2( cos36_g72 , -sin36_g72 , sin36_g72 , cos36_g72 )) + float2( 0,0 );
			float3 temp_output_50_0_g72 = ( ( UnpackScaleNormal( tex2D( _MicroNormal, temp_output_29_0_g72 ) ,temp_output_4_0_g72 ) + UnpackScaleNormal( tex2D( _MicroNormal, rotator37_g72 ) ,temp_output_4_0_g72 ) + UnpackScaleNormal( tex2D( _MicroNormal, temp_output_31_0_g72 ) ,temp_output_4_0_g72 ) + UnpackScaleNormal( tex2D( _MicroNormal, rotator36_g72 ) ,temp_output_4_0_g72 ) ) * _MicroIntensity );
			float temp_output_4_0_g71 = _MacroScale;
			float2 panner87 = ( uv_TexCoord173 + temp_output_10_0 * float2( 0,0 ));
			float2 temp_output_28_0_g71 = panner87;
			float temp_output_6_0_g71 = _MacroDistortionSpeed;
			float temp_output_5_0_g71 = temp_output_10_0;
			float temp_output_7_0_g71 = ( temp_output_6_0_g71 * temp_output_5_0_g71 );
			float2 temp_cast_5 = (temp_output_6_0_g71).xx;
			float2 temp_output_15_0_g71 = ( uv_TexCoord173 * temp_output_4_0_g71 );
			float2 panner23_g71 = ( ( temp_output_15_0_g71 + temp_output_15_0_g71 ) + ( temp_output_7_0_g71 + temp_output_7_0_g71 ) * temp_cast_5);
			float2 temp_output_29_0_g71 = ( temp_output_28_0_g71 + panner23_g71 );
			float2 temp_cast_6 = (temp_output_6_0_g71).xx;
			float2 panner24_g71 = ( ( float2( 3,3 ) + temp_output_15_0_g71 ) + ( temp_output_7_0_g71 + 0.025 ) * temp_cast_6);
			float2 temp_output_30_0_g71 = ( temp_output_28_0_g71 + panner24_g71 );
			float temp_output_57_0_g71 = ( temp_output_5_0_g71 * 5E-08 );
			float cos37_g71 = cos( temp_output_57_0_g71 );
			float sin37_g71 = sin( temp_output_57_0_g71 );
			float2 rotator37_g71 = mul( temp_output_30_0_g71 - float2( 0,0 ) , float2x2( cos37_g71 , -sin37_g71 , sin37_g71 , cos37_g71 )) + float2( 0,0 );
			float2 temp_cast_7 = (temp_output_6_0_g71).xx;
			float2 panner27_g71 = ( ( float2( 0.5,0.5 ) + temp_output_15_0_g71 ) + ( temp_output_7_0_g71 + 0.05 ) * temp_cast_7);
			float2 temp_output_31_0_g71 = ( temp_output_28_0_g71 + panner27_g71 );
			float cos35_g71 = cos( temp_output_57_0_g71 );
			float sin35_g71 = sin( temp_output_57_0_g71 );
			float2 rotator35_g71 = mul( temp_output_31_0_g71 - float2( 0,0 ) , float2x2( cos35_g71 , -sin35_g71 , sin35_g71 , cos35_g71 )) + float2( 0,0 );
			float2 temp_cast_8 = (temp_output_6_0_g71).xx;
			float2 panner26_g71 = ( ( float2( 0.2,0.2 ) + temp_output_15_0_g71 ) + ( temp_output_7_0_g71 + 0.075 ) * temp_cast_8);
			float2 temp_output_32_0_g71 = ( temp_output_28_0_g71 + panner26_g71 );
			float3 temp_output_50_0_g71 = ( ( UnpackScaleNormal( tex2D( _MacroNormal, temp_output_29_0_g71 ) ,temp_output_4_0_g71 ) + UnpackScaleNormal( tex2D( _MacroNormal, rotator37_g71 ) ,temp_output_4_0_g71 ) + UnpackScaleNormal( tex2D( _MacroNormal, rotator35_g71 ) ,temp_output_4_0_g71 ) + UnpackScaleNormal( tex2D( _MacroNormal, temp_output_32_0_g71 ) ,temp_output_4_0_g71 ) ) * _MacroIntensity );
			float3 blendOpSrc98 = (temp_output_50_0_g72).xyz;
			float3 blendOpDest98 = (temp_output_50_0_g71).xyz;
			o.Normal = ( ( ( UnpackNormal( tex2D( _BaseNormal, panner79 ) ) * tex2DNode82 ) + ( tex2DNode82 * _MidWaveIntensity ) ) + ( saturate( 	max( blendOpSrc98, blendOpDest98 ) )) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_cast_9 = (_PeakTransitionHeight).xxx;
			float2 temp_cast_10 = (_WhitecapTiling).xx;
			float2 uv_TexCoord205 = i.uv_texcoord * temp_cast_10 + float2( 0,0 );
			float2 panner211 = ( ( 0.5 * uv_TexCoord205 ) + ( 0.8 * uv_TexCoord205 ).x * float2( 1,1 ));
			float4 tex2DNode212 = tex2D( _WhitecapTex, panner211 );
			float clampResult117 = clamp( ( ( (( ase_worldPos - temp_cast_9 )).y + pow( ( ( tex2DNode212.g + tex2DNode212.g ) * _WhitecapSpread ) , _WhitecapIntensity ) ) * _PeakTransitionratio ) , 0.0 , 1.0 );
			float4 lerpResult121 = lerp( _DeepColour , _Peak , clampResult117);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth327 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth327 = abs( ( screenDepth327 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) );
			float clampResult335 = clamp( pow( ( ( 1.0 / _FoamSpread ) * distanceDepth327 ) , _FoamFalloff ) , 0.0 , 1.0 );
			float temp_output_336_0 = ( 1.0 - clampResult335 );
			float2 uv_TexCoord451 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner323 = ( uv_TexCoord451 + ( temp_output_10_0 * _FoamHspeed ) * float2( 0,0 ));
			float2 panner324 = ( panner323 + ( _FoamVspeed * temp_output_10_0 ) * float2( 0,0 ));
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			o.Albedo = ( lerpResult121 + ( ( ( temp_output_336_0 * tex2D( _Foam, panner324 ) ) + pow( ( ( _EdgeLineWidth * 0.5 * ( ( float3( 1,1,1 ) / ase_objectScale ).x + ( float3( 1,1,1 ) / ase_objectScale ).z ) ) + temp_output_336_0 ) , _FoamoutlineFalloff ) ) * _FoamIntensity ) ).rgb;
			o.Metallic = _OceanMetallic;
			o.Smoothness = _OceanSmoothness;
			o.Alpha = _OceanOpacity;
		}

		ENDCG
	}
	CustomEditor "OceanGUI"
}
/*ASEBEGIN
Version=14301
162;92;1289;650;-2975.041;1633.976;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;314;-5258.192,452.7727;Float;False;932;365;Comment;8;5;3;7;4;8;9;10;408;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TauNode;5;-5113.192,574.7728;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-5208.192,502.7727;Float;False;Property;_SwayFrequency;Sway Frequency;6;0;Create;True;0.05;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;408;-5204.42,657.0225;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-4944.192,593.7728;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;161;5160.582,-1211.486;Float;False;4112.394;1190.962;Comment;27;354;121;120;200;117;115;116;217;114;215;112;214;113;213;167;212;211;207;208;205;216;370;210;209;401;402;449;Water Colour;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;8;-4784.192,592.7728;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4930.192,520.7727;Float;False;Constant;_SwayIntensity;Sway Intensity;0;0;Create;True;0.2004711;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;449;5176.802,-548.4321;Float;False;Property;_WhitecapTiling;Whitecap Tiling;48;0;Create;True;0;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;400;1197.256,-1598.916;Float;False;3404.28;1304.478;Comment;31;328;326;329;341;327;330;320;355;337;331;334;321;322;356;323;343;325;335;342;344;336;324;339;345;347;346;340;348;349;350;364;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-4633.192,569.7728;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-4480.192,680.7728;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;5462.75,-668.4464;Float;False;Constant;_Float0;Float 0;35;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;326;1396.557,-1015.137;Float;False;Property;_Depth;Depth;37;0;Create;True;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;5434.849,-366.3408;Float;False;Constant;_Float1;Float 1;35;0;Create;True;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;328;1247.256,-1147.403;Float;False;Property;_FoamSpread;Foam Spread;38;0;Create;True;0;5.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;205;5366.304,-556.5812;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;15,20;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;338;444.7726,-484.5207;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;329;1629.347,-1126.347;Float;False;2;0;FLOAT;1.0;False;1;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;327;1612.668,-1021.457;Float;False;True;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;5742.75,-626.4464;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectScaleNode;341;1833.808,-1465.209;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;5738.645,-503.2559;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;1910.025,-1051.639;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;1801.025,-1199.639;Float;False;Property;_FoamFalloff;Foam Falloff;51;0;Create;True;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;320;1248.44,-468.4382;Float;False;Property;_FoamHspeed;Foam H speed;39;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;337;1331.334,-567.381;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;355;2117.695,-1487.199;Float;False;2;0;FLOAT3;1,1,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;211;5921.133,-580.1207;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;356;2243.695,-1472.199;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;1471.54,-500.3379;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;334;2183.025,-1169.639;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;321;1339.44,-661.4384;Float;False;Property;_FoamVspeed;Foam V speed;36;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;451;1381.452,-780.2328;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;212;6209.537,-647.9548;Float;True;Property;_WhitecapTex;Whitecap Tex;32;0;Create;True;None;d6a8c6ac7d6544942a876a5ee59d40ed;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;342;2607.777,-1451.627;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;3375.314,254.3903;Float;False;2768.367;1950.53;Normals;32;75;73;76;77;78;79;88;81;96;94;101;90;100;103;95;82;87;85;93;80;84;83;98;86;104;171;172;173;178;179;225;229;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;402;6759.805,-595.4074;Float;False;Property;_WhitecapSpread;Whitecap Spread;47;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;2594.195,-1548.916;Float;False;Property;_EdgeLineWidth;EdgeLine Width;43;0;Create;True;0;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;1711.439,-689.4384;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;335;2355.025,-1169.639;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;167;6674.168,-921.4559;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;113;6619.224,-758.0516;Float;False;Property;_PeakTransitionHeight;Peak Transition Height;33;0;Create;True;0;-3.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;6521.208,-652.0018;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;323;1662.039,-548.4383;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;2813.937,-1442.361;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.5;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;3503.711,697.7119;Float;False;Property;_MidTime;Mid Time;23;0;Create;True;0.01;0.0001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;336;2686.027,-1201.638;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;324;1964.439,-547.4383;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;73;3489.033,951.6043;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;171;3429.368,377.501;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;216;7015.258,-506.4064;Float;False;Property;_WhitecapIntensity;Whitecap Intensity;34;0;Create;True;10;4.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;3425.314,563.4858;Float;False;Property;_MidWaveScale;Mid Wave Scale;21;0;Create;True;1;45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;112;6918.223,-851.0519;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;7065.03,-672.4084;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;339;2355.683,-577.7568;Float;True;Property;_Foam;Foam;40;0;Create;True;None;d01457b88b1c5174ea4235d140b5fab8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;114;7113.223,-854.0519;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;215;7236.153,-667.8273;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;345;3033.633,-1443.003;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;4520.558,2874.833;Float;False;2232.711;2430.96;Gerstner Wave Function;32;21;409;24;416;410;413;412;411;14;13;15;12;407;16;25;11;431;436;435;434;433;437;439;440;441;442;443;444;445;446;447;448;Wave Function;1,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;347;3021.537,-1320.911;Float;False;Property;_FoamoutlineFalloff;Foam outline Falloff;41;0;Create;True;77.8;6.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;3808.527,737.1722;Float;False;Property;_MidWaveSpeed;Mid Wave Speed;50;0;Create;True;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;3819.51,605.7057;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;3754.07,373.2487;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;411;4647.421,4178.593;Float;False;Property;_W2NumofWaves;W2: Num of Waves ;11;0;Create;True;1;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;3006.629,-1131.115;Float;True;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;346;3237.536,-1441.911;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;409;4680.512,4248.426;Float;False;Property;_W2Steepness;W2: Steepness;14;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;7616.719,-617.0167;Float;False;Property;_PeakTransitionratio;Peak Transition ratio;35;0;Create;True;0.54;0.0155;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;217;7412.133,-784.1463;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;399;-1228.528,2947.645;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;79;4059.333,373.2906;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,0.01;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;173;3544.582,1517.107;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;60,60;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;412;4660.611,4381.01;Float;False;Property;_W2WaveLength;W2: WaveLength;17;0;Create;True;1;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;4577.231,2920.502;Float;False;Property;_W1NumofWaves;W1: Num of Waves;15;0;Create;True;1;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;447;5001.175,4250.411;Float;False;1E+07;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;4667.525,4520.288;Float;False;Property;_W2Direction;W2: Direction;18;0;Create;True;1,1;0.35,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;349;3503.537,-1311.911;Float;False;Property;_FoamIntensity;Foam Intensity;44;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;229;3837.412,1714.224;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;4596.142,3121.774;Float;False;Property;_W1WaveLength;W1: WaveLength;8;0;Create;True;1;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;4606.686,2986.637;Float;False;Property;_W1Steepness;W1: Steepness;16;0;Create;True;1;500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;416;4998.219,4186.484;Float;False;1E+07;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;348;3530.537,-1408.911;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;410;4638.818,4313.427;Float;False;Property;_W2WaveAmplitude;W2: Wave Amplitude;13;0;Create;True;1;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;7888.177,-784.954;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;16;4672.451,3666.171;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;88;3823.443,1362.076;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;81;4233.655,622.9275;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0;False;2;FLOAT;0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;25;4605.762,3262.972;Float;False;Property;_W1Direction;W1:  Direction;19;0;Create;True;1,1;0.32,0.39;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;96;3788.416,1393.318;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;413;4700.423,4449.699;Float;False;Property;_W2Speed;W2: Speed;9;0;Create;True;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;4643.015,3192.891;Float;False;Property;_W1Speed;W1: Speed;10;0;Create;True;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;4571.214,3056.775;Float;False;Property;_W1WaveAmplitude;W1: Wave Amplitude;12;0;Create;True;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;103;3994.852,2010.921;Float;True;Property;_MicroNormal;Micro Normal;24;0;Create;True;None;7a85200672359d44f909416f3341e4df;True;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;178;4052,1008.999;Float;False;Property;_MacroIntensity;Macro Intensity;31;0;Create;True;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;442;4943.042,3525.255;Float;False;2.75;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;95;4066.734,1612.536;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;434;5201.046,4468.082;Float;False;0.5;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;435;5202.333,4587.573;Float;False;0.5;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;90;3966.093,1424.229;Float;True;Property;_MacroNormal;Macro Normal;25;0;Create;True;67cd5c523b356d84ba3cbc1dc4a8e62e;67cd5c523b356d84ba3cbc1dc4a8e62e;True;bump;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;439;5336.221,4430.897;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;4064.095,1942.589;Float;False;Property;_MicroScale;Micro Scale;26;0;Create;True;0.5;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;441;4943.542,3586.756;Float;False;1.75;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;93;3983.729,1113.691;Float;False;Property;_MacroDistortionSpeed;Macro Distortion Speed;30;0;Create;True;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;445;4785.578,3409.889;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;407;4781.908,2922.809;Float;False;1E+07;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;448;5316.175,4440.411;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;85;4527.709,797.0191;Float;False;Property;_MidWaveIntensity;Mid Wave Intensity;22;0;Create;True;1,1,1;0.4,0.2,-0.61;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleNode;436;5202.832,4649.074;Float;False;3.5;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;437;5175.249,4704.867;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;4457.135,304.3904;Float;True;Property;_BaseNormal;Base Normal;20;0;Create;True;5940fee11a6d3fe49897cb05859fb2d8;5940fee11a6d3fe49897cb05859fb2d8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;117;8153.309,-729.837;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;4456.655,611.9276;Float;True;Property;_TextureSample1;Texture Sample 1;20;0;Create;True;None;None;True;0;False;white;Auto;True;Instance;80;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;446;4782.169,2996.637;Float;False;1E+07;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;87;4147.235,1274.336;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;4060.288,1184.2;Float;False;Property;_MacroScale;Macro Scale;27;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;470;5216.198,4823.24;Float;False;Gerstner Wave;-1;;69;1bc9025ae06f24f408896ff6db037ab0;0;7;22;FLOAT;0.0;False;32;FLOAT;0.0;False;27;FLOAT;0.0;False;17;FLOAT;0.0;False;20;FLOAT;0.0;False;12;FLOAT2;0,0;False;26;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;3788.536,-1396.911;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;444;4945.755,3405.763;Float;False;0.75;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;3986.536,1875.08;Float;False;Property;_MicroDistortionSpeed;Micro Distortion Speed;28;0;Create;True;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;443;4944.644,3464.854;Float;False;0.75;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;433;5203.934,4527.173;Float;False;0.25;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;4038.211,1798.709;Float;False;Property;_MicroIntensity;Micro Intensity;29;0;Create;True;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;225;4102.689,1671.883;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;471;5442.048,4489.924;Float;False;Gerstner Wave;-1;;70;1bc9025ae06f24f408896ff6db037ab0;0;7;22;FLOAT;0.0;False;32;FLOAT;0.0;False;27;FLOAT;0.0;False;17;FLOAT;0.0;False;20;FLOAT;0.0;False;12;FLOAT2;0,0;False;26;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;4901.7,636.8967;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;4903,357.3964;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;200;8140.23,-1113.7;Float;False;Property;_Peak;Peak;49;0;Create;True;0,0,0,0;0.8308824,0.9300203,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;364;4141.711,-561.2428;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;440;5685.847,4701.598;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;473;4987.327,1753.185;Float;True;Panning Normals;-1;;72;86c27b2547eaf6949be21f1206525176;5,42,1,40,1,41,0,54,0,39,0;7;51;FLOAT;0.0;False;28;FLOAT2;0,0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;4;FLOAT;0.0;False;2;FLOAT2;0,0;False;3;SAMPLER2D;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;474;5198.897,3477.173;Float;False;Gerstner Wave;-1;;73;1bc9025ae06f24f408896ff6db037ab0;0;7;22;FLOAT;0.0;False;32;FLOAT;0.0;False;27;FLOAT;0.0;False;17;FLOAT;0.0;False;20;FLOAT;0.0;False;12;FLOAT2;0,0;False;26;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;120;8139.891,-932.13;Float;False;Property;_DeepColour;Deep Colour;42;0;Create;True;0,0,0,1;0,0.0917342,0.1985294,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;475;5127.433,2921.34;Float;False;Gerstner Wave;-1;;74;1bc9025ae06f24f408896ff6db037ab0;0;7;22;FLOAT;0.0;False;32;FLOAT;0.0;False;27;FLOAT;0.0;False;17;FLOAT;0.0;False;20;FLOAT;0.0;False;12;FLOAT2;0,0;False;26;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;472;5000.042,1262.158;Float;True;Panning Normals;-1;;71;86c27b2547eaf6949be21f1206525176;5,42,0,40,1,41,1,54,0,39,0;7;51;FLOAT;0.0;False;28;FLOAT2;0,0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;4;FLOAT;0.0;False;2;FLOAT2;0,0;False;3;SAMPLER2D;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;401;8376.399,-752.1472;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;429;5507.479,3101;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;98;5520.206,1561.848;Float;True;Lighten;True;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;370;6192.942,-428.8087;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;5186.292,567.0533;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;121;8534.173,-934.8987;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;431;5755.215,4489.245;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;6170.934,3102.496;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;354;8889.447,-540.613;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;8641.483,1163.235;Float;False;Property;_OceanMetallic;Ocean Metallic;7;0;Create;True;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;396;8639.62,1300.711;Float;False;Property;_OceanOpacity;Ocean Opacity;46;0;Create;True;0.8;0.918;0.8;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;5908.681,1367.439;Float;True;2;2;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;392;8641.26,1232.28;Float;False;Property;_OceanSmoothness;Ocean Smoothness;45;0;Create;True;1;0.483;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;9362.438,1054.655;Float;False;True;7;Float;OceanGUI;0;0;Standard;Gerstner WaveShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;0;False;0;0;False;0;Custom;0.5;True;False;0;True;TransparentCutout;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;32;10;200;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;4;One;One;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;3;0
WireConnection;7;1;5;0
WireConnection;7;2;408;2
WireConnection;8;0;7;0
WireConnection;9;0;4;0
WireConnection;9;1;8;0
WireConnection;10;0;9;0
WireConnection;10;1;408;2
WireConnection;205;0;449;0
WireConnection;338;0;10;0
WireConnection;329;1;328;0
WireConnection;327;0;326;0
WireConnection;207;0;208;0
WireConnection;207;1;205;0
WireConnection;209;0;210;0
WireConnection;209;1;205;0
WireConnection;330;0;329;0
WireConnection;330;1;327;0
WireConnection;337;0;338;0
WireConnection;355;1;341;0
WireConnection;211;0;207;0
WireConnection;211;1;209;0
WireConnection;356;0;355;0
WireConnection;322;0;337;0
WireConnection;322;1;320;0
WireConnection;334;0;330;0
WireConnection;334;1;331;0
WireConnection;212;1;211;0
WireConnection;342;0;356;0
WireConnection;342;1;356;2
WireConnection;325;0;321;0
WireConnection;325;1;337;0
WireConnection;335;0;334;0
WireConnection;213;0;212;2
WireConnection;213;1;212;2
WireConnection;323;0;451;0
WireConnection;323;1;322;0
WireConnection;344;0;343;0
WireConnection;344;2;342;0
WireConnection;336;0;335;0
WireConnection;324;0;323;0
WireConnection;324;1;325;0
WireConnection;73;0;10;0
WireConnection;112;0;167;0
WireConnection;112;1;113;0
WireConnection;214;0;213;0
WireConnection;214;1;402;0
WireConnection;339;1;324;0
WireConnection;114;0;112;0
WireConnection;215;0;214;0
WireConnection;215;1;216;0
WireConnection;345;0;344;0
WireConnection;345;1;336;0
WireConnection;78;0;73;0
WireConnection;78;1;76;0
WireConnection;77;0;171;0
WireConnection;77;1;75;0
WireConnection;340;0;336;0
WireConnection;340;1;339;0
WireConnection;346;0;345;0
WireConnection;346;1;347;0
WireConnection;217;0;114;0
WireConnection;217;1;215;0
WireConnection;399;0;10;0
WireConnection;79;0;77;0
WireConnection;79;2;172;0
WireConnection;79;1;78;0
WireConnection;447;0;409;0
WireConnection;229;0;173;0
WireConnection;416;0;411;0
WireConnection;348;0;340;0
WireConnection;348;1;346;0
WireConnection;115;0;217;0
WireConnection;115;1;116;0
WireConnection;16;0;399;0
WireConnection;88;0;173;0
WireConnection;81;0;79;0
WireConnection;81;2;78;0
WireConnection;96;0;73;0
WireConnection;442;0;15;0
WireConnection;95;0;96;0
WireConnection;434;0;410;0
WireConnection;435;0;413;0
WireConnection;439;0;416;0
WireConnection;441;0;25;0
WireConnection;445;0;16;0
WireConnection;407;0;11;0
WireConnection;448;0;447;0
WireConnection;436;0;24;0
WireConnection;437;0;16;0
WireConnection;80;1;79;0
WireConnection;117;0;115;0
WireConnection;82;1;81;0
WireConnection;446;0;12;0
WireConnection;87;0;88;0
WireConnection;87;1;73;0
WireConnection;470;22;416;0
WireConnection;470;32;447;0
WireConnection;470;27;410;0
WireConnection;470;17;412;0
WireConnection;470;20;413;0
WireConnection;470;12;24;0
WireConnection;470;26;16;0
WireConnection;350;0;348;0
WireConnection;350;1;349;0
WireConnection;444;0;13;0
WireConnection;443;0;14;0
WireConnection;433;0;412;0
WireConnection;225;0;229;0
WireConnection;471;22;439;0
WireConnection;471;32;448;0
WireConnection;471;27;434;0
WireConnection;471;17;433;0
WireConnection;471;20;435;0
WireConnection;471;12;436;0
WireConnection;471;26;437;0
WireConnection;84;0;82;0
WireConnection;84;1;85;0
WireConnection;83;0;80;0
WireConnection;83;1;82;0
WireConnection;364;0;350;0
WireConnection;440;0;470;0
WireConnection;473;51;179;0
WireConnection;473;28;225;0
WireConnection;473;5;95;0
WireConnection;473;6;101;0
WireConnection;473;4;100;0
WireConnection;473;2;229;0
WireConnection;473;3;103;0
WireConnection;474;22;407;0
WireConnection;474;32;446;0
WireConnection;474;27;444;0
WireConnection;474;17;443;0
WireConnection;474;20;442;0
WireConnection;474;12;441;0
WireConnection;474;26;16;0
WireConnection;475;22;407;0
WireConnection;475;32;446;0
WireConnection;475;27;13;0
WireConnection;475;17;14;0
WireConnection;475;20;15;0
WireConnection;475;12;25;0
WireConnection;475;26;445;0
WireConnection;472;51;178;0
WireConnection;472;28;87;0
WireConnection;472;5;95;0
WireConnection;472;6;93;0
WireConnection;472;4;94;0
WireConnection;472;2;88;0
WireConnection;472;3;90;0
WireConnection;401;0;117;0
WireConnection;429;0;475;0
WireConnection;429;1;474;0
WireConnection;98;0;473;0
WireConnection;98;1;472;0
WireConnection;370;0;364;0
WireConnection;86;0;83;0
WireConnection;86;1;84;0
WireConnection;121;0;120;0
WireConnection;121;1;200;0
WireConnection;121;2;401;0
WireConnection;431;0;471;0
WireConnection;431;1;440;0
WireConnection;21;0;429;0
WireConnection;21;1;431;0
WireConnection;354;0;121;0
WireConnection;354;1;370;0
WireConnection;104;0;86;0
WireConnection;104;1;98;0
WireConnection;0;0;354;0
WireConnection;0;1;104;0
WireConnection;0;3;154;0
WireConnection;0;4;392;0
WireConnection;0;9;396;0
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=7B34D424249EF1BC78ACC0EC0299423061B93E5B