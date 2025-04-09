Shader "Custom/Transparent" {
    SubShader {
        // 基本的にはカメラから見て遠くにあるオブジェクトから順番に描画されるが、
        // 半透明のものを描画する際は、不透明オブジェクトの後に描画しないと描画結果が破綻してしまう
        // そのため、Tagブロックの中のQueueにTransparentを指定することで描画の優先度を指定している
        // Queueでは、Background→Geometry→AlphaTest→Transparent→Overlayの順に描画される
        Tags { "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // alpha:fade
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = fixed4(0.6f, 0.7f, 0.4f, 1);
            o.Alpha = 0.6f;
        }
        ENDCG
    }
    FallBack "Diffuse"
}