// Upgrade NOTE: replaced 'texRECT' with 'tex2D'

Shader "Custom/SamplePaint"
{
    CGINCLUDE
// Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
#pragma exclude_renderers d3d11 gles
    float4 paint(float2 uv)
    {
        float2 p = uv*2 - 1;
        float d = length(p) - 0.5;
        float b = 0.01 / abs(d);
        return b;
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