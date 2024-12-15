Shader "Custom/SecondShader"
{
	Properties{
		_mainTexture("Texture", 2D) = "white" {}
		_maskTexture("Mask Texture", 2D) = "white" {}
		_tint("Tint", Color) = (1,1,1,1)
		_alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5
		_revealValue("Reveal", Range(0,1)) = 0
		_featherValue("Feather", Range(0,1)) = 0


		_erodeColor("Erode Color", Color) = (1,1,1,1)
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
			float4 _erodeColor;
			uniform sampler2D _mainTexture;
			uniform float4 _mainTexture_ST;

			uniform sampler2D _maskTexture;
			uniform float4 _maskTexture_ST;

			uniform float _alphaCutoff;
			uniform float _revealValue;
			uniform float _featherValue;

			struct vertexData{
				float4 uv : TEXCOORD0;
				float4 position : POSITION;
			};

			struct vertex2Fragment{
				float4 uv : TEXCOORD0;
				float4 position : SV_POSITION;
			};

			vertex2Fragment MyVertexShader(vertexData vd){
				vertex2Fragment v2f;
				v2f.position = UnityObjectToClipPos(vd.position);
				v2f.uv.xy = TRANSFORM_TEX(vd.uv, _mainTexture);
				v2f.uv.zw = TRANSFORM_TEX(vd.uv, _maskTexture);
				return v2f;
			}

			float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET{
				float4 result = _tint * tex2D(_mainTexture,v2f.uv.xy);
				float4 maskResult = _tint * tex2D(_maskTexture,v2f.uv.zw);
				float RevealNum = _revealValue - _featherValue;
				//float revealAmount = smoothstep(maskResult.r - _featherValue, maskResult.r + _featherValue, _revealValue - _featherValue);
				float revealAmountTop = step(maskResult.r, RevealNum + _featherValue);
				float revealAmountBottom = step(maskResult.r, RevealNum - _featherValue);
				float revealDifference = revealAmountTop - revealAmountBottom;

				float3 finalColor = lerp(result.rgb, _erodeColor, revealDifference);
				return float4(finalColor.rgb, result.a * revealAmountTop);
			}

			ENDHLSL
		}
	}
}