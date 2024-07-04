Shader "FlightUnit/EnStars/Eye_Line" {
	Properties {
		[HideInInspector] _Color ("Base Color", Vector) = (1,1,1,1)
		[Header(Textures)] [NoScaleOffset] DiffuseSampler_PupWH ("White", 2D) = "white" {}
		[NoScaleOffset] DiffuseSampler_Pup ("Iris", 2D) = "white" {}
		[NoScaleOffset] DiffuseSampler_PupHI ("Highlight", 2D) = "white" {}
		[Header(Specular)] [Toggle(ENABLE_SPECULAR)] _EnableSpecularMap ("Enable Specular Color Map", Float) = 0
		[NoScaleOffset] SpecularSampler_Pup ("Specular", 2D) = "white" {}
		_SpecularPower ("Specular Power", Float) = 10
		[Header(Properties)] _ScleraKeyColorAlpha ("Eye White Ambient", Range(0, 1)) = 1
		_IrisKeyColorAlpha ("Iris Ambient", Range(0, 1)) = 1
		[Header(Key Light)] _KeyLightInfluence ("Key Light Influence", Range(0, 1)) = 1
		[Header(Highlights)] [Toggle(MIRROR_HIGHLIGHT)] _MirrorHighlight ("Mirror Highlight", Float) = 0
		_HighlightColor ("Highlight Color", Vector) = (1,1,1,1)
		_HighlightGlow ("Highlight Glow", Float) = 1
		_HighlightUScale ("Highlight Offset U Scale", Float) = 0
		_HighlightVScale ("Highlight Offset V Scale", Float) = 0
		[Header(Color)] _GlowFactor ("Glow Factor", Range(0, 2)) = 1
		_GlowRatio ("Glow Blend", Range(0, 1)) = 0
		[HDR] _ChangeColor ("Change Color", Vector) = (0,0,0,0)
		[Header(UV Scroll)] g_UVOffsetScale ("UV Offset & Scale", Vector) = (0,0,1,1)
		g_UVHighlightOffset ("UV Highlight Offset", Vector) = (0,0,1,1)
		g_UVRotation ("UV Rotation", Vector) = (0,0,0,0)
		_IrisOriginAndExtents ("Iris Origin & Extents", Vector) = (0.5,0.5,0.25,0.25)
		[Header(Shadows)] _MaterialId ("Material ID", Float) = 1
		[Toggle] _CastOffsetShadow ("Cast Offset Shadow", Float) = 1
		[Header(Line)] _LineAlpha ("Line Alpha", Range(0, 1)) = 0.1
		_LineDepthOffset ("Line Depth Offset", Float) = 0.07
		[HideInInspector] _CharaLineDisable ("_CharaLineDisable", Range(0, 1)) = 0
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		fixed4 _Color;
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
		}
		ENDCG
	}
	//CustomEditor "FUnit.EnStarsEyeMaterialInspector"
}