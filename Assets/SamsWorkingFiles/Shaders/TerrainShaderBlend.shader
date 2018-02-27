// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainShaderBlend"
{
	Properties
	{
		_Sand_basecolor("Sand_basecolor", 2D) = "white" {}
		_New_Graph_basecolor("New_Graph_basecolor", 2D) = "white" {}
		_Soil_basecolor("Soil_basecolor", 2D) = "white" {}
		_MossGraph_normal("MossGraph_normal", 2D) = "white" {}
		_New_Graph_normal("New_Graph_normal", 2D) = "white" {}
		_Sand_normal("Sand_normal", 2D) = "white" {}
		_Soil_normal("Soil_normal", 2D) = "white" {}
		_MossGraph_roughness("MossGraph_roughness", 2D) = "white" {}
		_New_Graph_roughness("New_Graph_roughness", 2D) = "white" {}
		_Sand_roughness("Sand_roughness", 2D) = "white" {}
		_Soil_roughness("Soil_roughness", 2D) = "white" {}
		_MossGraph_basecolor("MossGraph_basecolor", 2D) = "white" {}
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
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MossGraph_normal;
		uniform float4 _MossGraph_normal_ST;
		uniform sampler2D _Sand_normal;
		uniform float4 _Sand_normal_ST;
		uniform sampler2D _Soil_normal;
		uniform float4 _Soil_normal_ST;
		uniform sampler2D _New_Graph_normal;
		uniform float4 _New_Graph_normal_ST;
		uniform sampler2D _MossGraph_basecolor;
		uniform float4 _MossGraph_basecolor_ST;
		uniform sampler2D _Sand_basecolor;
		uniform float4 _Sand_basecolor_ST;
		uniform sampler2D _Soil_basecolor;
		uniform float4 _Soil_basecolor_ST;
		uniform sampler2D _New_Graph_basecolor;
		uniform float4 _New_Graph_basecolor_ST;
		uniform sampler2D _MossGraph_roughness;
		uniform float4 _MossGraph_roughness_ST;
		uniform sampler2D _Sand_roughness;
		uniform float4 _Sand_roughness_ST;
		uniform sampler2D _Soil_roughness;
		uniform float4 _Soil_roughness_ST;
		uniform sampler2D _New_Graph_roughness;
		uniform float4 _New_Graph_roughness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MossGraph_normal = i.uv_texcoord * _MossGraph_normal_ST.xy + _MossGraph_normal_ST.zw;
			float4 tex2DNode41 = tex2D( _MossGraph_normal, uv_MossGraph_normal );
			float4 lerpResult15 = lerp( tex2DNode41 , tex2DNode41 , i.vertexColor.r);
			float2 uv_Sand_normal = i.uv_texcoord * _Sand_normal_ST.xy + _Sand_normal_ST.zw;
			float4 lerpResult16 = lerp( lerpResult15 , tex2D( _Sand_normal, uv_Sand_normal ) , i.vertexColor.g);
			float2 uv_Soil_normal = i.uv_texcoord * _Soil_normal_ST.xy + _Soil_normal_ST.zw;
			float4 lerpResult17 = lerp( lerpResult16 , tex2D( _Soil_normal, uv_Soil_normal ) , i.vertexColor.b);
			float2 uv_New_Graph_normal = i.uv_texcoord * _New_Graph_normal_ST.xy + _New_Graph_normal_ST.zw;
			float4 lerpResult18 = lerp( lerpResult17 , tex2D( _New_Graph_normal, uv_New_Graph_normal ) , i.vertexColor.a);
			o.Normal = lerpResult18.rgb;
			float2 uv_MossGraph_basecolor = i.uv_texcoord * _MossGraph_basecolor_ST.xy + _MossGraph_basecolor_ST.zw;
			float4 tex2DNode37 = tex2D( _MossGraph_basecolor, uv_MossGraph_basecolor );
			float4 lerpResult6 = lerp( tex2DNode37 , tex2DNode37 , i.vertexColor.r);
			float2 uv_Sand_basecolor = i.uv_texcoord * _Sand_basecolor_ST.xy + _Sand_basecolor_ST.zw;
			float4 lerpResult7 = lerp( lerpResult6 , tex2D( _Sand_basecolor, uv_Sand_basecolor ) , i.vertexColor.g);
			float2 uv_Soil_basecolor = i.uv_texcoord * _Soil_basecolor_ST.xy + _Soil_basecolor_ST.zw;
			float4 lerpResult8 = lerp( lerpResult7 , tex2D( _Soil_basecolor, uv_Soil_basecolor ) , i.vertexColor.b);
			float2 uv_New_Graph_basecolor = i.uv_texcoord * _New_Graph_basecolor_ST.xy + _New_Graph_basecolor_ST.zw;
			float4 lerpResult9 = lerp( lerpResult8 , tex2D( _New_Graph_basecolor, uv_New_Graph_basecolor ) , i.vertexColor.a);
			o.Albedo = lerpResult9.rgb;
			float2 uv_MossGraph_roughness = i.uv_texcoord * _MossGraph_roughness_ST.xy + _MossGraph_roughness_ST.zw;
			float4 tex2DNode45 = tex2D( _MossGraph_roughness, uv_MossGraph_roughness );
			float4 lerpResult24 = lerp( tex2DNode45 , tex2DNode45 , i.vertexColor.r);
			float2 uv_Sand_roughness = i.uv_texcoord * _Sand_roughness_ST.xy + _Sand_roughness_ST.zw;
			float4 lerpResult25 = lerp( lerpResult24 , tex2D( _Sand_roughness, uv_Sand_roughness ) , i.vertexColor.g);
			float2 uv_Soil_roughness = i.uv_texcoord * _Soil_roughness_ST.xy + _Soil_roughness_ST.zw;
			float4 lerpResult26 = lerp( lerpResult25 , tex2D( _Soil_roughness, uv_Soil_roughness ) , i.vertexColor.b);
			float2 uv_New_Graph_roughness = i.uv_texcoord * _New_Graph_roughness_ST.xy + _New_Graph_roughness_ST.zw;
			float4 lerpResult27 = lerp( lerpResult26 , tex2D( _New_Graph_roughness, uv_New_Graph_roughness ) , i.vertexColor.a);
			o.Smoothness = ( lerpResult27 * -1.0 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
1927;29;1266;958;1229.456;749.1553;2.911692;True;True
Node;AmplifyShaderEditor.VertexColorNode;1;398.957,743.7729;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;45;154.1942,1030.849;Float;True;Property;_MossGraph_roughness;MossGraph_roughness;7;0;Create;True;44b3e392d8e62f948963ce793f9d691b;44b3e392d8e62f948963ce793f9d691b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-540.7316,439.9885;Float;True;Property;_MossGraph_normal;MossGraph_normal;3;0;Create;True;0a9579ab4cb27ac45ace18ba1d20e748;0a9579ab4cb27ac45ace18ba1d20e748;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;24;670.2529,1073.624;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;47;141.8971,1264.493;Float;True;Property;_Sand_roughness;Sand_roughness;9;0;Create;True;23ccbdd5f7e785a4a8108181d2577cd4;23ccbdd5f7e785a4a8108181d2577cd4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;37;-239.4681,-494.7241;Float;True;Property;_MossGraph_basecolor;MossGraph_basecolor;11;0;Create;True;f0f89dbc485cc344084c480b227b75d7;f0f89dbc485cc344084c480b227b75d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-530.9078,695.4075;Float;True;Property;_Sand_normal;Sand_normal;5;0;Create;True;836065398c0efef48a83703cac0ef383;836065398c0efef48a83703cac0ef383;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;15;95.78022,445.5348;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;25;668.2529,1183.624;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;38;-223.0951,-273.8749;Float;True;Property;_Sand_basecolor;Sand_basecolor;0;0;Create;True;fe59ad8b1c3884a449991d700114e2e6;fe59ad8b1c3884a449991d700114e2e6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;6;644.1699,-387.839;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;48;89.63466,1495.062;Float;True;Property;_Soil_roughness;Soil_roughness;10;0;Create;True;0e368f063d15a054c924c597a090d53b;0e368f063d15a054c924c597a090d53b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;674.1984,-231.2521;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-488.338,970.4739;Float;True;Property;_Soil_normal;Soil_normal;6;0;Create;True;af50f7d21068675418df405cd95f4bf5;af50f7d21068675418df405cd95f4bf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;16;90.72105,567.7706;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;40;-249.292,-44.65273;Float;True;Property;_Soil_basecolor;Soil_basecolor;2;0;Create;True;45d13bddffb0d9640ab37af679ac2ca7;45d13bddffb0d9640ab37af679ac2ca7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;665.2529,1307.623;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;46;126.5257,1768.671;Float;True;Property;_New_Graph_roughness;New_Graph_roughness;8;0;Create;True;e40d63cb2158f8541b49cfa1beebfccc;e40d63cb2158f8541b49cfa1beebfccc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;1150.391,1029.98;Float;False;Constant;_Float0;Float 0;12;0;Create;True;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-498.1616,1297.935;Float;True;Property;_New_Graph_normal;New_Graph_normal;4;0;Create;True;a3f0299dc2f71cc4dadbb7312f4e4632;a3f0299dc2f71cc4dadbb7312f4e4632;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;669.2529,1422.624;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;39;-295.1364,161.6472;Float;True;Property;_New_Graph_basecolor;New_Graph_basecolor;1;0;Create;True;0bf2c9c08b891074d8bfb96ec4a1bf89;0bf2c9c08b891074d8bfb96ec4a1bf89;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;671.1984,-107.2522;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;17;87.72118,691.7706;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;33;231.4562,1971.766;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;226.4562,2205.766;Float;False;3;0;FLOAT;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;230.4562,2320.767;Float;False;3;0;FLOAT;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;657.7283,57.24679;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;32;-11.57133,2078.544;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;91.72118,806.7709;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;34;229.4562,2081.766;Float;False;3;0;FLOAT;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;1122.86,846.4371;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;969.2195,175.5366;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;TerrainShaderBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;45;0
WireConnection;24;1;45;0
WireConnection;24;2;1;1
WireConnection;15;0;41;0
WireConnection;15;1;41;0
WireConnection;15;2;1;1
WireConnection;25;0;24;0
WireConnection;25;1;47;0
WireConnection;25;2;1;2
WireConnection;6;0;37;0
WireConnection;6;1;37;0
WireConnection;6;2;1;1
WireConnection;7;0;6;0
WireConnection;7;1;38;0
WireConnection;7;2;1;2
WireConnection;16;0;15;0
WireConnection;16;1;43;0
WireConnection;16;2;1;2
WireConnection;26;0;25;0
WireConnection;26;1;48;0
WireConnection;26;2;1;3
WireConnection;27;0;26;0
WireConnection;27;1;46;0
WireConnection;27;2;1;4
WireConnection;8;0;7;0
WireConnection;8;1;40;0
WireConnection;8;2;1;3
WireConnection;17;0;16;0
WireConnection;17;1;44;0
WireConnection;17;2;1;3
WireConnection;33;2;32;1
WireConnection;35;0;34;0
WireConnection;35;2;32;3
WireConnection;36;0;35;0
WireConnection;36;2;32;4
WireConnection;9;0;8;0
WireConnection;9;1;39;0
WireConnection;9;2;1;4
WireConnection;18;0;17;0
WireConnection;18;1;42;0
WireConnection;18;2;1;4
WireConnection;34;0;33;0
WireConnection;34;2;32;2
WireConnection;49;0;27;0
WireConnection;49;1;50;0
WireConnection;0;0;9;0
WireConnection;0;1;18;0
WireConnection;0;4;49;0
ASEEND*/
//CHKSM=06CE4D2E4006F6EA58C2F2E6CFC3E6282D03F34E