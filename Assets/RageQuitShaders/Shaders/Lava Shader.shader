// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lava"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 4.7
		_TessMin( "Tess Min Distance", Float ) = 1
		_TessMax( "Tess Max Distance", Float ) = 350
		_Float0("Float 0", Float) = 0.05
		_MainDisplacementSpeed("Main Displacement Speed", Float) = 1
		_LavaNormal("Lava Normal", 2D) = "white" {}
		_Magmascale("Magma scale", Float) = 1
		_LavaNormalTiling("Lava Normal Tiling", Float) = 1
		_MagmaNormalTiling("Magma Normal Tiling", Float) = 1
		_SurfaceTransitionRatio("Surface Transition Ratio", Float) = 0
		_MagmaTransitionRatio("Magma Transition Ratio", Float) = 0
		_NormalTransitionRatio("Normal Transition Ratio", Float) = 0
		_HardCrackRatio("Hard Crack Ratio", Float) = 0
		_LavacrackTransitionRatio("Lava crack Transition Ratio", Float) = 0
		_MagmaTransitionHeight("Magma Transition Height", Float) = 1
		_SurfaceTransitionHeight("Surface Transition Height", Float) = 1
		_LavaCrackHeight("Lava Crack Height", Float) = 1
		_NormalTransitionHeight("Normal Transition Height", Float) = 1
		_LavaFlowTexture("Lava Flow Texture", 2D) = "white" {}
		_CrackLavaTexture("Crack Lava Texture", 2D) = "white" {}
		_HardCrackTexture("Hard Crack Texture", 2D) = "white" {}
		_Magmanormal("Magma normal", 2D) = "white" {}
		_LavaHardCrackNormal("Lava Hard Crack Normal", 2D) = "white" {}
		_MainHeightMap("MainHeightMap", 2D) = "white" {}
		_DetailHeightmap("Detail Heightmap", 2D) = "white" {}
		_MagmaTexture("Magma Texture", 2D) = "white" {}
		_FireFlowTexture("Fire Flow Texture", 2D) = "white" {}
		_DisplacementTiling("Displacement Tiling", Float) = 0
		_MainDisplacementHeight("Main Displacement Height", Float) = 0
		_DetailDisplacementspeed("Detail Displacement speed", Float) = 0
		_LavaFlowTiling("Lava Flow Tiling", Float) = 0
		_DetailTiling("Detail Tiling", Float) = 0
		_LavaFlowDirection("Lava Flow Direction", Vector) = (0,0,0,0)
		_HardCrackTiling("HardCrack Tiling", Float) = 0
		_LavaNormalScale("LavaNormalScale", Float) = 0
		_HardCrackScale("Hard CrackScale", Float) = 0
		_DetailDisplacementHeight("Detail Displacement Height", Float) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 0.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 5.0
		#pragma exclude_renderers d3d9 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _Magmascale;
		uniform sampler2D _Magmanormal;
		uniform float _Float0;
		uniform float _MagmaNormalTiling;
		uniform float _LavaNormalScale;
		uniform sampler2D _LavaNormal;
		uniform float _LavaNormalTiling;
		uniform float _HardCrackScale;
		uniform sampler2D _LavaHardCrackNormal;
		uniform float _HardCrackTiling;
		uniform float _LavaCrackHeight;
		uniform float _LavacrackTransitionRatio;
		uniform float _HardCrackRatio;
		uniform float _NormalTransitionHeight;
		uniform float _NormalTransitionRatio;
		uniform sampler2D _MagmaTexture;
		uniform float4 _MagmaTexture_ST;
		uniform sampler2D _LavaFlowTexture;
		uniform float2 _LavaFlowDirection;
		uniform float _LavaFlowTiling;
		uniform float _MagmaTransitionHeight;
		uniform float _MagmaTransitionRatio;
		uniform sampler2D _FireFlowTexture;
		uniform sampler2D _CrackLavaTexture;
		uniform sampler2D _HardCrackTexture;
		uniform float _SurfaceTransitionHeight;
		uniform float _SurfaceTransitionRatio;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform sampler2D _MainHeightMap;
		uniform float _MainDisplacementSpeed;
		uniform float _DisplacementTiling;
		uniform float _MainDisplacementHeight;
		uniform sampler2D _DetailHeightmap;
		uniform float _DetailDisplacementspeed;
		uniform float _DetailTiling;
		uniform float _DetailDisplacementHeight;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_9_0 = ( ( 0.2004711 * sin( ( _Float0 * 6.28318548202515 * _Time.y ) ) ) + _Time.y );
			float temp_output_281_0 = ( temp_output_9_0 / 900.0 );
			float2 temp_cast_0 = (_MainDisplacementSpeed).xx;
			float2 temp_cast_1 = (_DisplacementTiling).xx;
			float2 uv_TexCoord270 = v.texcoord.xy * temp_cast_1 + float2( 0,0 );
			float2 panner271 = ( uv_TexCoord270 + temp_output_281_0 * temp_cast_0);
			float cos279 = cos( temp_output_281_0 );
			float sin279 = sin( temp_output_281_0 );
			float2 rotator279 = mul( panner271 - float2( 1,1 ) , float2x2( cos279 , -sin279 , sin279 , cos279 )) + float2( 1,1 );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_284_0 = ( temp_output_9_0 / 500.0 );
			float2 temp_cast_3 = (_DetailDisplacementspeed).xx;
			float2 temp_cast_4 = (_DetailTiling).xx;
			float2 uv_TexCoord283 = v.texcoord.xy * temp_cast_4 + float2( 0,0 );
			float2 panner285 = ( uv_TexCoord283 + temp_output_284_0 * temp_cast_3);
			float cos286 = cos( temp_output_284_0 );
			float sin286 = sin( temp_output_284_0 );
			float2 rotator286 = mul( panner285 - float2( 0,0 ) , float2x2( cos286 , -sin286 , sin286 , cos286 )) + float2( 0,0 );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( ( ( tex2Dlod( _MainHeightMap, float4( rotator279, 0, 0.0) ) * _MainDisplacementHeight ) * float4( ase_vertexNormal , 0.0 ) ) + ( ( tex2Dlod( _DetailHeightmap, float4( rotator286, 0, 0.0) ) * _DetailDisplacementHeight ) * float4( ase_worldNormal , 0.0 ) ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_9_0 = ( ( 0.2004711 * sin( ( _Float0 * 6.28318548202515 * _Time.y ) ) ) + _Time.y );
			float2 temp_cast_0 = (_MagmaNormalTiling).xx;
			float2 uv_TexCoord64 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 panner83 = ( uv_TexCoord64 + temp_output_9_0 * float2( 0.005,0.005 ));
			float2 temp_cast_2 = (_LavaNormalTiling).xx;
			float2 uv_TexCoord57 = i.uv_texcoord * temp_cast_2 + float2( 0,0 );
			float2 panner65 = ( uv_TexCoord57 + 1.0 * _Time.y * float2( 0,0 ));
			float cos66 = cos( ( temp_output_9_0 * 0.0 ) );
			float sin66 = sin( ( temp_output_9_0 * 0.0 ) );
			float2 rotator66 = mul( panner65 - float2( 0.5,0 ) , float2x2( cos66 , -sin66 , sin66 , cos66 )) + float2( 0.5,0 );
			float3 tex2DNode73 = UnpackScaleNormal( tex2D( _LavaNormal, rotator66 ) ,_LavaNormalScale );
			float2 temp_cast_5 = (_HardCrackTiling).xx;
			float2 uv_TexCoord260 = i.uv_texcoord * temp_cast_5 + float2( 0,0 );
			float3 ase_worldPos = i.worldPos;
			float3 temp_cast_7 = (_LavaCrackHeight).xxx;
			float clampResult216 = clamp( ( (( ase_worldPos - temp_cast_7 )).y * _LavacrackTransitionRatio ) , 0.0 , 1.0 );
			float lerpResult242 = lerp( clampResult216 , -clampResult216 , ( _SinTime.y * 1 ));
			float3 temp_cast_8 = (lerpResult242).xxx;
			float clampResult203 = clamp( ( (( ase_worldPos - temp_cast_8 )).y * _HardCrackRatio ) , 0.0 , 1.0 );
			float4 lerpResult258 = lerp( float4(0,0,0,0) , float4( UnpackScaleNormal( tex2D( _LavaHardCrackNormal, uv_TexCoord260 ) ,_HardCrackScale ) , 0.0 ) , clampResult203);
			float3 temp_cast_9 = (_NormalTransitionHeight).xxx;
			float clampResult158 = clamp( ( (( ase_worldPos - temp_cast_9 )).y * _NormalTransitionRatio ) , 0.0 , 1.0 );
			float4 lerpResult149 = lerp( float4( UnpackScaleNormal( tex2D( _Magmanormal, panner83 ) ,_Magmascale ) , 0.0 ) , ( float4( ( UnpackScaleNormal( tex2D( _LavaNormal, panner65 ) ,_LavaNormalScale ) * tex2DNode73 ) , 0.0 ) + float4( ( tex2DNode73 * float3(1,1,1) ) , 0.0 ) + lerpResult258 ) , clampResult158);
			o.Normal = lerpResult149.rgb;
			float2 uv_MagmaTexture = i.uv_texcoord * _MagmaTexture_ST.xy + _MagmaTexture_ST.zw;
			float4 tex2DNode237 = tex2D( _MagmaTexture, uv_MagmaTexture );
			float2 temp_cast_11 = (_LavaFlowTiling).xx;
			float2 uv_TexCoord298 = i.uv_texcoord * temp_cast_11 + float2( 0,0 );
			float2 panner299 = ( uv_TexCoord298 + 1.0 * _Time.y * ( _LavaFlowDirection * 0.05 ));
			float cos300 = cos( 5E-05 * _Time.y );
			float sin300 = sin( 5E-05 * _Time.y );
			float2 rotator300 = mul( panner299 - float2( 0,0 ) , float2x2( cos300 , -sin300 , sin300 , cos300 )) + float2( 0,0 );
			float4 blendOpSrc169 = tex2D( _LavaFlowTexture, rotator300 );
			float4 blendOpDest169 = tex2DNode237;
			float3 temp_cast_12 = (_MagmaTransitionHeight).xxx;
			float clampResult254 = clamp( ( (( ase_worldPos - temp_cast_12 )).y * _MagmaTransitionRatio ) , 0.0 , 1.0 );
			float4 lerpResult247 = lerp( tex2DNode237 , ( saturate(  (( blendOpSrc169 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc169 - 0.5 ) ) * ( 1.0 - blendOpDest169 ) ) : ( 2.0 * blendOpSrc169 * blendOpDest169 ) ) )) , clampResult254);
			float2 uv_TexCoord190 = i.uv_texcoord * float2( 25,25 ) + float2( 0,0 );
			float2 panner191 = ( uv_TexCoord190 + temp_output_9_0 * float2( 0.05,0 ));
			float4 tex2DNode192 = tex2D( _FireFlowTexture, panner191 );
			float4 blendOpSrc181 = tex2D( _CrackLavaTexture, rotator300 );
			float4 blendOpDest181 = float4(0,0,0,0);
			float4 appendResult183 = (float4(( saturate(  (( blendOpSrc181 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc181 - 0.5 ) ) * ( 1.0 - blendOpDest181 ) ) : ( 2.0 * blendOpSrc181 * blendOpDest181 ) ) )).r , ( saturate(  (( blendOpSrc181 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc181 - 0.5 ) ) * ( 1.0 - blendOpDest181 ) ) : ( 2.0 * blendOpSrc181 * blendOpDest181 ) ) )).r , ( saturate(  (( blendOpSrc181 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc181 - 0.5 ) ) * ( 1.0 - blendOpDest181 ) ) : ( 2.0 * blendOpSrc181 * blendOpDest181 ) ) )).r , ( saturate(  (( blendOpSrc181 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc181 - 0.5 ) ) * ( 1.0 - blendOpDest181 ) ) : ( 2.0 * blendOpSrc181 * blendOpDest181 ) ) )).r));
			float4 blendOpSrc241 = tex2DNode192;
			float4 blendOpDest241 = appendResult183;
			float4 blendOpSrc187 = float4(0.1764706,0,0,0);
			float4 blendOpDest187 = tex2D( _HardCrackTexture, uv_TexCoord260 );
			float temp_output_195_0 = ( ( saturate( ( blendOpDest187 - blendOpSrc187 ) )).r * 0.5 );
			float4 appendResult189 = (float4(temp_output_195_0 , temp_output_195_0 , temp_output_195_0 , temp_output_195_0));
			float4 blendOpSrc193 = tex2DNode192;
			float4 blendOpDest193 = appendResult189;
			float4 blendOpSrc196 = float4(0.6617647,0.3149087,0,1);
			float4 blendOpDest196 = ( saturate( (( blendOpDest193 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest193 - 0.5 ) ) * ( 1.0 - blendOpSrc193 ) ) : ( 2.0 * blendOpDest193 * blendOpSrc193 ) ) ));
			float4 temp_output_196_0 = ( saturate( (( blendOpDest196 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest196 - 0.5 ) ) * ( 1.0 - blendOpSrc196 ) ) : ( 2.0 * blendOpDest196 * blendOpSrc196 ) ) ));
			float4 lerpResult206 = lerp( temp_output_196_0 , ( temp_output_196_0 * 0.01 ) , clampResult203);
			float4 lerpResult184 = lerp( ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest241) / blendOpSrc241) ) )) , lerpResult206 , clampResult216);
			float3 temp_cast_13 = (_SurfaceTransitionHeight).xxx;
			float clampResult164 = clamp( ( (( ase_worldPos - temp_cast_13 )).y * _SurfaceTransitionRatio ) , 0.0 , 1.0 );
			float4 lerpResult166 = lerp( lerpResult247 , lerpResult184 , clampResult164);
			o.Albedo = lerpResult166.rgb;
			float4 appendResult221 = (float4(lerpResult166.r , ( lerpResult166.g * 0.1 ) , ( lerpResult166.b * 0.1 ) , lerpResult166.a));
			o.Emission = appendResult221.xyz;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "LavaGUI"
}
/*ASEBEGIN
Version=14301
249;92;1392;655;-923.0202;-3472.325;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;32;198.2103,-2873.078;Float;False;4326.029;2580.818;Comment;77;242;221;223;222;220;219;218;166;164;169;184;206;165;237;241;216;175;163;217;208;183;210;162;215;203;182;161;196;214;170;197;159;160;181;193;213;204;212;202;192;201;178;238;211;189;191;200;195;198;190;188;205;187;185;186;244;245;246;247;248;249;250;251;252;253;254;255;264;265;299;298;300;301;302;303;260;306;Lava Colour;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;211;1409.539,-1616.962;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;212;1333.937,-1470.13;Float;False;Property;_LavaCrackHeight;Lava Crack Height;18;0;Create;True;1;61.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;213;1664.797,-1575.342;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;214;1719.247,-1458.748;Float;False;Property;_LavacrackTransitionRatio;Lava crack Transition Ratio;15;0;Create;True;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-2221.25,-191.6785;Float;False;932;365;Comment;8;9;8;7;6;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;215;1836.819,-1550.372;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;2;-2076.25,-69.67841;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2171.25,-141.6785;Float;False;Property;_Float0;Float 0;5;0;Create;True;0.05;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-2094.25,63.32159;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;2119.679,-1516.469;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1907.25,-50.67841;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;216;2311.266,-1547.597;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;200.3777,-1372.961;Float;False;Property;_HardCrackTiling;HardCrack Tiling;35;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;260;203.3429,-1300.297;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;265;555.6563,-893.1011;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1893.25,-123.6785;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0.2004711;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;6;-1747.25,-51.67841;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;186;319.7691,-962.6859;Float;False;Constant;_Color2;Color 2;25;0;Create;True;0.1764706,0,0,0;0.3897059,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1596.249,-74.67841;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;244;697.5949,-471.3765;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;302;205.9927,-2278.406;Float;False;Property;_LavaFlowTiling;Lava Flow Tiling;32;0;Create;True;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;301;226.55,-1879.696;Float;False;Property;_LavaFlowDirection;Lava Flow Direction;34;0;Create;True;0,0;0.1,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RelayNode;264;795.5671,-577.9796;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;185;240.3657,-1147.182;Float;True;Property;_HardCrackTexture;Hard Crack Texture;22;0;Create;True;a17913244e8a35a4da19c74d9e648c10;a17913244e8a35a4da19c74d9e648c10;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;187;593.01,-1119.157;Float;True;Subtract;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;245;979.595,-401.3765;Float;False;1;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1443.249,36.3216;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;246;966.595,-479.3765;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;298;224.1263,-2170.419;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;303;359.9927,-2026.406;Float;False;0.05;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;205;622.8598,-706.745;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;188;867.4191,-1113.319;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PannerNode;299;504.5264,-2117.819;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;242;1192.186,-525.5587;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;190;568.5671,-871.4678;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;25,25;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;198;991.035,-728.6138;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleNode;195;1117.149,-1116.089;Float;False;0.5;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;191;862.2545,-865.4678;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;200;1354.293,-614.9937;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotatorNode;300;696.7109,-2115.531;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;5E-05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;238;975.2995,-1710.409;Float;False;Constant;_Color0;Color 0;34;0;Create;True;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;192;1179.126,-890.7018;Float;True;Property;_FireFlowTexture;Fire Flow Texture;28;0;Create;True;d058b7eae73a535499d2951b0a32285e;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;252;447.7564,-2449.259;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;189;1299.524,-1116.983;Float;True;COLOR;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;202;1526.315,-590.0237;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;178;937.0862,-1908.559;Float;True;Property;_CrackLavaTexture;Crack Lava Texture;21;0;Create;True;71c040c802cfcab45848488ab440431d;d058b7eae73a535499d2951b0a32285e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;201;1469.743,-499.3998;Float;False;Property;_HardCrackRatio;Hard Crack Ratio;14;0;Create;True;0;0.019;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;248;427.7834,-2273.979;Float;False;Property;_MagmaTransitionHeight;Magma Transition Height;16;0;Create;True;1;-20.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;159;1878.894,-2560.918;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;10;1134.45,2978.959;Float;False;2577.803;1958.412;Comment;23;18;20;271;272;273;274;275;276;270;278;279;281;283;284;285;286;287;288;289;290;295;296;297;Modified Wave Function;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;249;703.0132,-2407.64;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;1809.175,-556.1208;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;197;1615.149,-856.0889;Float;False;Constant;_Color3;Color 3;32;0;Create;True;0.6617647,0.3149087,0,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;193;1563.149,-1076.089;Float;True;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;160;1838.921,-2406.638;Float;False;Property;_SurfaceTransitionHeight;Surface Transition Height;17;0;Create;True;1;39.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;181;1328.387,-1862.247;Float;True;HardLight;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;56;876.2074,346.5101;Float;False;2774.524;2418.46;Normals;31;83;77;149;256;158;88;84;157;87;75;155;74;67;156;73;64;66;153;152;154;63;151;65;59;57;150;257;259;258;308;307;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;278;1548.173,3612.544;Float;False;Property;_DisplacementTiling;Displacement Tiling;29;0;Create;True;0;2.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;182;1629.427,-1862.31;Float;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;170;1014.887,-2135.312;Float;True;Property;_LavaFlowTexture;Lava Flow Texture;20;0;Create;True;ff79832ae24f5cb4194893a62ca922f8;d058b7eae73a535499d2951b0a32285e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;203;2000.761,-587.2487;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;968.9385,979.9258;Float;False;Property;_LavaNormalTiling;Lava Normal Tiling;9;0;Create;True;1;25.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;296;1531.587,4259.321;Float;False;Property;_DetailTiling;Detail Tiling;33;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;161;2134.151,-2519.299;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;196;1918.149,-980.0889;Float;True;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;20;1560.392,3782.02;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;819.4634,-2292.046;Float;False;Property;_MagmaTransitionRatio;Magma Transition Ratio;12;0;Create;True;0;0.017;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;250;875.0355,-2382.67;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;1157.898,-2348.767;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;208;2199.736,-846.9508;Float;False;0.01;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;183;1936.352,-1867.375;Float;True;COLOR;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;163;2306.173,-2494.329;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;1728.445,3772.725;Float;False;Property;_MainDisplacementSpeed;Main Displacement Speed;6;0;Create;True;1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;295;1737.52,4302.873;Float;False;Property;_DetailDisplacementspeed;Detail Displacement speed;31;0;Create;True;0;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;210;2364.783,-781.2069;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;284;1861.211,4403.027;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;500.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;283;1802.074,4145.748;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;237;1038.783,-2707.808;Float;True;Property;_MagmaTexture;Magma Texture;27;0;Create;True;None;ff79832ae24f5cb4194893a62ca922f8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;1214.829,941.0422;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;270;1774.292,3617.543;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;175;1361.562,-2491.933;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;2250.601,-2403.705;Float;False;Property;_SurfaceTransitionRatio;Surface Transition Ratio;11;0;Create;True;0;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;281;1835.429,3876.821;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;900.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;59;996.0835,1523.969;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;285;2076.147,4290.714;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;154;1125.688,2528.18;Float;False;Property;_NormalTransitionHeight;Normal Transition Height;19;0;Create;True;1;50.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;919.8875,1749.723;Float;False;Property;_MagmaNormalTiling;Magma Normal Tiling;10;0;Create;True;1;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;152;1201.289,2381.349;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendOpsNode;241;2276.534,-1890.692;Float;True;ColorBurn;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;254;1348.134,-2379.895;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;65;1566.384,945.6546;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;206;2410.736,-953.9509;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;2589.035,-2460.426;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;255;1551.943,-2555.187;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;271;2048.365,3762.509;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1370.035,1169.012;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;169;1497.641,-2807.395;Float;True;HardLight;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;308;1763.8,1031.083;Float;False;Property;_LavaNormalScale;LavaNormalScale;36;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;1456.547,2422.968;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;307;2021.967,619.5377;Float;False;Property;_HardCrackScale;Hard CrackScale;37;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;66;1708.102,1180.8;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0;False;2;FLOAT;0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;247;1904.362,-2724.58;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;164;2779.271,-2491.554;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;1183.229,1776.673;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;60,60;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;279;2305.785,3808.317;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;286;2333.568,4336.522;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;184;2855.061,-2369.858;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;259;2293.37,658.0579;Float;False;Constant;_Color4;Color 4;40;0;Create;True;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode;67;1578.347,1898.469;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;166;3144.394,-2750.436;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;287;2571.671,4293.944;Float;True;Property;_DetailHeightmap;Detail Heightmap;26;0;Create;True;None;c9505898b26904342b80b33b470037a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;75;1964.188,876.7544;Float;True;Property;_LavaNormal;Lava Normal;7;0;Create;True;307a7e878a914924db21e801600212a9;307a7e878a914924db21e801600212a9;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;290;2650.95,4489.75;Float;False;Property;_DetailDisplacementHeight;Detail Displacement Height;38;0;Create;True;0;46.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;74;2034.762,1369.383;Float;False;Constant;_Vector2;Vector 2;8;0;Create;True;1,1,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;257;2230.666,463.1478;Float;True;Property;_LavaHardCrackNormal;Lava Hard Crack Normal;24;0;Create;True;None;5bdab6a880a56e4469637a4355e529e9;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;1572.997,2538.562;Float;False;Property;_NormalTransitionRatio;Normal Transition Ratio;13;0;Create;True;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;272;2543.887,3765.738;Float;True;Property;_MainHeightMap;MainHeightMap;25;0;Create;True;None;40dbe5d54f6593c488ac5a8518ccfb76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;73;1963.708,1184.291;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;None;None;True;0;False;white;Auto;True;Instance;75;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;274;2584.166,3953.544;Float;False;Property;_MainDisplacementHeight;Main Displacement Height;30;0;Create;True;0;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;156;1628.569,2447.938;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;2408.752,1209.26;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;218;3516.249,-2186.986;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldNormalVector;297;2991.362,4529.686;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;77;1781.518,1750.457;Float;False;Property;_Magmascale;Magma scale;8;0;Create;True;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;83;1780.533,1825.078;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.005,0.005;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;2410.052,929.7603;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;2932.675,3774.572;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;276;2882.393,3981.261;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;2960.459,4302.778;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;1911.43,2481.841;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;258;2653.331,591.5745;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;3207.346,4289.36;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;158;2103.015,2450.713;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;3179.562,3761.154;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;256;2093.102,1712.223;Float;True;Property;_Magmanormal;Magma normal;23;0;Create;True;None;cf1f89ebf13aa6e48b88a628285c5746;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;220;3816.919,-2070.479;Float;False;0.1;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;2867.546,1104.317;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;222;3856.919,-1948.479;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;219;3800.919,-2124.479;Float;False;0.1;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;223;3485.577,-1831.01;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;3432.781,3699.698;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;239;4457.961,327.3876;Float;False;Property;_Metallic;Metallic;40;0;Create;True;0;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;240;4462.961,404.3876;Float;False;Property;_Smoothness;Smoothness;39;0;Create;True;0;0.083;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;221;3974.919,-2149.479;Float;True;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;149;3338.915,1086.494;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4889.598,97.74036;Float;False;True;7;Float;LavaGUI;0;0;Standard;Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;False;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;4.7;1;350;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;213;0;211;0
WireConnection;213;1;212;0
WireConnection;215;0;213;0
WireConnection;217;0;215;0
WireConnection;217;1;214;0
WireConnection;5;0;3;0
WireConnection;5;1;2;0
WireConnection;5;2;4;0
WireConnection;216;0;217;0
WireConnection;260;0;306;0
WireConnection;265;0;216;0
WireConnection;6;0;5;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;264;0;265;0
WireConnection;185;1;260;0
WireConnection;187;0;186;0
WireConnection;187;1;185;0
WireConnection;245;0;244;2
WireConnection;9;0;8;0
WireConnection;9;1;4;0
WireConnection;246;0;264;0
WireConnection;298;0;302;0
WireConnection;303;0;301;0
WireConnection;205;0;9;0
WireConnection;188;0;187;0
WireConnection;299;0;298;0
WireConnection;299;2;303;0
WireConnection;242;0;264;0
WireConnection;242;1;246;0
WireConnection;242;2;245;0
WireConnection;195;0;188;0
WireConnection;191;0;190;0
WireConnection;191;1;205;0
WireConnection;200;0;198;0
WireConnection;200;1;242;0
WireConnection;300;0;299;0
WireConnection;192;1;191;0
WireConnection;189;0;195;0
WireConnection;189;1;195;0
WireConnection;189;2;195;0
WireConnection;189;3;195;0
WireConnection;202;0;200;0
WireConnection;178;1;300;0
WireConnection;249;0;252;0
WireConnection;249;1;248;0
WireConnection;204;0;202;0
WireConnection;204;1;201;0
WireConnection;193;0;192;0
WireConnection;193;1;189;0
WireConnection;181;0;178;0
WireConnection;181;1;238;0
WireConnection;182;0;181;0
WireConnection;170;1;300;0
WireConnection;203;0;204;0
WireConnection;161;0;159;0
WireConnection;161;1;160;0
WireConnection;196;0;197;0
WireConnection;196;1;193;0
WireConnection;20;0;9;0
WireConnection;250;0;249;0
WireConnection;253;0;250;0
WireConnection;253;1;251;0
WireConnection;208;0;196;0
WireConnection;183;0;182;0
WireConnection;183;1;182;0
WireConnection;183;2;182;0
WireConnection;183;3;182;0
WireConnection;163;0;161;0
WireConnection;210;0;203;0
WireConnection;284;0;20;0
WireConnection;283;0;296;0
WireConnection;57;0;150;0
WireConnection;270;0;278;0
WireConnection;175;0;170;0
WireConnection;281;0;20;0
WireConnection;59;0;9;0
WireConnection;285;0;283;0
WireConnection;285;2;295;0
WireConnection;285;1;284;0
WireConnection;241;0;192;0
WireConnection;241;1;183;0
WireConnection;254;0;253;0
WireConnection;65;0;57;0
WireConnection;206;0;196;0
WireConnection;206;1;208;0
WireConnection;206;2;210;0
WireConnection;165;0;163;0
WireConnection;165;1;162;0
WireConnection;255;0;237;0
WireConnection;271;0;270;0
WireConnection;271;2;18;0
WireConnection;271;1;281;0
WireConnection;63;0;59;0
WireConnection;169;0;175;0
WireConnection;169;1;237;0
WireConnection;153;0;152;0
WireConnection;153;1;154;0
WireConnection;66;0;65;0
WireConnection;66;2;63;0
WireConnection;247;0;255;0
WireConnection;247;1;169;0
WireConnection;247;2;254;0
WireConnection;164;0;165;0
WireConnection;64;0;151;0
WireConnection;279;0;271;0
WireConnection;279;2;281;0
WireConnection;286;0;285;0
WireConnection;286;2;284;0
WireConnection;184;0;241;0
WireConnection;184;1;206;0
WireConnection;184;2;216;0
WireConnection;67;0;64;0
WireConnection;166;0;247;0
WireConnection;166;1;184;0
WireConnection;166;2;164;0
WireConnection;287;1;286;0
WireConnection;75;1;65;0
WireConnection;75;5;308;0
WireConnection;257;1;260;0
WireConnection;257;5;307;0
WireConnection;272;1;279;0
WireConnection;73;1;66;0
WireConnection;73;5;308;0
WireConnection;156;0;153;0
WireConnection;87;0;73;0
WireConnection;87;1;74;0
WireConnection;218;0;166;0
WireConnection;83;0;67;0
WireConnection;83;1;59;0
WireConnection;84;0;75;0
WireConnection;84;1;73;0
WireConnection;273;0;272;0
WireConnection;273;1;274;0
WireConnection;288;0;287;0
WireConnection;288;1;290;0
WireConnection;157;0;156;0
WireConnection;157;1;155;0
WireConnection;258;0;259;0
WireConnection;258;1;257;0
WireConnection;258;2;203;0
WireConnection;289;0;288;0
WireConnection;289;1;297;0
WireConnection;158;0;157;0
WireConnection;275;0;273;0
WireConnection;275;1;276;0
WireConnection;256;1;83;0
WireConnection;256;5;77;0
WireConnection;220;0;218;2
WireConnection;88;0;84;0
WireConnection;88;1;87;0
WireConnection;88;2;258;0
WireConnection;222;0;218;3
WireConnection;219;0;218;1
WireConnection;223;0;166;0
WireConnection;282;0;275;0
WireConnection;282;1;289;0
WireConnection;221;0;218;0
WireConnection;221;1;219;0
WireConnection;221;2;220;0
WireConnection;221;3;222;0
WireConnection;149;0;256;0
WireConnection;149;1;88;0
WireConnection;149;2;158;0
WireConnection;0;0;223;0
WireConnection;0;1;149;0
WireConnection;0;2;221;0
WireConnection;0;3;239;0
WireConnection;0;4;240;0
WireConnection;0;11;282;0
ASEEND*/
//CHKSM=5B011316CF522F8A137D0DB7E9D1DD25CFFC3E1D