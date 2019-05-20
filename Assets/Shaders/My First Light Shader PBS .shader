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

		//	#include "UnityCG.cginc"
		//	#include "UnityStandardBRDF.cginc" // 已经包含了 unitycg.cginc
		//	#include "UnityStandardUtils.cginc"

			/* Physically-Based Shading */
			/* BRDF stands for bidirectional reflectance distribution function.*/
			#include "UnityPBSLighting.cginc"

			float4 _Tint;
			float _Smoothness;
			// float4 _SpecularTint;
 			float _Metallic;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct VertexData {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			Interpolators MyVertexProgram (VertexData v) {
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.worldPos = mul(unity_ObjectToWorld, v.position);
				//i.normal = mul(
				//	transpose((float3x3)unity_WorldToObject),
				//	v.normal
				//);
				//等同于上方，但是有更好的编译后效率
				i.normal = UnityObjectToWorldNormal(v.normal);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
				i.normal = normalize(i.normal);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

				float3 lightColor = _LightColor0.rgb;

				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
			//	albedo *= 1 - _SpecularTint.rgb;
				//monochrome energy conservation
				//albedo *= 1 -
				//	max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b));

			
				float3 specularTint ; //= albedo * _Metallic;
				float oneMinusReflectivity ; //= 1 - _Metallic;
				
				albedo = DiffuseAndSpecularFromMetallic(
					albedo, _Metallic, specularTint, oneMinusReflectivity
				);

				UnityLight light;
				light.color = lightColor;
				light.dir = lightDir;
				light.ndotl = DotClamped(i.normal, lightDir);

				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;


				return UNITY_BRDF_PBS(albedo,specularTint,
				oneMinusReflectivity , _Smoothness,
				i.normal, viewDir,
				light, indirectLight);
			}

			ENDCG
		}
	}
}