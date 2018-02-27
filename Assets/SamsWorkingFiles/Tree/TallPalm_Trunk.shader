// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TallPalm_Trunk"
{
	Properties
	{
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_ColorShift("ColorShift", Color) = (0,0,0,0)
		_Desaturate("Desaturate", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample4;
		uniform float4 _TextureSample4_ST;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float _Desaturate;
		uniform float4 _ColorShift;
		uniform sampler2D _TextureSample3;
		uniform float4 _TextureSample3_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample4 = i.uv_texcoord * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
			o.Normal = tex2D( _TextureSample4, uv_TextureSample4 ).rgb;
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float3 desaturateVar7 = lerp( tex2D( _TextureSample2, uv_TextureSample2 ).rgb,dot(tex2D( _TextureSample2, uv_TextureSample2 ).rgb,float3(0.299,0.587,0.114)).xxx,_Desaturate);
			o.Albedo = ( float4( desaturateVar7 , 0.0 ) * _ColorShift ).rgb;
			float2 uv_TextureSample3 = i.uv_texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			float4 tex2DNode4 = tex2D( _TextureSample3, uv_TextureSample3 );
			o.Metallic = tex2DNode4.r;
			o.Smoothness = tex2DNode4.g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
1927;29;1266;958;852.162;507.4714;1.706036;True;True
Node;AmplifyShaderEditor.SamplerNode;3;-300.1048,-289.9;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;29ab5b4b826902944b62eae59f0cfc70;29ab5b4b826902944b62eae59f0cfc70;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-229.4588,-67.3141;Float;False;Property;_Desaturate;Desaturate;4;0;Create;True;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;43.50689,-22.95718;Float;False;Property;_ColorShift;ColorShift;4;0;Create;True;0,0,0,0;0.3382353,0.1939879,0.1939879,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;7;171.4596,-156.028;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;263.5855,-4.190794;Float;False;2;2;0;FLOAT3;0.0;False;1;COLOR;0.0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-134.2991,142.0238;Float;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;2cd10dc8d569fbb45b411edec3ba7850;2cd10dc8d569fbb45b411edec3ba7850;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-112.7663,433.3334;Float;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;57d6ef4e66fae8446aa1f73cbbc69edc;57d6ef4e66fae8446aa1f73cbbc69edc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;429,48;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;TallPalm_Trunk;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;3;0
WireConnection;7;1;6;0
WireConnection;12;0;7;0
WireConnection;12;1;14;0
WireConnection;0;0;12;0
WireConnection;0;1;5;0
WireConnection;0;3;4;1
WireConnection;0;4;4;2
ASEEND*/
//CHKSM=C251EE3EFF37903BE441C3E77298F5A3BC15E5B6