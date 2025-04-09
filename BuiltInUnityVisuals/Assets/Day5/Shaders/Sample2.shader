Shader "Custom/Sample2" {
    Properties {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input {
            float2 uv_mainTex;
        };
        fixed4 _BaseColor;
        void surf (Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = _BaseColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}