Shader "Custom/Sample" {
    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        // Vertexシェーダから出力された値がInput構造体に格納される
        struct Input {
            // テクスチャのUV座標
            float2 uv_mainTex;
        };

        // オブジェクトの表面色であるSurfaceOutputStandardを出力する、これが出力用の構造体
        // SurfaceOutputStandardが持つAlbedo変数に対して色情報を指定している
        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Albedo: 基本色
            o.Albedo = fixed4(0, 0, 0, 1);
        }
        ENDCG
    }
    // FallBack：シェーダがサポートされていない場合に使用するシェーダを指定する
    // Diffuseシェーダ：Unityにデフォルトで用意されているシェーダ
    FallBack "Diffuse"
}