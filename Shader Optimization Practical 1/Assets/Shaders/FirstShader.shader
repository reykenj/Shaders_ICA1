Shader "Custom/FirstShader"
{
	Properties{
		_mainTexture("Texture", 2D) = "white" {}
		_tint("Tint", Color) = (1,1,1,1)
		_alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5
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

			struct vertexData{
				float2 uv : TEXCOORD0;
				float4 position : POSITION;
			};

			struct vertex2Fragment{
				float2 uv : TEXCOORD0;
				float4 position : SV_POSITION;
			};


			// vertex2Fragment MyVertexShader(float4 position : POSITION, float2 uv : TEXCOORD0){
			// 	// float4 result = mul(UNITY_MATRIX_MVP, position);
			// 	// float4 result = UnityObjectToClipPos(position);
			// 	// return result;
			// 	vertex2Fragment fv;
			// 	fv.position = UnityObjectToClipPos(position);
			// 	fv.uv = uv;
			// 	return fv;
			// }
			vertex2Fragment MyVertexShader(vertexData vd){
				// float4 result = mul(UNITY_MATRIX_MVP, position);
				// float4 result = UnityObjectToClipPos(position);
				// return result;
				vertex2Fragment v2f;
				v2f.position = UnityObjectToClipPos(vd.position);
				v2f.uv = TRANSFORM_TEX(vd.uv, _mainTexture);
				return v2f;
			}

			float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET{
				//return float4(fv.uv, 0, 1.0f);
				float4 result = _tint * tex2D(_mainTexture,v2f.uv);
				clip(result.a -  _alphaCutoff);
				return result;
			}

			ENDHLSL
		}
	}
}
