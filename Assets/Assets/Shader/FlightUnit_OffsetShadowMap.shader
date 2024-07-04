Shader "FlightUnit/OffsetShadowMap" {
	Properties {
		_MainTex ("Base Color", 2D) = "white" {}
		_Cutoff ("Alpha Clip", Range(0, 1)) = 0.1
		_MaterialId ("Material ID", Float) = 0
		[Toggle(ENABLE_CAST_OFFSET_SHADOW)] _CastOffsetShadow ("Cast Offset Shadow", Float) = 1
		_OffsetShadowCoordinates ("Shadow Offset", Vector) = (0,0,0,0)
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
}