//================================================================================================
//      SpriteLitShader    Var 1.1.0
//
//      Copyright (C) 2021 ayaha401
//      Twitter : @ayaha__401
//
//      This software is released under the MIT License.
//      see https://github.com/ayaha401/SpriteLitShader/blob/main/LICENSE
//================================================================================================
Shader "SpriteLit/Transparent"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [PerRendererData]_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Width ("Width", Range(0.0, 0.01)) = 0.001
        _WidthXMul ("Width X Mul", float) = 1.0
        _WidthYMul ("Width Y Mul", float) = 1.0
        _OutLineColor ("OutLineColor", Color) = (1.0, 1.0, 1.0, 1.0)

        [KeywordEnum(Part, All)] _Mode ("Mode", Float) = 0

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
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _MODE_PART _MODE_ALL

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Width; 
            float _WidthXMul;
            float _WidthYMul;
            float4 _OutLineColor;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _Color;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 originalCol = tex2D(_MainTex, i.uv);

                // アウトライン作成
                float4 leftShift = tex2D(_MainTex, float2(i.uv.x + (_Width * _WidthXMul), i.uv.y));
                float4 rightShift = tex2D(_MainTex, float2(i.uv.x - (_Width * _WidthXMul), i.uv.y));
                float4 upShift = tex2D(_MainTex, float2(i.uv.x, i.uv.y + (_Width * _WidthYMul)));
                float4 downShift = tex2D(_MainTex, float2(i.uv.x, i.uv.y - (_Width * _WidthYMul)));

                float4 outLineCol = saturate((leftShift.a - originalCol.a) + (rightShift.a - originalCol.a) + 
                                            (upShift.a - originalCol.a) + (downShift.a - originalCol.a));
                outLineCol = outLineCol * _OutLineColor;






                originalCol.rgb *= _LightColor0.rgb;
                float4 col = originalCol + outLineCol;
                col *= i.color;

                #ifdef _MODE_PART
                    col.rgb = col * (1.0 - outLineCol.a) + outLineCol * outLineCol.a;
                    col.rgb *= col.a;
                #elif _MODE_ALL
                    col.rgb *= col.a;
                #endif

                return col;
            }
            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode"="ShadowCaster"
            }
            ZWrite On
            ZTest LEqual
            // Cull Off
            

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #define TRANSPARENT_MODE

            #include "../SpriteLit/cginc/SpriteLit_Shadow.cginc"
            
            ENDCG
        }
    }
    CustomEditor "SpriteLitShaderGUI"
}
