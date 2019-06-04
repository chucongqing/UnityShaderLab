// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ML Bump PBS " {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Texture", 2D) = "white" {}
		
		[NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
		_BumpScale ("Bump Scale", Range(0.01,2)) = 1

		//One detail is that the metallic slider itself is supposed to be in gamma space. 
		//But single values are not automatically gamma corrected by Unity,
		// when rendering in linear space. 
		//We can use the Gamma attribute to tell Unity that it should also
		// apply gamma correction to our metallic slider.
		[Gamma]_Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
	}

	CGINCLUDE

	#define BINORMAL_PER_FRAGMENT

	ENDCG
	
	SubShader {

		Pass {

			Tags {
				"LightMode" = "ForwardBase"
			}


			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile _ VERTEXLIGHT_ON
			
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define FORWARD_BASE_PASS
			#include "My Lighting Bump.cginc"
			
			ENDCG
		}

		Pass {

			Tags {
				"LightMode" = "ForwardAdd"
			}

			Blend One One
			//Because writing to the depth buffer twice is not necessary, 
			//let's disable it. This is done with the ZWrite Off shader statement.
			ZWrite Off
			CGPROGRAM

			#pragma target 3.0
			
			#pragma multi_compile _ VERTEXLIGHT_ON
			// #pragma multi_compile_fwdadd
			// #pragma multi_compile DIRECTIONAL DIRECTIONAL_COOKIE  POINT SPOT

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram


			#include "My Lighting.cginc"
			
			ENDCG
		}
	}
}