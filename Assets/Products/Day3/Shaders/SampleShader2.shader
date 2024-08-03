// Upgrade NOTE: replaced 'texRECT' with 'tex2D'

Shader "Custom/SamplePaint2"
{
    CGINCLUDE
// Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
#pragma exclude_renderers d3d11 gles

    #define PI 3.14159265359

    float flower(float2 p, float n, float radius, float angle, float waveAmp)
    {
      float theta = atan2(p.y, p.x);
      float d = length(p) - radius + sin(theta*n + angle) * waveAmp;
      float b = 0.01 / abs(d);
      return b;
    }

    float4 paint(float2 uv)
    {
      float2 p = uv*2. - 1.;

      float3 col = 0;
      col += flower(p, 6., .9, _Time.y*1.5, .1) * float3(.1, .01, 1.);
      col += flower(p, 3., .2, PI*.5-_Time.y*.3, .2) * float3(1., .5, 0.);
      col += flower(p, 4., .5, _Time.y*.3, .1) * float3(0., 1., 1.);

      // 薄い緑色の花
      col +=
        min( flower(p, 18., .7, -_Time.y*10., .01), 1.) * .1 *
        float3(.1, .6, .1);

      col += flower(p, 55., .05, _Time.y*100., .1) * float3(1., .1, .1);
      return float4(col, 1);
    }

    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // 構造体の定義
            struct appdata // vert関数の入力
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct fin // vert関数の出力からfrag関数の入力へ
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

            // float4 vert(float4 vertex : POSITION) : SV_POSITION から↓に変更
            fin vert(appdata v) // 構造体を使用した入出力
            {
                fin o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            float4 frag(fin IN) : SV_TARGET // 構造体finを使用した入力
            {
                return paint(IN.texcoord.xy);
            }
            
            ENDCG
        }
    }
}