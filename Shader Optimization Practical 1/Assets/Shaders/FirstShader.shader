Shader "Custom/FirstShader"
{
	Properties{
		_mainTexture("Albedo", 2D) = "white" {}
		_tint("Tint", Color) = (1,1,1,1)
		_alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5

		_lightPosition("Light Position", Vector) = (0,0,0)
		_lightDirection("Light Direction", Vector) = (0,-1,0)
		_lightColor("Light Color", Color) = (1,1,1,1)
		_specularStrength("Specular Strength", Range(0,1)) = 0.5
		_smoothness("Smoothness", Range(0,1)) = 0.5
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

			uniform float3 _lightPosition;
			uniform float3 _lightDirection;
			uniform float4 _lightColor;
			uniform float _specularStrength;
			uniform float _smoothness;

			struct vertexData{
				float2 uv : TEXCOORD0;
				float4 position : POSITION;
				float3 normal : NORMAL;
			};

			struct vertex2Fragment{
				float2 uv : TEXCOORD0;
				float4 position : SV_POSITION;
				float3 normal : NORMAL;
				float3 worldPosition: POSITION1;
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
				v2f.worldPosition = mul(unity_ObjectToWorld, vd.position);
				v2f.uv = TRANSFORM_TEX(vd.uv, _mainTexture);
				v2f.normal = UnityObjectToWorldNormal(vd.normal);
				v2f.normal = normalize(v2f.normal);
				return v2f;
			}

			float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET{
				// float4 result = _tint * tex2D(_mainTexture,v2f.uv);
				// clip(result.a -  _alphaCutoff);
				// return result;

				// float4 result = float4(v2f.normal, 1);
				// return result;
				v2f.normal = normalize(v2f.normal);
				float4 albedo = tex2D(_mainTexture, v2f.uv) * _tint;
				float3 viewDirection = normalize(_WorldSpaceCameraPos - v2f.worldPosition);
				float3 reflectionDirection = reflect(-_lightDirection, v2f.normal);
				float3 halfVector = normalize(viewDirection + -_lightDirection);
				float specular = pow(float(saturate(dot(v2f.normal, halfVector))), _smoothness * 100);
				float3 specularColor = specular * _specularStrength * _lightColor.rgb;

				float3 diffuse = albedo.rgb * _lightColor.rgb * saturate(dot(v2f.normal, -_lightDirection));
				float3 finalColor = diffuse + specularColor;
				return float4(finalColor, albedo.a);
				//float specular = pow(float(saturate(dot(-viewDirection, reflectionDirection))), _smoothness * 100);

				//float3 diffuse = albedo.xyz * _lightColor * saturate(dot(-_lightDirection, v2f.normal));
				//float4 result = float4(diffuse, albedo.w);
				//return float4(result, result, result, 1.0);
			}

			ENDHLSL
		}
	}
}
