//================================================================================================
//      SpriteLitShader(URP)    Var 1.0.0
//
//      Copyright (C) 2021 ayaha401
//      Twitter : @ayaha__401
//
//      This software is released under the MIT License.
//      see https://github.com/ayaha401/SpriteLitShader/blob/main/LICENSE
//================================================================================================
#ifndef SPRITELIT_SHADOW
#define SPRITELIT_SHADOW

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

float3 _LightDirection;

struct Attributes 
{
    float4 positionOS : POSITION;
    float3 normalOS : NORMAL;
    float2 uv : TEXCOORD0;
    float4 color : COLOR;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float2 uv : TEXCOORD0;
    float4 positionCS   : SV_POSITION;
    float4 color : COLOR;
};

sampler2D _MainTex;

CBUFFER_START(UnityPerMaterial)
    float4 _MainTex_ST;
    float4 _Color;
CBUFFER_END 

// Source from ShadowCasterPass.hlsl GetShadowPositionHClip()
float4 GetShadowPositionHClip(Attributes input)
{
    float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
    float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

    float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));
    #if UNITY_REVERSED_Z
        positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
    #else
        positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
    #endif
        
    return positionCS;
}

Varyings vert(Attributes v)
{
    Varyings o;
    UNITY_SETUP_INSTANCE_ID(v);

    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.color = v.color * _Color;
    o.positionCS = GetShadowPositionHClip(v);

    return o;
}

float4 frag(Varyings i) : SV_Target
{
    float alpha = tex2D(_MainTex, i.uv).a * i.color.a;
    clip(alpha - .0001);
    // SHADOW_CASTER_FRAGMENT(i)
    return 0;
}

#endif