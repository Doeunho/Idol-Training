Shader "FlightUnit/EnStars/Spangle_Outline" {
	Properties {
		[HideInInspector] _Color ("Base Color", Vector) = (1,1,1,1)
		[Header(Base Color)] _MainTex ("Base Color Map", 2D) = "white" {}
		_OpacityMultiplier ("Opacity Multiplier", Range(0, 1)) = 1
		[Header(MRS)] [Toggle(ENABLE_MRS_MAP)] _EnableMRSMask ("Enable MRS Map", Float) = 0
		[NoScaleOffset] _MRSTexture ("MRS", 2D) = "black" {}
		[Header(Toon)] _ToonColor ("Toon Color", Vector) = (0.969,0.898,0.831,1)
		_LightToonCutoff ("Light Toon Cutoff", Range(-1, 1)) = 0.34
		_LightToonRange ("Light Toon Range", Range(0, 0.5)) = 0.01
		_DarkToonCutoff ("Dark Toon Cutoff", Range(-1, 1)) = 0.6
		_DarkToonRange ("Dark Toon Range", Range(0, 0.5)) = 0.01
		[Toggle(ENABLE_DOUBLETOON)] _EnableDoubleToon ("Enable Double Toon", Float) = 1
		[NoScaleOffset] _MaskTexture ("Double Toon Mask", 2D) = "black" {}
		[Header(Shadow Color Map)] [Toggle(ENABLE_SHADOW_COLOR_MAP)] _EnableShadowColorMap ("Enable Shadow Color Map", Float) = 0
		[NoScaleOffset] _ShadowColorMap ("Shadow Color Map", 2D) = "black" {}
		[Header(Reflection)] [Toggle(ENABLE_REFLECTION)] _EnableReflectionMap ("Enable Reflection", Float) = 0
		[NoScaleOffset] _ReflectionMaskTexture ("Reflection Mask", 2D) = "black" {}
		_EnvironmentIntensity ("Environment Intensity", Range(0, 100)) = 1
		_EnvironmentExponent ("Environment Exponent", Range(0, 20)) = 1
		[NoScaleOffset] _EnvironmentTexture ("Environment", 2D) = "black" {}
		[Header(Specular Color)] [Toggle(ENABLE_SPECULAR)] _EnableSpecularMap ("Enable Specular Color Map", Float) = 0
		_SpecularColor ("Specular Color", Vector) = (1,1,1,1)
		_SpecularIntensity ("Specular Intensity", Range(0, 100)) = 1
		[NoScaleOffset] _SpecularTexture ("Specular Color Map", 2D) = "black" {}
		_SpecularPower ("Specular Power", Float) = 10
		_SpecularIgnoreAngle ("Specular Ignore Angle", Range(0, 1)) = 0
		[Header(Key Light)] _KeyLightInfluence ("Key Light Influence", Range(0, 1)) = 1
		[Header(Rim Light)] [Toggle(ENABLE_RIM_LIGHT)] _EnableRimLight ("Rim Light", Float) = 1
		_RimLightCutoff ("Rim Light Cutoff", Range(-1, 1)) = 0.7
		_RimLightRange ("Rim Light Range", Range(0, 0.5)) = 0.03
		_RimLightDarkCutoff ("Rim Light Dark Cutoff", Range(-1, 1)) = 0.85
		_RimLightDarkRange ("Rim Light Dark Range", Range(0, 0.5)) = 0.03
		[Toggle(ENABLE_RIM_LIGHT_MASK)] _EnableRimLightMask ("Enable Rim Light Mask", Float) = 0
		[NoScaleOffset] _RimLightMaskTexture ("Rim Light Mask", 2D) = "white" {}
		[Header(Height Gradation)] _HeightGradation ("Height Gradation", Range(0, 1)) = 1
		_BaseHeight ("Base Height", Float) = 0
		[Header(Emissive)] [Toggle(ENABLE_EMISSIVE)] _EnableEmissive ("Emissive", Float) = 0
		_EmissiveIntensity ("Emissive Intensity", Range(0, 100)) = 1
		[NoScaleOffset] _EmissiveMap ("Emissive Map", 2D) = "black" {}
		[Toggle(ENABLE_EMISSIVE_COLOR_CYCLING)] _EnableEmissiveColorCycling ("Enable Gaming Color", Float) = 0
		_ColorSpeed ("Color Speed", Float) = 0.5
		[NoScaleOffset] _EmissiveGradation ("Emissive Gradation", 2D) = "white" {}
		[Header(Render States)] [Enum(Front, 2, Back, 1, Both, 0)] _Culling ("Face Rendering", Float) = 2
		[Header(Alpha Blend)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Source Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Destination Blend", Float) = 0
		[Header(Alpha Clip)] [Toggle(ENABLE_ALPHA_CLIP)] _EnableAlphaClip ("Enable Alpha Clip", Float) = 0
		_Cutoff ("Alpha Clip", Range(0, 1)) = 0.1
		[Header(Other Properties)] [Toggle(ENABLE_DEPTH_OFFSET)] _EnableDepthOffset ("Enable Depth Offset", Float) = 0
		_DepthOffset ("Depth Offset", Float) = 0
		[NoScaleOffset] _DepthOffsetMap ("Depth Offset Map", 2D) = "white" {}
		[Header(Shadows)] _MaterialId ("Material ID", Float) = 0
		[Toggle(ENABLE_RECEIVE_OFFSET_SHADOW)] _ReceiveOffsetShadow ("Receive Offset Shadow", Float) = 1
		_OffsetShadowCoordinates ("Shadow Offset", Vector) = (0.015,0.01,0,0)
		[NoScaleOffset] _OffsetShadowMask ("Offset Shadow Mask", 2D) = "white" {}
		[Toggle] _CastOffsetShadow ("Cast Offset Shadow", Float) = 1
		[Header(Spangle)] [NoScaleOffset] _SpangleTex ("SpangleTex", 2D) = "black" {}
		[Toggle] _Spangle0 ("Spangle0", Float) = 0
		[Toggle] _Spangle1 ("Spangle1", Float) = 0
		[Toggle] _Spangle2 ("Spangle2", Float) = 0
		[Toggle] _Spangle3 ("Spangle3", Float) = 0
		[Toggle] _Spangle4 ("Spangle4", Float) = 0
		[Toggle] _Spangle5 ("Spangle5", Float) = 0
		[Toggle] _Spangle6 ("Spangle6", Float) = 0
		[Toggle] _Spangle7 ("Spangle7", Float) = 0
		_Spangle0_size ("Spangle0_size", Float) = 1
		_Spangle1_size ("Spangle1_size", Float) = 1
		_Spangle2_size ("Spangle2_size", Float) = 1
		_Spangle3_size ("Spangle3_size", Float) = 1
		_Spangle4_size ("Spangle4_size", Float) = 1
		_Spangle5_size ("Spangle5_size", Float) = 1
		_Spangle6_size ("Spangle6_size", Float) = 1
		_Spangle7_size ("Spangle7_size", Float) = 1
		_Spangle0_position ("Spangle0_position", Vector) = (0,0,0,0)
		_Spangle1_position ("Spangle1_position", Vector) = (0,0,0,0)
		_Spangle2_position ("Spangle2_position", Vector) = (0,0,0,0)
		_Spangle3_position ("Spangle3_position", Vector) = (0,0,0,0)
		_Spangle4_position ("Spangle4_position", Vector) = (0,0,0,0)
		_Spangle5_position ("Spangle5_position", Vector) = (0,0,0,0)
		_Spangle6_position ("Spangle6_position", Vector) = (0,0,0,0)
		_Spangle7_position ("Spangle7_position", Vector) = (0,0,0,0)
		_Spangle0_color ("Spangle0_color", Vector) = (1,1,1,1)
		_Spangle1_color ("Spangle1_color", Vector) = (1,1,1,1)
		_Spangle2_color ("Spangle2_color", Vector) = (1,1,1,1)
		_Spangle3_color ("Spangle3_color", Vector) = (1,1,1,1)
		_Spangle4_color ("Spangle4_color", Vector) = (1,1,1,1)
		_Spangle5_color ("Spangle5_color", Vector) = (1,1,1,1)
		_Spangle6_color ("Spangle6_color", Vector) = (1,1,1,1)
		_Spangle7_color ("Spangle7_color", Vector) = (1,1,1,1)
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
		fixed4 _Color;
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	//CustomEditor "FUnit.EnStarsCharaMaterialInspector"
}