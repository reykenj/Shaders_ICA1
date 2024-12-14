// Shader "Custom/FirstShader"
// {
// 	Properties{
// 		_mainTexture("Albedo", 2D) = "white" {}
// 		_tint("Tint", Color) = (1,1,1,1)
// 		_alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5

// 		_lightPosition("Light Position", Vector) = (0,0,0)
// 		_lightDirection("Light Direction", Vector) = (0,-1,0)
// 		_lightColor("Light Color", Color) = (1,1,1,1)
// 		_specularStrength("Specular Strength", Range(0,1)) = 0.5
// 		_smoothness("Smoothness", Range(0,1)) = 0.5
// 	}


// 	SubShader{
// 		Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
// 		Blend SrcAlpha OneMinusSrcAlpha
// 		Pass{
// 			HLSLPROGRAM
// 			#include "UnityCG.cginc"
// 			#pragma vertex MyVertexShader
// 			#pragma fragment MyFragmentShader
// 			float4 _tint;
// 			uniform sampler2D _mainTexture;
// 			uniform float4 _mainTexture_ST;
// 			uniform float _alphaCutoff;

// 			uniform float3 _lightPosition;
// 			uniform float3 _lightDirection;
// 			uniform float4 _lightColor;
// 			uniform float _specularStrength;
// 			uniform float _smoothness;

// 			struct vertexData{
// 				float2 uv : TEXCOORD0;
// 				float4 position : POSITION;
// 				float3 normal : NORMAL;
// 			};

// 			struct vertex2Fragment{
// 				float2 uv : TEXCOORD0;
// 				float4 position : SV_POSITION;
// 				float3 normal : NORMAL;
// 				float3 worldPosition: POSITION1;
// 			};

// 			vertex2Fragment MyVertexShader(vertexData vd){
// 				vertex2Fragment v2f;
// 				v2f.position = UnityObjectToClipPos(vd.position);
// 				v2f.worldPosition = mul(unity_ObjectToWorld, vd.position);
// 				v2f.uv = TRANSFORM_TEX(vd.uv, _mainTexture);
// 				v2f.normal = UnityObjectToWorldNormal(vd.normal);
// 				v2f.normal = normalize(v2f.normal);
// 				return v2f;
// 			}

// 			float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET{
// 				v2f.normal = normalize(v2f.normal);
// 				float4 albedo = tex2D(_mainTexture, v2f.uv) * _tint;
// 				float3 viewDirection = normalize(_WorldSpaceCameraPos - v2f.worldPosition);
// 				float3 reflectionDirection = reflect(-_lightDirection, v2f.normal);
// 				float3 halfVector = normalize(viewDirection + -_lightDirection);
// 				float specular = pow(float(saturate(dot(v2f.normal, halfVector))), _smoothness * 100);
// 				float3 specularColor = specular * _specularStrength * _lightColor.rgb;

// 				float3 diffuse = albedo.rgb * _lightColor.rgb * saturate(dot(v2f.normal, -_lightDirection));
// 				float3 finalColor = diffuse + specularColor;
// 				return float4(finalColor, albedo.a);
// 			}

// 			ENDHLSL
// 		}
// 	}
// }







