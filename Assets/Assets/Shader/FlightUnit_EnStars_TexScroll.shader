Shader "FlightUnit/EnStars/TexScroll" {
	Properties {
		[NoScaleOffset] _ScrollTex ("Scroll Tex", 2D) = "white" {}
		_UV_X ("UV_X", Float) = 1
		_UV_Y ("UV_Y", Float) = 1
		_Scroll_X ("Scroll_X", Float) = 0
		_Scroll_Y ("Scroll_Y", Float) = 0.47
		_Rotate ("Rotate", Float) = -0.76
		[Header(Offset Rim setting)] _Offset_Rim_Bias ("Offset_Rim_Bias", Float) = 0
		_Offset_Rim_Scale ("Offset_Rim_Scale", Float) = 1
		_Offset_Rim_Power ("Offset_Rim_Power", Float) = 5
		[Header(Sphere Setting)] _Sphere_Scale ("Sphere_Scale", Float) = 4.78
		_Sphere_Offset ("Sphere_Offset", Float) = -2.13
		_Sphere_size_X ("Sphere_size_X", Range(0, 5)) = 0.55
		_Sphere_size_Y ("Sphere_size_Y", Range(0, 5)) = 0.28
		_Sphere_size_Z ("Sphere_size_Z", Range(0, 5)) = 0.55
		_Sphere_pos_X ("Sphere_pos_X", Range(-5, 5)) = 0
		_Sphere_pos_Y ("Sphere_pos_Y", Range(-5, 5)) = 0
		_Sphere_pos_Z ("Sphere_pos_Z", Range(-5, 5)) = 0
		_color ("color", Vector) = (1,1,1,1)
		[Header(Key Light)] _KeyLightInfluence ("Key Light Influence", Range(0, 1)) = 1
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = 1;
		}
		ENDCG
	}
}