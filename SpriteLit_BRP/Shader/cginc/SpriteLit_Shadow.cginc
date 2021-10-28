//================================================================================================
//      SpriteLitShader(BRP)    Var 1.0.1
//
//      Copyright (C) 2021 ayaha401
//      Twitter : @ayaha__401
//
//      This software is released under the MIT License.
//      see https://github.com/ayaha401/SpriteLitShader/blob/main/LICENSE
//================================================================================================
#ifndef SPRITELIT_SHADOW
#define SPRITELIT_SHADOW

#include "UnityCG.cginc"

struct appdata 
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;

    #ifdef TRANSPARENT_MODE
        float4 color : COLOR;
    #endif
};

struct v2f
{
    V2F_SHADOW_CASTER;
    float2 uv : TEXCOORD0;

    #ifdef TRANSPARENT_MODE
        float4 color : COLOR;
    #endif
    
};

sampler2D _MainTex;
float4 _MainTex_ST;

#ifdef TRANSPARENT_MODE
    float4 _Color;
#endif


v2f vert(appdata v)
{
    v2f o;
    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    #ifdef TRANSPARENT_MODE
        o.color = v.color * _Color;
    #endif
    
    return o;
}

float4 frag(v2f i) : SV_Target
{
    #ifdef TRANSPARENT_MODE
        float alpha = tex2D(_MainTex, i.uv).a * i.color.a;
        clip(alpha - .0001);
    #endif
    
    SHADOW_CASTER_FRAGMENT(i)
}

#endif