// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VertexColour"
{
	Properties
	{
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
			float4 vertexColor : COLOR;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Color0 = float4(1,0.3161765,0.3161765,0);
			float4 lerpResult2 = lerp( _Color0 , _Color0 , i.vertexColor.r);
			float4 lerpResult9 = lerp( lerpResult2 , float4(0.1574035,1,0.08823532,0) , i.vertexColor.g);
			float4 lerpResult10 = lerp( lerpResult9 , float4(0.2279412,0.9361054,1,0) , i.vertexColor.b);
			o.Albedo = lerpResult10.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
1927;29;1266;958;725.9114;187.5873;1.082534;True;True
Node;AmplifyShaderEditor.VertexColorNode;1;-486.9474,446.7774;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-450.1414,-87.99426;Float;False;Constant;_Color0;Color 0;0;0;Create;True;1,0.3161765,0.3161765,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;2;-208.7366,-40.36277;Float;True;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;8;-450.1416,251.9214;Float;False;Constant;_Color2;Color 2;0;0;Create;True;0.1574035,1,0.08823532,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-271.5236,529.0499;Float;False;Constant;_Color1;Color 1;0;0;Create;True;0.2279412,0.9361054,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;9;-127.5466,262.7468;Float;True;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;10;111.6934,472.7583;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;200.2688,-55.20923;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;VertexColour;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;5;0
WireConnection;2;1;5;0
WireConnection;2;2;1;1
WireConnection;9;0;2;0
WireConnection;9;1;8;0
WireConnection;9;2;1;2
WireConnection;10;0;9;0
WireConnection;10;1;7;0
WireConnection;10;2;1;3
WireConnection;0;0;10;0
ASEEND*/
//CHKSM=D0B2F4D72B9E502277BAB14029565A0E0CCC6516