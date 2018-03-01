Shader "Cg  shader for billboards" {
	Properties{
		_MainTex("Texture Image", 2D) = "white" {}
	_ScaleX("Scale X", Float) = 1.0
		_ScaleY("Scale Y", Float) = 1.0
		_InvFade("Soft Particles Factor", Range(0.01,3.0)) = 1.0
	}
		SubShader{
		Tags{ 
		"Queue" = "Transparent"
		//"SortingLayer" = "Resources_Sprites"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
		//"CanUseSpriteAtlas" = "True"
		"DisableBatching" = "True" 
	}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha


		Pass{
		CGPROGRAM

#pragma vertex vert  
#pragma fragment frag
//#pragma target 2.0
//#pragma multi_compile _ PIXELSNAP_ON
//#pragma multi_compile _ ETC1_EXTERNAL_ALPHA

#include "UnityCG.cginc"

		// User-specified uniforms            
		uniform sampler2D _MainTex;
	uniform float _ScaleX;
	uniform float _ScaleY;
	uniform sampler2D _CameraDepthTexture;
	uniform float _InvFade;

	struct vertexInput {
		float4 vertex : POSITION;
		float4 tex : TEXCOORD0;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 tex : TEXCOORD0;


		float4 projPos : TEXCOORD4;
	};

	vertexOutput vert(vertexInput v)
	{
		vertexOutput o;

		o.pos = mul(UNITY_MATRIX_P,
			mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0))
			+ float4(v.vertex.x, v.vertex.y, 0.0, 0.0)
			* float4(_ScaleX, _ScaleY, 1.0, 1.0));

		o.tex = v.tex;



		o.projPos = ComputeScreenPos(o.pos);
		COMPUTE_EYEDEPTH(o.projPos.z);


		return o;
	}

	float4 frag(vertexOutput i) : COLOR
	{
		fixed4 col = tex2D(_MainTex, float2(i.tex.xy));


		float sceneDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
		float projZ = i.projPos.z;
		float fade = saturate(_InvFade * (sceneDepth - projZ));
		col.a *= fade;


		col.rgb *= col.a;

		return col;
	}

		ENDCG
	}
	}
}