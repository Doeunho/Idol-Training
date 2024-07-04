Shader "FlightUnit/EnStars/GlowPulse" {
	Properties {
		_MainTex ("Base Color Map", 2D) = "white" {}
		_ShadowColorMap ("ShadowColorMap", 2D) = "white" {}
		_color ("color", Vector) = (1,1,1,0)
		_Shade_Scale ("Shade_Scale", Float) = 1.76
		_Shade_Offset ("Shade_Offset", Float) = 0.55
		[Header(MatCap Setting)] _MatCap ("MatCap", 2D) = "black" {}
		_MatCap_intensity ("MatCap_intensity", Range(0, 1)) = 1
		_MatCap_Scale ("MatCap_Scale", Float) = 1
		_MatCap_Offset ("MatCap_Offset", Float) = -0.66
		[Header(Glow Setting)] _PulseLight_Outside_Scale ("PulseLight_Outside_Scale", Float) = 3.23
		_PulseLight_Outside_Offset1 ("PulseLight_Outside_Offset1", Float) = -1.37
		_PulseLight_Outside_Offset2 ("PulseLight_Outside_Offset2", Float) = -1.65
		_PulseLight_Outside ("PulseLight_Outside", Vector) = (1,1,1,1)
		_PulseLight_Inside_Scale ("PulseLight_Inside_Scale", Float) = 1
		_PulseLight_Inside_Offset ("PulseLight_Inside_Offset", Float) = 0
		[Toggle] _OnlyOffset1 ("Only Offset1", Float) = 1
		_PulseLight_Intside ("PulseLight_Intside", Vector) = (1,1,1,1)
		_Sphererize ("Sphererize", Range(-2, 2)) = 0.95
		_PulseLight_size_X ("PulseLight_size_X", Range(0, 5)) = 0.9
		_PulseLight_size_Y ("PulseLight_size_Y", Range(0, 5)) = 0.47
		_PulseLight_size_Z ("PulseLight_size_Z", Range(0, 5)) = 0.9
		_PulseLight_pos_X ("PulseLight_pos_X", Range(-5, 5)) = 0
		_PulseLight_pos_Y ("PulseLight_pos_Y", Range(-5, 5)) = -0.38
		_PulseLight_pos_Z ("PulseLight_pos_Z", Range(-5, 5)) = 0
		_TimeOffset ("Time Offset", Float) = 0
		[Header(Rim Lighting)] _Rim_Opacity ("Rim_Opacity", Range(0, 1)) = 0
		_Rim_Bias ("Rim_Bias", Float) = 0
		_Rim_Scale ("Rim_Scale", Float) = 3.42
		_Rim_Power ("Rim_Power", Float) = 6.61
		_Rim_Fade_Scale ("Rim_Fade_Scale", Float) = 6.04
		[ASEEnd] _Rim_Fade_Offset ("Rim_Fade_Offset", Float) = -2.7
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[Header(Key Light)] _KeyLightInfluence ("Key Light Influence", Range(0, 1)) = 1
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