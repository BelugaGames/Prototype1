// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Icy Mess"
{
	Properties
	{
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_IceColour("Ice Colour", Color) = (0,0,0,0)
		_FresPower("Fres Power", Float) = 1
		_Intensity("Intensity", Float) = 2
		_CubeMap("CubeMap", CUBE) = "white" {}
		_MainTex("Main Tex", 2D) = "white" {}
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "white" {}
		_Distortion("Distortion", Range( -2 , 2)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_RoughnessMap("RoughnessMap", 2D) = "white" {}
		_NormalScale("Normal Scale", Float) = 0
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float3 uv_tex3coord;
			float4 screenPos;
		};

		uniform float _Distortion;
		uniform float _NormalScale;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _IceColour;
		uniform float _FresPower;
		uniform float _Intensity;
		uniform samplerCUBE _CubeMap;
		uniform float4 _CubeMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Metallic;
		uniform sampler2D _RoughnessMap;
		uniform float4 _RoughnessMap_ST;
		uniform float _Smoothness;
		uniform sampler2D _AmbientOcclusion;
		uniform float4 _AmbientOcclusion_ST;
		uniform float _Opacity;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;

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
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 temp_output_73_0 = ( _Distortion * UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalScale ) );
			color.rgb = color.rgb + Refraction( i, o, (temp_output_73_0).xy.x, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 temp_output_73_0 = ( _Distortion * UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalScale ) );
			float4 lerpResult76 = lerp( float4(0,0,1,1) , float4( temp_output_73_0 , 0.0 ) , 0.5);
			o.Normal = lerpResult76.rgb;
			o.Albedo = _IceColour.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNDotV62 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode62 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNDotV62, _FresPower ) );
			float3 uv_CubeMap3 = i.uv_tex3coord;
			uv_CubeMap3.xy = i.uv_tex3coord.xy * _CubeMap_ST.xy + _CubeMap_ST.zw;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_cast_3 = (0.0).xxxx;
			float4 temp_cast_4 = (1.0).xxxx;
			float4 clampResult68 = clamp( ( ( fresnelNode62 * _Intensity ) * texCUBE( _CubeMap, uv_CubeMap3 ) * tex2D( _MainTex, uv_MainTex ) ) , temp_cast_3 , temp_cast_4 );
			o.Emission = clampResult68.rgb;
			o.Metallic = _Metallic;
			float2 uv_RoughnessMap = i.uv_texcoord * _RoughnessMap_ST.xy + _RoughnessMap_ST.zw;
			o.Smoothness = ( tex2D( _RoughnessMap, uv_RoughnessMap ) * _Smoothness ).r;
			float2 uv_AmbientOcclusion = i.uv_texcoord * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
			o.Occlusion = tex2D( _AmbientOcclusion, uv_AmbientOcclusion ).a;
			o.Alpha = _Opacity;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 customPack2 : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
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
				o.customPack2.xyz = customInputData.uv_tex3coord;
				o.customPack2.xyz = v.texcoord;
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
				surfIN.uv_tex3coord = IN.customPack2.xyz;
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
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "IceGUI"
}
/*ASEBEGIN
Version=14301
105;100;575;640;-1913.263;-117.1823;1.785948;True;False
Node;AmplifyShaderEditor.RangedFloatNode;61;659.9837,832.1721;Float;False;Property;_FresPower;Fres Power;2;0;Create;True;1;0.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;256.1442,411.8168;Float;False;Property;_NormalScale;Normal Scale;13;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;62;847.3788,690.0524;Float;True;Tangent;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;921.275,915.5276;Float;False;Property;_Intensity;Intensity;3;0;Create;True;2;4.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;1072.975,973.1404;Float;True;Property;_CubeMap;CubeMap;4;0;Create;True;None;cdbfaa2f949ed474cb0d9bbbff6b8b16;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1254.134,757.5276;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;470.5985,260.8935;Float;False;Property;_Distortion;Distortion;8;0;Create;True;0;0.14;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;449.1153,341.6884;Float;True;Property;_Normal;Normal;7;0;Create;True;None;307a7e878a914924db21e801600212a9;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;67;1025.859,1157.879;Float;True;Property;_MainTex;Main Tex;5;0;Create;True;None;86e377d4a9a952b4e9ef24d7954a53ab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;1016.111,224.077;Float;False;Constant;_Float4;Float 4;9;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;1558.711,1031.121;Float;False;Constant;_Float3;Float 3;5;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;895.5985,375.8935;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;78;999.1109,-2.923035;Float;False;Constant;_Color1;Color 1;9;0;Create;True;0,0,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;2141.423,1301.032;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;2063.178,1093.341;Float;True;Property;_RoughnessMap;RoughnessMap;12;0;Create;True;None;cb49a009b8382134f94f4135364bdfc3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;1493.275,754.5276;Float;True;3;3;0;FLOAT;0.0;False;1;COLOR;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1556.711,961.1209;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;2174.588,51.40648;Float;False;Property;_IceColour;Ice Colour;1;0;Create;True;0,0,0,0;0.5514706,0.9443205,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;2095.172,1401.443;Float;True;Property;_AmbientOcclusion;Ambient Occlusion;11;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;68;1777.711,764.1209;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;2480.178,1075.341;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;2144.73,1009.796;Float;False;Property;_Opacity;Opacity;6;0;Create;True;0;0.534;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;2109.575,417.4975;Float;False;Property;_Metallic;Metallic;10;0;Create;True;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;75;1182.599,372.8935;Float;True;True;True;False;True;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;76;1246.111,141.077;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2638.031,411.0681;Float;False;True;7;Float;IceGUI;0;0;Standard;Icy Mess;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Translucent;0.5;True;True;0;False;Opaque;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;0;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;3;61;0
WireConnection;63;0;62;0
WireConnection;63;1;64;0
WireConnection;72;5;84;0
WireConnection;73;0;74;0
WireConnection;73;1;72;0
WireConnection;65;0;63;0
WireConnection;65;1;66;0
WireConnection;65;2;67;0
WireConnection;68;0;65;0
WireConnection;68;1;69;0
WireConnection;68;2;70;0
WireConnection;83;0;82;0
WireConnection;83;1;80;0
WireConnection;75;0;73;0
WireConnection;76;0;78;0
WireConnection;76;1;73;0
WireConnection;76;2;77;0
WireConnection;0;0;60;0
WireConnection;0;1;76;0
WireConnection;0;2;68;0
WireConnection;0;3;79;0
WireConnection;0;4;83;0
WireConnection;0;5;81;4
WireConnection;0;8;75;0
WireConnection;0;9;71;0
ASEEND*/
//CHKSM=27CE742DD8CF03D4BE0D6151BDBE1708E873D73C