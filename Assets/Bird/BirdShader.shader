// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BirdShader"
{
	Properties
	{
		_bird_normals("bird_normals", 2D) = "white" {}
		_BirdTexture_Albedo("BirdTexture_Albedo", 2D) = "white" {}
		_BirdTexture_Roughness("BirdTexture_Roughness", 2D) = "white" {}
		_TheBirdColor("TheBirdColor", Color) = (0.4231185,0.6323529,0.5024833,1)
		_EmissiveMult("Emissive Mult", Range( 0 , 10)) = 0
		_BirdTexture_Mask3("BirdTexture_Mask3", 2D) = "white" {}
		_power("power", Range( 0 , 5)) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _bird_normals;
		uniform float4 _bird_normals_ST;
		uniform float4 _TheBirdColor;
		uniform sampler2D _BirdTexture_Albedo;
		uniform float4 _BirdTexture_Albedo_ST;
		uniform sampler2D _BirdTexture_Mask3;
		uniform float4 _BirdTexture_Mask3_ST;
		uniform float _power;
		uniform float _EmissiveMult;
		uniform sampler2D _BirdTexture_Roughness;
		uniform float4 _BirdTexture_Roughness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_bird_normals = i.uv_texcoord * _bird_normals_ST.xy + _bird_normals_ST.zw;
			o.Normal = tex2D( _bird_normals, uv_bird_normals ).rgb;
			float2 uv_BirdTexture_Albedo = i.uv_texcoord * _BirdTexture_Albedo_ST.xy + _BirdTexture_Albedo_ST.zw;
			float2 uv_BirdTexture_Mask3 = i.uv_texcoord * _BirdTexture_Mask3_ST.xy + _BirdTexture_Mask3_ST.zw;
			float4 tex2DNode16 = tex2D( _BirdTexture_Mask3, uv_BirdTexture_Mask3 );
			float4 temp_cast_1 = (_power).xxxx;
			float4 lerpResult11 = lerp( _TheBirdColor , tex2D( _BirdTexture_Albedo, uv_BirdTexture_Albedo ) , ( 1.0 - pow( tex2DNode16 , temp_cast_1 ) ));
			o.Albedo = lerpResult11.rgb;
			float4 lerpResult8 = lerp( float4( 0,0,0,0 ) , _TheBirdColor , tex2DNode16.r);
			o.Emission = ( _EmissiveMult * lerpResult8 ).rgb;
			float2 uv_BirdTexture_Roughness = i.uv_texcoord * _BirdTexture_Roughness_ST.xy + _BirdTexture_Roughness_ST.zw;
			o.Smoothness = tex2D( _BirdTexture_Roughness, uv_BirdTexture_Roughness ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
1927;29;1266;958;1647.933;-8.815796;1.529609;True;True
Node;AmplifyShaderEditor.SamplerNode;16;-680.4171,1164.344;Float;True;Property;_BirdTexture_Mask3;BirdTexture_Mask3;5;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1072.8,964.8218;Float;False;Property;_power;power;6;0;Create;True;2;2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;-850.8125,942.6158;Float;False;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-588.9466,644.8094;Float;False;Property;_TheBirdColor;TheBirdColor;3;0;Create;True;0.4231185,0.6323529,0.5024833,1;0.5735295,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;-307.2438,768.8967;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-742.6547,-407.3948;Float;True;Property;_BirdTexture_Albedo;BirdTexture_Albedo;1;0;Create;True;d56cfb77ec60ab84b8f0e200ab7bfb02;d56cfb77ec60ab84b8f0e200ab7bfb02;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;13;-1016.552,719.554;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-334.8401,477.8618;Float;False;Property;_EmissiveMult;Emissive Mult;4;0;Create;True;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-824.6321,67.68816;Float;True;Property;_bird_normals;bird_normals;0;0;Create;True;ff2c1af7cfe40674b9b5dec377ec1486;ff2c1af7cfe40674b9b5dec377ec1486;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-309.7085,-217.838;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-126.38,594.9449;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-823.2404,258.0633;Float;True;Property;_BirdTexture_Roughness;BirdTexture_Roughness;2;0;Create;True;51c76b108c6a76142b4c0227ae124118;51c76b108c6a76142b4c0227ae124118;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;BirdShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;8;1;7;0
WireConnection;8;2;16;0
WireConnection;13;0;18;0
WireConnection;11;0;7;0
WireConnection;11;1;2;0
WireConnection;11;2;13;0
WireConnection;14;0;15;0
WireConnection;14;1;8;0
WireConnection;0;0;11;0
WireConnection;0;1;1;0
WireConnection;0;2;14;0
WireConnection;0;4;4;0
ASEEND*/
//CHKSM=7F8196D6B75D4A08E4EA01701791765D159226AA