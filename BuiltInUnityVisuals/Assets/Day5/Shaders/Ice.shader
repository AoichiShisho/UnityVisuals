Shader "Custom/Ice" {
    Properties {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Tags { "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0
        
        struct Input {
            // オブジェクトの法線ベクトル
            float3 worldNormal;
            // 視線ベクトル
            float3 viewDir;
        };

        fixed4 _BaseColor;
        // 輪郭部分では1, 中央部分では0になるような計算式を考える
        // 輪郭部分では視線ベクトルと法線ベクトルが垂直
        // 中央部分ではほぼ並行に近い角度で交わる
        void surf (Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = _BaseColor.rgb;
            float alpha = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
            o.Alpha = 0.8f + 0.3f * alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}