Shader "Custom/URPIceShader"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _MainTex ("Base Map", 2D) = "white" {}
        _Smoothness ("Smoothness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;  // オブジェクト空間での頂点の位置
                float2 uv : TEXCOORD0;         // UV座標（テクスチャ座標）
                float3 normalOS : NORMAL;      // オブジェクト空間での法線ベクトル
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // ホモジニアスクリップ空間での頂点位置
                float2 uv : TEXCOORD0;            // UV座標
                float3 normalWS : TEXCOORD1;      // ワールド空間での法線ベクトル
                float3 viewDirWS : TEXCOORD2;     // ワールド空間での視線ベクトル
            };

            sampler2D _MainTex;
            float4 _BaseColor;
            float _Smoothness;

            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                // 頂点のオブジェクト空間での位置をクリップ空間に変換
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
                
                OUT.uv = IN.uv;
                // 法線ベクトルをワールド空間に変換
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                // カメラから頂点への視線ベクトルを計算
                OUT.viewDirWS = normalize(GetCameraPositionWS() - TransformObjectToWorld(IN.positionOS));
                
                return OUT;
            }

            half4 frag (Varyings IN) : SV_Target
            {
                // テクスチャと基本色のサンプル
                half4 baseColor = tex2D(_MainTex, IN.uv) * _BaseColor;

                // 法線ベクトルと視線ベクトルの内積を計算
                float NdotV = dot(normalize(IN.normalWS), normalize(IN.viewDirWS));

                // 透明度を計算: 角度が垂直に近いほど透明度が高くなる
                float alpha = 0.05+ 1.0 * (1.0 - abs(NdotV));
                
                baseColor.a *= alpha;

                return baseColor;
            }
            ENDHLSL
        }
    }
    FallBack Off
}
