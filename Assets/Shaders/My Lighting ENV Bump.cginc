#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"

float4 _Tint;
float _Smoothness;
float _Metallic;

float _BumpScale;

sampler2D _NormalMap;

sampler2D _MainTex;
float4 _MainTex_ST;

struct VertexData {
    float4 position : POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv : TEXCOORD0;
};

struct Interpolators {
    float4 position : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    

    #if defined(BINORMAL_PER_FRAGMENT)
		float4 tangent : TEXCOORD2;
	#else
		float3 tangent : TEXCOORD2;
		float3 binormal : TEXCOORD3;
	#endif

    float3 worldPos : TEXCOORD4;

    #if defined(VERTEXLIGHT_ON)
		float3 vertexLightColor : TEXCOORD5;
	#endif
};


void ComputeVertexLightColor (inout Interpolators i) {
    #if defined(VERTEXLIGHT_ON)
 
    i.vertexLightColor = Shade4PointLights(
			unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[0].rgb, unity_LightColor[1].rgb,
			unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			unity_4LightAtten0, i.worldPos, i.normal
		);

	#endif
}

float3 CreateBinormal (float3 normal, float3 tangent, float binormalSign) {
	return cross(normal, tangent.xyz) *
		(binormalSign * unity_WorldTransformParams.w);
}

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

    #if defined(BINORMAL_PER_FRAGMENT)
		i.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
	#else
		i.tangent = UnityObjectToWorldDir(v.tangent.xyz);
		i.binormal = CreateBinormal(i.normal, i.tangent, v.tangent.w);
	#endif

    i.uv = TRANSFORM_TEX(v.uv, _MainTex);
    ComputeVertexLightColor(i);
    return i;
}

UnityLight CreateLight (Interpolators i) {
	UnityLight light;

    #if defined(POINT)  || defined(POINT_COOKIE) || defined(SPOT)
		light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
	#else
		light.dir = _WorldSpaceLightPos0.xyz;
	#endif

	//float3 lightVec = _WorldSpaceLightPos0.xyz - i.worldPos;
	UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
   
	light.color = _LightColor0.rgb * attenuation;;
	light.ndotl = DotClamped(i.normal, light.dir);
	return light;
}

UnityIndirect CreateIndirectLight (Interpolators i, float3 viewDir) {
	UnityIndirect indirectLight;
	indirectLight.diffuse = 0;
	indirectLight.specular = 0;

	#if defined(VERTEXLIGHT_ON)
		indirectLight.diffuse = i.vertexLightColor;
	#endif

    #if defined(FORWARD_BASE_PASS)
		indirectLight.diffuse += max(0, ShadeSH9(float4(i.normal, 1)));
        float3 reflectionDir = reflect(-viewDir, i.normal);


        // float roughness = 1 - _Smoothness;
        // roughness *= 1.7 - 0.7 * roughness;
        // float4 envSample = UNITY_SAMPLE_TEXCUBE_LOD(
		// 	unity_SpecCube0, reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS
		// );
        // indirectLight.specular = DecodeHDR(envSample, unity_SpecCube0_HDR);

        Unity_GlossyEnvironmentData envData;
		envData.roughness = 1 - _Smoothness;
		envData.reflUVW = reflectionDir;
		indirectLight.specular = Unity_GlossyEnvironment(
			UNITY_PASS_TEXCUBE(unity_SpecCube0), unity_SpecCube0_HDR, envData
		);

	#endif
	return indirectLight;
}

void InitializeFragmentNormal(inout Interpolators i) {
    // i.normal.xy = tex2D(_NormalMap, i.uv).wy * 2 - 1;
    // i.normal.xy *= _BumpScale;
    // i.normal.z = sqrt(1 - saturate(dot(i.normal.xy, i.normal.xy)));

    float3 tangentSpaceNormal = UnpackScaleNormal(tex2D(_NormalMap, i.uv), _BumpScale);
	
    #if defined(BINORMAL_PER_FRAGMENT)
		float3 binormal = CreateBinormal(i.normal, i.tangent.xyz, i.tangent.w);
	#else
		float3 binormal = i.binormal;
	#endif
    

    i.normal = normalize(
		tangentSpaceNormal.x * i.tangent +
		tangentSpaceNormal.y * binormal +
		tangentSpaceNormal.z * i.normal
    );
}

float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
    InitializeFragmentNormal(i);
 
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

    float3 specularTint ; 
    float oneMinusReflectivity ; 
    
    albedo = DiffuseAndSpecularFromMetallic(
        albedo, _Metallic, specularTint, oneMinusReflectivity
    );

    return UNITY_BRDF_PBS(albedo,specularTint,
    oneMinusReflectivity , _Smoothness,
    i.normal, viewDir,
    CreateLight(i), CreateIndirectLight(i, viewDir));
}

#endif