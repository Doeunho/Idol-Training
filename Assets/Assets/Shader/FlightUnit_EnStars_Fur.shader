Shader "FlightUnit/EnStars/Fur" {
	Properties {
		[HideInInspector] _Color ("Base Color", Vector) = (1,1,1,1)
		[Header(Base Color)] _MainTex ("Base Color Map", 2D) = "white" {}
		[Header(Fluffy)] _FluffyMask ("Fluffy Mask", Range(0, 1)) = 1
		_FluffyOffset ("Fluffy Size", Range(0, 1)) = 0.015
		_VoronoiAlphaScale ("Fluffy Alpha Scale", Float) = 21.29
		_VoronoiAlphaOffset ("Fluffy Alpha Offset", Float) = -16.89
		[Header(Fur)] [Toggle(ENABLE_FUR_MASK)] _EnableFurMask ("Enable Fur Mask", Float) = 0
		[NoScaleOffset] _FurMask ("Fur Mask", 2D) = "white" {}
		_FurLookupMap ("Fur Lookup Map", 2D) = "white" {}
		[Header(Lighting)] _ShadowColor ("Shadow Color", Vector) = (0.745,0.64,0.64,1)
		_FurShadowColor ("Fur Shadow Color", Vector) = (0.745,0.65,0.65,1)
		_LightScale ("Light Scale", Float) = 2.25
		_LightOffset ("Light Offset", Float) = 0.11
		[Header(Specular Color)] [Toggle(ENABLE_SPECULAR)] _EnableSpecularMap ("Enable Specular Color Map", Float) = 0
		_SpecularIntensity ("Specular Intensity", Range(0, 100)) = 1
		[NoScaleOffset] _SpecularTexture ("Specular Color Map", 2D) = "black" {}
		_SpecularPower ("Specular Power", Float) = 10
		_SpecularIgnoreAngle ("Specular Ignore Angle", Range(0, 1)) = 0
		[Header(Key Light)] _KeyLightInfluence ("Key Light Influence", Range(0, 1)) = 1
		[Header(Fur Rim Light)] _RimColor ("Rim Color", Vector) = (1,1,1,1)
		_RimBias ("Rim Bias", Range(-1, 0)) = 0
		_RimScale ("Rim Scale", Range(0, 1)) = 1
		_RimPower ("Rim Power", Range(0, 5)) = 1.54
		_RimIntensity ("Rim Intensity", Range(0, 1)) = 0.417
		[Header(Chara Rim Light)] [Toggle(ENABLE_RIM_LIGHT)] _EnableRimLight ("Rim Light", Float) = 1
		[Toggle(ENABLE_RIM_LIGHT_MASK)] _EnableRimLightMask ("Enable Rim Light Mask", Float) = 0
		[NoScaleOffset] _RimLightMaskTexture ("Rim Light Mask", 2D) = "white" {}
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
	//CustomEditor "FUnit.EnStarsFurMaterialInspector"
}