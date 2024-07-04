Shader "Yamamoto/GlassShader2" {
	Properties {
		[Header(Main Settings)] _Color ("Color", Vector) = (0,0,0,0)
		_Matcap ("Matcap", 2D) = "white" {}
		_Opacity ("Opacity", Range(0, 1)) = 0.49
		[Header(Rim Light Settings)] _Rim_Bias ("Rim_Bias", Range(-1, 1)) = 0
		_Rim_Scale ("Rim_Scale", Range(-1, 1)) = 1
		_Rim_Power ("Rim_Power", Range(0, 10)) = 5
		[HideInInspector] __dirty ("", Float) = 1
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
	Fallback "Diffuse"
}