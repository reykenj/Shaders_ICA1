Shader "Custom/WaveShader"
{
    Properties{
        _mainTexture("Texture", 2D) = "white" {}
        _noiseTexture("Texture", 2D) = "white" {}
        _tint("Tint", Color) = (1,1,1,1)
        _alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5

        _scale("Noise Scale", Range(0.01,0.1)) = 0.03
        _amplitude("Amplitude", Range(0.01,0.1)) = 0.015
        _speed("Speed", Range(0.01, 1)) = 0.15

        _waveFrequency("Wave Frequency", Range(0.1, 5.0)) = 2.0
        _waveAmplitude("Wave Amplitude", Range(0.01, 0.5)) = 0.1
    }

    SubShader{
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        Pass{
            HLSLPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex MyVertexShader
            #pragma fragment MyFragmentShader

            float4 _tint;
            uniform sampler2D _mainTexture;
            uniform float4 _mainTexture_ST;

            uniform sampler2D _noiseTexture;
            uniform float4 _noiseTexture_ST;

            uniform float _alphaCutoff;
            uniform float _scale;
            uniform float _amplitude;
            uniform float _speed;

            uniform float _waveFrequency;
            uniform float _waveAmplitude;

            struct vertexData {
                float2 uv : TEXCOORD0;
                float4 position : POSITION;
            };

            struct vertex2Fragment {
                float2 uv : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            vertex2Fragment MyVertexShader(vertexData vd) {
                vertex2Fragment v2f;


                float2 noiseUV = (vd.uv.xy + _Time.yx * _speed) * _scale;
                float noiseValue = tex2Dlod(_noiseTexture, float4(noiseUV, 0, 0)).x * _amplitude;


                float wave = sin(vd.position.x * _waveFrequency + _Time.y * _speed) * _waveAmplitude;


                float yOffset = noiseValue + wave;

                vd.position.y += yOffset; 


                v2f.position = UnityObjectToClipPos(vd.position);
                v2f.uv = TRANSFORM_TEX(vd.uv, _mainTexture);

                return v2f;
            }

            float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET {

                float4 result = _tint * tex2D(_mainTexture, v2f.uv);


                clip(result.a - _alphaCutoff);

                return result;
            }

            ENDHLSL
        }
    }
}
