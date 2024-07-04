Shader "FlightUnit/EnStars/Face_Line_Outline" {
	Properties {
		[HideInInspector] _Color ("Base Color", Vector) = (1,1,1,1)
		[Header(Base Color)] _MainTex ("Base Color Map", 2D) = "white" {}
		_OpacityMultiplier ("Opacity Multiplier", Range(0, 1)) = 1
		[Header(Blush)] [NoScaleOffset] _BlushMap ("Blush Map", 2D) = "black" {}
		_BlushIntensity ("Blush", Range(0, 1)) = 0
		[Header(Normal Average Map)] [NoScaleOffset] _NormalMapTexture ("Normal Average Mask", 2D) = "black" {}
		_NormalSphereCenter ("Normal Sphere Center", Vector) = (0,0,0,0)
		[Header(Toon)] _ToonColor ("Toon Color", Vector) = (0.969,0.898,0.831,1)
		_LightToonCutoff ("Light Toon Cutoff", Range(-1, 1)) = 0.34
		_LightToonRange ("Light Toon Range", Range(0, 0.5)) = 0.01
		_DarkToonCutoff ("Dark Toon Cutoff", Range(-1, 1)) = 0.6
		_DarkToonRange ("Dark Toon Range", Range(0, 0.5)) = 0.01
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
		[Header(Outline)] [Toggle(ENABLE_VERTEX_COLOR_SCALE)] _EnableVertexColorScale ("Outline Vertex Color Scale", Float) = 0
		_OutlineBoost ("Outline Boost", Float) = 0
		_OutlineEffectColor ("Outline Effect Color", Vector) = (1,1,1,0)
		_OutlineColor ("Outline Color", Vector) = (0.4,0.2,0.2,1)
		[NoScaleOffset] _OutlinePattern ("Outline Pattern", 2D) = "" {}
		_OutlineDepthBias ("Outline Depth Bias", Float) = 0
		[Header(Line)] [NoScaleOffset] _LineTexture ("Line Texture", 2D) = "white" {}
		_LineAlpha ("Line Alpha", Range(0, 1)) = 1
		_LineDepthOffset ("Line Depth Offset", Float) = 0.01
		_LineAngleLimit ("Angle Limit", Range(0, 1)) = 0.46
		[Enum(UnityEngine.Rendering.BlendMode)] _LineSrcBlend ("Line Source Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _LineDstBlend ("Line Destination Blend", Float) = 10
		[Toggle] _CharaLineDisableRightSide ("Disable Right Eye Line", Float) = 0
		[Toggle] _CharaLineDisableLeftSide ("Disable Left Eye Line", Float) = 0
		[HideInInspector] _CharaLineDisable ("_CharaLineDisable", Range(0, 1)) = 0
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