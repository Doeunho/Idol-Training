Shader "Yamamoto/NamidaShader_Drop" {
	Properties {
		_NamidaDrop_Base_Tex ("NamidaDrop_Base_Tex", 2D) = "white" {}
		_NamidaDrop_Base_Tex_Normal ("NamidaDrop_Base_Tex_Normal", 2D) = "white" {}
		_Drop_Size_X ("Drop_Size_X", Range(0, 0.1)) = 0.1
		_Drop_Size_Y ("Drop_Size_Y", Range(0, 0.1)) = 0.0939
		_Drop_Offset_X ("Drop_Offset_X", Float) = -2.13
		_Drop_Offset_Y ("Drop_Offset_Y", Float) = 0.23
		_Puddle_Rotate ("Puddle_Rotate ", Float) = -0.06
		_Drop_Rotate ("Drop_Rotate ", Float) = -0.06
		[Toggle] _Mirror_X ("Mirror_X", Float) = 1
		_Drop_Noise_X ("Drop_Noise_X", Range(-1, 1)) = 0
		_Drop_Noise_Y ("Drop_Noise_Y", Range(-1, 1)) = 0
		_Drop_Noise_Power ("Drop_Noise_Power", Range(0.8, 1)) = 1
		_Drop_Noise_Scale ("Drop_Noise_Scale", Range(0, 100)) = 0.942
		_Drop_Slide ("Drop_Slide", Range(0.86, 1.015)) = 1.01323
		_Drop_Opacity ("Drop_Opacity", Range(0, 0.999)) = 0.999
		_Namida_Base_Tex_Normal ("Namida_Base_Tex_Normal", 2D) = "bump" {}
		_Normal_Strange ("Normal_Strange", Range(0, 1)) = 1
		_Puddle_Size_X ("Puddle_Size_X", Range(0, 0.1)) = 0.0588
		_Puddle_Size_Y ("Puddle_Size_Y", Range(0, 0.3)) = 0.168
		_Puddle_Offset_X ("Puddle_Offset_X", Float) = -1.21
		_Puddle_Offset_Y ("Puddle_Offset_Y", Float) = 0.45
		_Puddle_Noise_X ("Puddle_Noise_X", Range(-1, 1)) = 0
		_Puddle_Noise_Y ("Puddle_Noise_Y", Range(-1, 1)) = 0
		_Puddle_Noise_X_Speed ("Puddle_Noise_X_Speed", Range(-1, 1)) = 0
		_Puddle_Noise_Y_Speed ("Puddle_Noise_Y_Speed", Range(-1, 1)) = 0
		_Puddle_Noise_Power ("Puddle_Noise_Power", Range(0.8, 1)) = 1
		_Puddle_Noise_Scale ("Puddle_Noise_Scale", Range(0, 100)) = 5.229146
		_Puddle_Opacity ("Puddle_Opacity", Range(0, 0.999)) = 0.999
		_Namida_Base_Tex ("Namida_Base_Tex", 2D) = "white" {}
		_MatcapTex ("MatcapTex", 2D) = "white" {}
		_Matcap_Bias ("Matcap_Bias", Range(0, 1)) = 0
		_Color ("Color", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord ("", 2D) = "white" {}
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