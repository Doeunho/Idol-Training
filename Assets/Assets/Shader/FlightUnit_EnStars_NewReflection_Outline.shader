Shader "FlightUnit/EnStars/NewReflection_Outline" {
	Properties {
		[Header(Base Color)] _MainTex ("Base Color Map", 2D) = "white" {}
		_OpacityMultiplier ("Opacity Multiplier", Range(0, 1)) = 1
		[Header(MRS)] [NoScaleOffset] _MRSTexture ("MRS", 2D) = "white" {}
		[Header(Toon)] _ToonColor ("Toon Color", Vector) = (0.969,0.898,0.831,1)
		_LightToonCutoff ("Light Toon Cutoff", Range(-1, 1)) = 0.34
		_LightToonRange ("Light Toon Range", Range(0, 0.5)) = 0.01
		_DarkToonCutoff ("Dark Toon Cutoff", Range(-1, 1)) = 0.6
		_DarkToonRange ("Dark Toon Range", Range(0, 0.5)) = 0.01
		[Header(Shadow Color Map)] [NoScaleOffset] _ShadowColorMap ("Shadow Color Map", 2D) = "black" {}
		[Header(Reflection)] _EnvironmentIntensity ("Environment Intensity", Range(0, 100)) = 1
		_EnvironmentExponent ("Environment Exponent", Range(0, 100)) = 1
		[NoScaleOffset] _EnvironmentTexture ("Environment", 2D) = "black" {}
		_EnvironmentOriginRadius ("Environment Origin and Radius", Vector) = (0,0,0,10)
		[Header(Specular Color)] _SpecularColor ("Specular Color", Vector) = (1,1,1,1)
		_SpecularIntensity ("Specular Intensity", Range(0, 100)) = 1
		_SpecularPower ("Specular Power", Float) = 10
		_SpecularIgnoreAngle ("Specular Ignore Angle", Range(0, 1)) = 0
		[Header(Key Light)] _KeyLightInfluence ("Key Light Influence", Range(0, 1)) = 1
		[Header(Rim Light)] [Toggle] _EnableRimLight ("Rim Light", Float) = 1
		_RimLightCutoff ("Rim Light Cutoff", Range(-1, 1)) = 0.7
		_RimLightRange ("Rim Light Range", Range(0, 0.5)) = 0.03
		_RimLightDarkCutoff ("Rim Light Dark Cutoff", Range(-1, 1)) = 0.85
		_RimLightDarkRange ("Rim Light Dark Range", Range(0, 0.5)) = 0.03
		[NoScaleOffset] _RimLightMaskTexture ("Rim Light Mask", 2D) = "white" {}
		[Header(Height Gradation)] _HeightGradation ("Height Gradation", Range(0, 1)) = 1
		_BaseHeight ("Base Height", Float) = 0
		[Header(Render States)] [Enum(Front, 2, Back, 1, Both, 0)] _Culling ("Face Rendering", Float) = 2
		[Header(Alpha Blend)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Source Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Destination Blend", Float) = 0
		[Header(Alpha Clip)] [Toggle(ENABLE_ALPHA_CLIP)] _EnableAlphaClip ("Enable Alpha Clip", Float) = 0
		_Cutoff ("Alpha Clip", Range(0, 1)) = 0.1
		[Header(Other Properties)] [Toggle(ENABLE_DEPTH_OFFSET)] _EnableDepthOffset ("Enable Depth Offset", Float) = 0
		_DepthOffset ("Depth Offset", Float) = 0
		[NoScaleOffset] _DepthOffsetMap ("Depth Offset Map", 2D) = "white" {}
		[Header(Outline)] [Toggle(ENABLE_VERTEX_COLOR_SCALE)] _EnableVertexColorScale ("Outline Vertex Color Scale", Float) = 0
		[Toggle(ENABLE_FACE_STYLE_VERTEX_COLOR_SCALE)] _EnableFaceStyleVertexColorScale ("Face-Style Vertex Color Scale", Float) = 0
		_OutlineBoost ("Outline Boost", Float) = 0
		_OutlineEffectColor ("Outline Effect Color", Vector) = (1,1,1,0)
		_OutlineColor ("Outline Color", Vector) = (0.4,0.2,0.2,1)
		[NoScaleOffset] _OutlinePattern ("Outline Pattern", 2D) = "" {}
		_OutlineDepthBias ("Outline Depth Bias", Float) = 0
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	//CustomEditor "FUnit.EnStarsNewReflectionMaterialInspector"
}