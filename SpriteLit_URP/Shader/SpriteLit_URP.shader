//================================================================================================
//      SpriteLitShader(URP)    Var 1.0.0
//
//      Copyright (C) 2021 ayaha401
//      Twitter : @ayaha__401
//
//      This software is released under the MIT License.
//      see https://github.com/ayaha401/SpriteLitShader/blob/main/LICENSE
//================================================================================================
Shader "Lit/SpriteLit_URP"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [PerRendererData]_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        LOD 100
        Cull Off
        // Lighting Off
        // ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // #include "UnityCG.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _Color;
            CBUFFER_END

            Varyings vert (Attributes v)
            {
                Varyings o;
                o.vertex = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _Color;
                return o;
            }

            float4 frag (Varyings i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv) * i.color;
                clip(col.a - .01);
                col.rgb *= col.a;
                return col;
            }
            ENDHLSL
        }

        Pass
        {
            Tags
            {
                "LightMode"="ShadowCaster"
            }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "../SpriteLit/hlsl/SpriteLit_Shadow.hlsl"
            
            ENDHLSL
        }
    }
}