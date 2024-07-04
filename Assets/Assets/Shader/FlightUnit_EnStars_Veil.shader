Shader "FlightUnit/EnStars/Veil" {
	Properties {
		[HideInInspector] _Color ("Base Color", Vector) = (1,1,1,1)
		[Header(Base Color)] _MainTex ("Base Color Map", 2D) = "white" {}
		_OpacityMultiplier ("Opacity Multiplier", Range(0, 1)) = 1
		[Toggle(ENABLE_VERTEX_COLOR_BLEND)] _EnableVertexColorBlend ("Enable Vertex Color", Float) = 0
		[Header(Veil)] [NoScaleOffset] _VeilTexture ("Veil Texture", 2D) = "white" {}
		_VeilTilingX ("Veil X Tiling", Float) = 1
		_VeilTilingY ("Veil Y Tiling", Float) = 1
		_VeilRotation ("Veil Rotation", Range(0, 1)) = 0
		[Header(Veil Depth Settings)] _VeilDepthScale ("Veil Depth Scale", Range(0, 10)) = 1
		_VeilDepthOffset ("Veil Depth Offset", Range(-5, 5)) = 0
		[Header(Toon)] _ToonColor ("Toon Color", Vector) = (0.969,0.898,0.831,1)
		_LightToonCutoff ("Light Toon Cutoff", Range(-1, 1)) = 0.34
		_LightToonRange ("Light Toon Range", Range(0, 0.5)) = 0.01
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
		[Header(Render States)] [Toggle] _ZWriteEnable ("Z Write", Float) = 1
		[Header(Other Properties)] [Toggle(ENABLE_DEPTH_OFFSET)] _EnableDepthOffset ("Enable Depth Offset", Float) = 0
		_DepthOffset ("Depth Offset", Float) = 0
		[NoScaleOffset] _DepthOffsetMap ("Depth Offset Map", 2D) = "white" {}
		[Header(Shadows)] _MaterialId ("Material ID", Float) = 0
		[Toggle(ENABLE_RECEIVE_OFFSET_SHADOW)] _ReceiveOffsetShadow ("Receive Offset Shadow", Float) = 1
		_OffsetShadowCoordinates ("Shadow Offset", Vector) = (0.015,0.01,0,0)
		[NoScaleOffset] _OffsetShadowMask ("Offset Shadow Mask", 2D) = "white" {}
		[Toggle] _CastOffsetShadow ("Cast Offset Shadow", Float) = 1
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