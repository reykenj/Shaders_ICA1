Shader "Custom/ThirdShader"
{
	Properties{
		_mainTexture("Texture", 2D) = "white" {}
		_tint("Tint", Color) = (1,1,1,1)
		_alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5

		_scale("Scale", float) = 1.0
		_timescale("Time Scale", float) = 1.0
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
			uniform float _alphaCutoff;

			uniform float _scale;
			uniform float _timescale;

			struct vertexData{
				float2 uv : TEXCOORD0;
				float4 position : POSITION;
			};

			struct vertex2Fragment{
				float2 uv : TEXCOORD0;
				float4 position : SV_POSITION;
			};


			float3 Plasma(float2 uv){
				uv = uv * _scale - _scale / 2;
				float time = _Time.y * _timescale;
				float w1 = sin(uv.x + time);
				float w2 = sin(uv.y + time) * 0.5;
				float w3 = sin(uv.x + uv.y + time);

				float r = sin(sqrt(uv.x * uv.x + uv.y * uv.y) + time);
				float finalWave = r;
				return float3(finalWave, 0, 0);
			}
			vertex2Fragment MyVertexShader(vertexData vd){
				vertex2Fragment v2f;
				v2f.position = UnityObjectToClipPos(vd.position);
				v2f.uv = TRANSFORM_TEX(vd.uv, _mainTexture);
				return v2f;
			}

			float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET{
				//return float4(fv.uv, 0, 1.0f);
				float4 result = _tint * tex2D(_mainTexture,v2f.uv);
				clip(result.a -  _alphaCutoff);

				float3 plasma = Plasma(v2f.uv);
				return float4(plasma.rgb, 1.0);
			}

			ENDHLSL
		}
	}
}