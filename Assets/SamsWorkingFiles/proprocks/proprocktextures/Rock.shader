// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rock"
{
	Properties
	{
		_Rock1lod0_rock1_AlbedoTransparency("Rock1lod0_rock1_AlbedoTransparency", 2D) = "white" {}
		_Rock1lod0_rock1_MetallicSmoothness("Rock1lod0_rock1_MetallicSmoothness", 2D) = "white" {}
		_Rock1lod0_rock1_Normal("Rock1lod0_rock1_Normal", 2D) = "white" {}
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

		uniform sampler2D _Rock1lod0_rock1_Normal;
		uniform float4 _Rock1lod0_rock1_Normal_ST;
		uniform sampler2D _Rock1lod0_rock1_AlbedoTransparency;
		uniform float4 _Rock1lod0_rock1_AlbedoTransparency_ST;
		uniform sampler2D _Rock1lod0_rock1_MetallicSmoothness;
		uniform float4 _Rock1lod0_rock1_MetallicSmoothness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Rock1lod0_rock1_Normal = i.uv_texcoord * _Rock1lod0_rock1_Normal_ST.xy + _Rock1lod0_rock1_Normal_ST.zw;
			o.Normal = tex2D( _Rock1lod0_rock1_Normal, uv_Rock1lod0_rock1_Normal ).rgb;
			float2 uv_Rock1lod0_rock1_AlbedoTransparency = i.uv_texcoord * _Rock1lod0_rock1_AlbedoTransparency_ST.xy + _Rock1lod0_rock1_AlbedoTransparency_ST.zw;
			o.Albedo = tex2D( _Rock1lod0_rock1_AlbedoTransparency, uv_Rock1lod0_rock1_AlbedoTransparency ).rgb;
			float2 uv_Rock1lod0_rock1_MetallicSmoothness = i.uv_texcoord * _Rock1lod0_rock1_MetallicSmoothness_ST.xy + _Rock1lod0_rock1_MetallicSmoothness_ST.zw;
			float4 tex2DNode2 = tex2D( _Rock1lod0_rock1_MetallicSmoothness, uv_Rock1lod0_rock1_MetallicSmoothness );
			o.Metallic = tex2DNode2.r;
			o.Smoothness = tex2DNode2.g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
1927;29;1266;958;633;479;1;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-394,-132;Float;True;Property;_Rock1lod0_rock1_AlbedoTransparency;Rock1lod0_rock1_AlbedoTransparency;0;0;Create;True;946055182e7cee041988018b7db77cd3;946055182e7cee041988018b7db77cd3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-345,298;Float;True;Property;_Rock1lod0_rock1_Normal;Rock1lod0_rock1_Normal;2;0;Create;True;ee717694c13da1f41a90fc6b1b20d48a;ee717694c13da1f41a90fc6b1b20d48a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-441,47;Float;True;Property;_Rock1lod0_rock1_MetallicSmoothness;Rock1lod0_rock1_MetallicSmoothness;1;0;Create;True;2c92b746cbb676d4387eeba7319d38ce;2c92b746cbb676d4387eeba7319d38ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;28,-130;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Rock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;3;2;1
WireConnection;0;4;2;2
ASEEND*/
//CHKSM=79B4850BF39823CDA8CA77487891F8A6D298D57B