// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Light Shader PBS" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Texture", 2D) = "white" {}
		// _SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)

		//One detail is that the metallic slider itself is supposed to be in gamma space. 
		//But single values are not automatically gamma corrected by Unity,
		// when rendering in linear space. 
		//We can use the Gamma attribute to tell Unity that it should also
		// apply gamma correction to our metallic slider.
		[Gamma]_Metallic ("Metallic", Range(0, 1)) = 0


		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
	}

	SubShader {

		Pass {

			Tags {
				"LightMode" = "ForwardBase"
			}


			CGPROGRAM

			#pragma target 3.0

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "My Lighting.cginc"
			
			ENDCG
		}
	}
}