Shader "Custom/FirstShader"
{
	Properties{
		_mainTexture("Albedo", 2D) = "white" {}
		_tint("Tint", Color) = (1,1,1,1)
		_alphaCutoff("Alpha Cutoff", Range(0,1)) = 0.5

		// _lightType("Light Type", Integer) = 1
		// _lightPosition("Light Position", Vector) = (0,0,0)
		// _lightDirection("Light Direction", Vector) = (0,-1,0)
		// _lightColor("Light Color", Color) = (1,1,1,1)
		// _lightIntensity("Light Intensity", float) = 1

		_specularStrength("Specular Strength", Range(0,1)) = 0.5
		_smoothness("Smoothness", Range(0,1)) = 0.5
		//_attenuation("Attenuation", Vector) = (1.0, 0.09, 0.032)
		//_spotLightCutOff("Spot Light CutOff", Range(0, 360)) = 70
		//_spotLightInnerCutOff("Spot Light Inner CutOff", Range(0, 360)) = 25.0

		//_shadowMapFilterSize("Shadow Map Filter Size", int) = 1
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

			// uniform int _lightType;
			// uniform float3 _lightPosition;
			// uniform float3 _lightDirection;
			// uniform float4 _lightColor;
			// uniform float _lightIntensity;
			uniform float _specularStrength;
			uniform float _smoothness;
			// uniform float3 _attenuation;
			// uniform float _spotLightCutOff;
			// uniform float _spotLightInnerCutOff;


			uniform float3 _lightPositions[10];
			uniform float3 _lightDirections[10];
			uniform float4 _lightColors[10];
			uniform float _lightIntensities[10];
			uniform float3 _attenuations[10];
			uniform float _spotLightCutOffs[10];
			uniform float _spotLightInnerCutOffs[10];
			uniform float _lightTypes[10];


			uniform sampler2D _shadowMap0;
			uniform sampler2D _shadowMap1;
			uniform sampler2D _shadowMap2;
			uniform sampler2D _shadowMap3;
			uniform sampler2D _shadowMap4;
			uniform sampler2D _shadowMap5;
			uniform sampler2D _shadowMap6;
			uniform sampler2D _shadowMap7;
			uniform sampler2D _shadowMap8;
			uniform sampler2D _shadowMap9;

			uniform float _shadowMapWidths[10];
			uniform float _shadowMapHeights[10];
			uniform float4x4 _lightViewProjs[10];
			uniform float _shadowBiases[10];
			uniform int _shadowMapFilterSizes[10];
			uniform int _LIGHTAMT;

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
				float4 shadowCoord[10]: POSITION2;
			};

			vertex2Fragment MyVertexShader(vertexData vd){
				vertex2Fragment v2f;
				v2f.position = UnityObjectToClipPos(vd.position);
				v2f.worldPosition = mul(unity_ObjectToWorld, vd.position);
				v2f.uv = TRANSFORM_TEX(vd.uv, _mainTexture);
				v2f.normal = UnityObjectToWorldNormal(vd.normal);
				v2f.normal = normalize(v2f.normal);

				//SHADOW COMMENTED OUT
				for (int i = 0; i < _LIGHTAMT; i++){
					v2f.shadowCoord[i] = mul(_lightViewProjs[i], float4(v2f.worldPosition, 1.0));
				}
				return v2f;
			}

			float ShadowCalculation(float4 fragPosLightSpace, const int index){
				//transform shadow coords
				float3 shadowCoord = fragPosLightSpace.xyz / fragPosLightSpace.w;
				//trasnform from clip to texture space
				shadowCoord = shadowCoord * 0.5 + 0.5;
				// reykenj changes
				float2 TexelSize = float2(1.0 / _shadowMapWidths[index], 1.0 / _shadowMapHeights[index]);
				float shadowsum = 0.0;
				//
				int halfFilterSize = _shadowMapFilterSizes[index] / 2;
				for (int y = -halfFilterSize; y < -halfFilterSize + halfFilterSize * 2; y++){
					for (int x = -halfFilterSize; x < -halfFilterSize + halfFilterSize * 2; x++){
						float2 offset = float2(x, y) * TexelSize;
						float shadowDepth;
						// sample shadow map
						if (index == 0){
							shadowDepth = 1.0 - tex2D(_shadowMap0, shadowCoord.xy + offset).r;
						}
						else if (index == 1){
							shadowDepth = 1.0 - tex2D(_shadowMap1, shadowCoord.xy + offset).r;
						}
						else if (index == 2){
							shadowDepth = 1.0 - tex2D(_shadowMap2, shadowCoord.xy + offset).r;
						}
						else if (index == 3){
							shadowDepth = 1.0 - tex2D(_shadowMap3, shadowCoord.xy + offset).r;
						}
						else if (index == 4){
							shadowDepth = 1.0 - tex2D(_shadowMap4, shadowCoord.xy + offset).r;
						}
						else if (index == 5){
							shadowDepth = 1.0 - tex2D(_shadowMap5, shadowCoord.xy + offset).r;
						}
						else if (index == 6){
							shadowDepth = 1.0 - tex2D(_shadowMap6, shadowCoord.xy + offset).r;
						}
						else if (index == 7){
							shadowDepth = 1.0 - tex2D(_shadowMap7, shadowCoord.xy + offset).r;
						}
						else if (index == 8){
							shadowDepth = 1.0 - tex2D(_shadowMap8, shadowCoord.xy + offset).r;
						}
						else if (index == 9){
							shadowDepth = 1.0 - tex2D(_shadowMap9, shadowCoord.xy + offset).r;
						}

						//float shadowFactor = 0.9;

						float shadowFactor = (shadowCoord.z - _shadowBiases[index] > shadowDepth) ? 1.0 : 0.0;
						// Flip the shadow factor for proper shadowing
						shadowFactor = saturate(1.0 - shadowFactor);
						shadowsum += shadowFactor;
					}
				}
				float finalShadowFactor = shadowsum / 9.0;
				return finalShadowFactor;
			}

			float4 MyFragmentShader(vertex2Fragment v2f) : SV_TARGET{
				float shadowFactor = 0;
				float3 finalColor = float3(0,0,0);
				v2f.normal = normalize(v2f.normal);
				float4 albedo = tex2D(_mainTexture, v2f.uv) * _tint;

				if (albedo.a < _alphaCutoff){
					discard;
				}
				for (int i = 0; i < _LIGHTAMT; i++){ //might need to add a _LIGHTAMT + 1 later idk
					// SHADOW COMMENTED OUT
					shadowFactor = ShadowCalculation(v2f.shadowCoord[i], i);
					float3 finalLightDirection;
					float attenuation = 1.0;

					if(_lightTypes[i] == 0){
						finalLightDirection = _lightDirections[i];
					}
					else{
						finalLightDirection = normalize(v2f.worldPosition - _lightPositions[i]);
						float distance = length(v2f.worldPosition - _lightPositions[i]);
						attenuation = 1.0 / (_attenuations[i].x + _attenuations[i].y * distance + _attenuations[i].z * distance * distance);
						if(_lightTypes[i] == 2){
							float theta = dot(finalLightDirection, _lightDirections[i]);
							float angle = cos(radians(_spotLightCutOffs[i]));
							if (theta > angle){
								float epsilon = cos(radians(_spotLightInnerCutOffs[i])) - angle;
								float intensity = clamp((theta-angle) / epsilon, 0.0, 1.0);
								attenuation *= intensity;
							}
							else{
								attenuation = 0.0;
							}
						}
					}

					float3 viewDirection = normalize(_WorldSpaceCameraPos - v2f.worldPosition);
					float3 reflectionDirection = reflect(-finalLightDirection, v2f.normal);
					float3 halfVector = normalize(viewDirection + -finalLightDirection);
					float specular = pow(float(saturate(dot(v2f.normal, halfVector))), _smoothness * 100);
					float3 specularColor = specular * _specularStrength * _lightColors[i].rgb;

					float3 diffuse = albedo.rgb * _lightColors[i].rgb * saturate(dot(v2f.normal, -finalLightDirection));
					finalColor += (diffuse + specularColor) * _lightIntensities[i] * attenuation * shadowFactor;; //* shadowFactor; //SHADOW COMMENTED OUT
				}
				return float4(finalColor, albedo.a);
			}

			ENDHLSL
		}
	}
}
