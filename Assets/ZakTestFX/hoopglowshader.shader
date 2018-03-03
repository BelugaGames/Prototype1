// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "hoopglow"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_fuck_basecolor("fuck_basecolor", 2D) = "white" {}
		_glowcolor("glowcolor", Color) = (1,1,1,0)
		_Noise2("Noise2", 2D) = "white" {}
		_Noise_1("Noise_1", 2D) = "white" {}
		_glowstrength("glow strength", Range( 0 , 50)) = 50
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _glowcolor;
		uniform sampler2D _fuck_basecolor;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform sampler2D _Noise_1;
		uniform sampler2D _Noise2;
		uniform float _glowstrength;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _glowcolor.rgb;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float2 uv_TexCoord14 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner18 = ( uv_TexCoord14 + 1.0 * _Time.y * float2( 0,0.2 ));
			float2 panner19 = ( uv_TexCoord14 + 1.0 * _Time.y * float2( 0,-0.3 ));
			float4 clampResult30 = clamp( ( pow( ( tex2D( _TextureSample1, uv_TextureSample1 ) * ( ( tex2D( _Noise_1, ( panner18 + 0.5 ) ).r + tex2D( _Noise2, panner19 ).r ) * 0.3 ) ) , 2.0 ) * _glowstrength ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Alpha = tex2D( _fuck_basecolor, clampResult30.rg ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
21;408;1369;928;1140.509;213.4383;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2640.645,16.18109;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-2474.246,289.1807;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.2;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2340.376,173.2935;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2259.296,298.2372;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-2469.694,521.1826;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.3;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;-2054.041,239.7514;Float;True;Property;_Noise_1;Noise_1;4;0;Create;True;771c9dd14058c934583f1222fe1592bd;771c9dd14058c934583f1222fe1592bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-2049.489,471.7534;Float;True;Property;_Noise2;Noise2;3;0;Create;True;771c9dd14058c934583f1222fe1592bd;771c9dd14058c934583f1222fe1592bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1709.014,377.9886;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1537.106,384.5004;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-2058.495,0.9562163;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;47f3c6dd6406fc2468cfa59bdd821ad9;47f3c6dd6406fc2468cfa59bdd821ad9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1395.587,377.4888;Float;True;2;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;27;-1164.072,549.4912;Float;True;2;0;COLOR;0.0;False;1;FLOAT;2.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1074.6,829.4165;Float;False;Property;_glowstrength;glow strength;5;0;Create;True;50;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-903.5807,566.6522;Float;True;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;30;-675.7409,574.3072;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-561.6376,182.4811;Float;True;Property;_fuck_basecolor;fuck_basecolor;1;0;Create;True;47f3c6dd6406fc2468cfa59bdd821ad9;47f3c6dd6406fc2468cfa59bdd821ad9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-326.6789,-119.1007;Float;False;Property;_glowcolor;glowcolor;2;0;Create;True;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;8;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;hoopglow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;0;False;0;0;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;14;0
WireConnection;22;0;18;0
WireConnection;22;1;23;0
WireConnection;19;0;14;0
WireConnection;17;1;22;0
WireConnection;20;1;19;0
WireConnection;21;0;17;1
WireConnection;21;1;20;1
WireConnection;24;0;21;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;27;0;26;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;30;0;28;0
WireConnection;6;1;30;0
WireConnection;8;2;9;0
WireConnection;8;9;6;1
ASEEND*/
//CHKSM=394804855C82A1387960EBFF5F0F0409FDA57F1A