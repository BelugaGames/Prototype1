// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		[Header(Refraction)]
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_TextureSample7("Texture Sample 7", 2D) = "white" {}
		_WaterSpeed_02("WaterSpeed_02", Float) = 0.02
		_WaterSpeed_03("WaterSpeed_03", Float) = 0.01
		_WaterSpeed_01("WaterSpeed_01", Float) = -0.01
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample7;
		uniform float _WaterSpeed_01;
		uniform sampler2D _TextureSample6;
		uniform float _WaterSpeed_02;
		uniform sampler2D _TextureSample4;
		uniform float _WaterSpeed_03;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _TextureSample2;
		uniform sampler2D _TextureSample3;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_WaterSpeed_01).xx;
			float2 uv_TexCoord46 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float2 panner2 = ( uv_TexCoord46 + 1.0 * _Time.y * temp_cast_0);
			float2 temp_cast_1 = (_WaterSpeed_02).xx;
			float2 uv_TexCoord47 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float2 panner25 = ( uv_TexCoord47 + 1.0 * _Time.y * temp_cast_1);
			float2 temp_cast_2 = (_WaterSpeed_03).xx;
			float2 uv_TexCoord48 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float2 panner26 = ( uv_TexCoord48 + 1.0 * _Time.y * temp_cast_2);
			v.vertex.xyz += ( tex2Dlod( _TextureSample1, float4( panner2, 0, 0.0) ) * tex2Dlod( _TextureSample2, float4( panner25, 0, 0.0) ) * tex2Dlod( _TextureSample3, float4( panner26, 0, 0.0) ) ).rgb;
		}

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout fixed4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 temp_cast_7 = (_WaterSpeed_01).xx;
			float2 uv_TexCoord46 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner2 = ( uv_TexCoord46 + 1.0 * _Time.y * temp_cast_7);
			float2 temp_cast_9 = (_WaterSpeed_02).xx;
			float2 uv_TexCoord47 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner25 = ( uv_TexCoord47 + 1.0 * _Time.y * temp_cast_9);
			float2 temp_cast_11 = (_WaterSpeed_03).xx;
			float2 uv_TexCoord48 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner26 = ( uv_TexCoord48 + 1.0 * _Time.y * temp_cast_11);
			float3 temp_output_27_0 = BlendNormals( BlendNormals( tex2D( _TextureSample7, panner2 ).rgb , tex2D( _TextureSample6, panner25 ).rgb ) , tex2D( _TextureSample4, panner26 ).rgb );
			float fresnelNDotV65 = dot( WorldNormalVector( i , temp_output_27_0 ), ase_worldViewDir );
			float fresnelNode65 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNDotV65, 5.0 ) );
			color.rgb = color.rgb + Refraction( i, o, fresnelNode65, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 temp_cast_0 = (_WaterSpeed_01).xx;
			float2 uv_TexCoord46 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner2 = ( uv_TexCoord46 + 1.0 * _Time.y * temp_cast_0);
			float2 temp_cast_2 = (_WaterSpeed_02).xx;
			float2 uv_TexCoord47 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner25 = ( uv_TexCoord47 + 1.0 * _Time.y * temp_cast_2);
			float2 temp_cast_4 = (_WaterSpeed_03).xx;
			float2 uv_TexCoord48 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner26 = ( uv_TexCoord48 + 1.0 * _Time.y * temp_cast_4);
			float3 temp_output_27_0 = BlendNormals( BlendNormals( tex2D( _TextureSample7, panner2 ).rgb , tex2D( _TextureSample6, panner25 ).rgb ) , tex2D( _TextureSample4, panner26 ).rgb );
			o.Normal = temp_output_27_0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 lerpResult14 = lerp( tex2D( _TextureSample0, uv_TextureSample0 ) , float4(1,1,1,1) , 0.0);
			o.Albedo = lerpResult14.rgb;
			o.Metallic = 0.0;
			o.Alpha = 1;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
1927;29;1266;958;3169.735;1408.992;4.070036;True;True
Node;AmplifyShaderEditor.CommentaryNode;50;-2100.427,-310.946;Float;False;1554.513;875.0701;Normals;14;35;37;46;47;33;25;48;2;21;26;22;24;19;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1893.562,147.3253;Float;False;Property;_WaterSpeed_02;WaterSpeed_02;5;0;Create;True;0.02;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2050.427,-6.630257;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1926.615,-260.946;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-1882.528,-90.43102;Float;False;Property;_WaterSpeed_01;WaterSpeed_01;7;0;Create;True;-0.01;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;25;-1604.023,141.0986;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-1580.353,-113.172;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1991.867,276.1285;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1919.507,433.7505;Float;False;Property;_WaterSpeed_03;WaterSpeed_03;6;0;Create;True;0.01;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-1369.47,-182.8602;Float;True;Property;_TextureSample7;Texture Sample 7;4;0;Create;True;9bcda4c9afc7bdb43880f31573acec22;7d50f93383ae25640905d177a520e812;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1361.939,112.0409;Float;True;Property;_TextureSample6;Texture Sample 6;3;0;Create;True;16d3f61f02106734ea54719eb198f8af;9bcda4c9afc7bdb43880f31573acec22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;26;-1633.081,379.7864;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-1364.015,334.1241;Float;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;7d50f93383ae25640905d177a520e812;16d3f61f02106734ea54719eb198f8af;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;17;-478.3659,-781.1533;Float;False;677.1999;422.1002;Dif Outer RIm;3;14;41;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendNormalsNode;24;-1017.398,-193.0645;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;41;-546.0092,-759.4232;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;ca1179c39f022304bb2f71e4697e7c5d;ca1179c39f022304bb2f71e4697e7c5d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;27;-777.9136,-194.2919;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;18;85.67607,560.6493;Float;False;484.9;436.7;Refraction;1;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;15;-512.3457,-582.0797;Float;False;Constant;_Color0;Color 0;2;0;Create;True;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;51;-404.7204,56.20158;Float;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;None;e5fb849a8f01a054eadc25dfc4c3bf93;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;53;-402.8235,481.0956;Float;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;None;c356bd4b99af11141af0bd31969160c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-438.8636,281.9266;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;None;c1c0fa87b432a7f47bf01e3d0de43066;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;206.8431,-123.179;Float;False;Constant;_Float3;Float 3;12;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;65;265.5582,674.2839;Float;False;Tangent;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-394.0704,-269.2116;Float;False;Constant;_Distance;Distance;11;0;Create;True;2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;12;-142.3875,-437.2632;Float;False;True;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;31.55505,22.05841;Float;False;3;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;68.35101,-589.3089;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;479.0361,-298.8586;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;2;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;47;0
WireConnection;25;2;35;0
WireConnection;2;0;46;0
WireConnection;2;2;37;0
WireConnection;22;1;2;0
WireConnection;21;1;25;0
WireConnection;26;0;48;0
WireConnection;26;2;33;0
WireConnection;19;1;26;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;27;0;24;0
WireConnection;27;1;19;0
WireConnection;51;1;2;0
WireConnection;53;1;26;0
WireConnection;52;1;25;0
WireConnection;65;0;27;0
WireConnection;12;0;69;0
WireConnection;54;0;51;0
WireConnection;54;1;52;0
WireConnection;54;2;53;0
WireConnection;14;0;41;0
WireConnection;14;1;15;0
WireConnection;11;0;14;0
WireConnection;11;1;27;0
WireConnection;11;3;64;0
WireConnection;11;8;65;0
WireConnection;11;11;54;0
ASEEND*/
//CHKSM=96731764AE78D672A7C766B102C259E3F96AA0F1