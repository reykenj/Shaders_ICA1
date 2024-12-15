using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class LightObjectManager : MonoBehaviour
{

    [SerializeField] LightObject[] lightObjects;
    [SerializeField] ShadowMapRenderer[] shadowMapRenderers;
    [SerializeField] Material[] materialRenderers;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < materialRenderers.Length; i++)
        {
            SendToShader(materialRenderers[i]);
        }
    }


    private void SendToShader(Material material)
    {

        int LightAmt = 0;
        Vector4[] lightPositions = new Vector4[lightObjects.Length];
        Vector4[] lightDirections = new Vector4[lightObjects.Length];
        Color[] lightColors = new Color[lightObjects.Length];
        float[] lightIntensities = new float[lightObjects.Length];
        Vector4[] attenuations = new Vector4[lightObjects.Length];
        float[] spotLightCutOffs = new float[lightObjects.Length];
        float[] spotLightInnerCutOffs = new float[lightObjects.Length];
        float[] lightTypes = new float[lightObjects.Length];


        float[] _shadowMapWidths = new float[lightObjects.Length];
        float[] _shadowMapHeights = new float[lightObjects.Length];
        Matrix4x4[] _lightViewProjs = new Matrix4x4[lightObjects.Length];
        float[] _shadowBiases = new float[lightObjects.Length];
        float[] _shadowMapFilterSizes = new float[lightObjects.Length];

        for (int i = 0; i < lightObjects.Length; i++)
        {
            if (lightObjects[i] == null)
            {
                break;
            }
            LightAmt++;
            Transform lightTransform = lightObjects[i].transform;

            lightPositions[i] = new Vector4(lightTransform.position.x, lightTransform.position.y, lightTransform.position.z, 1);
            lightDirections[i] = new Vector4(lightObjects[i].direction.x, lightObjects[i].direction.y, lightObjects[i].direction.z, 0);
            lightColors[i] = lightObjects[i].LightColor;
            lightIntensities[i] = lightObjects[i].intensity;
            attenuations[i] = new Vector4(lightObjects[i].attenuation.x, lightObjects[i].attenuation.y, lightObjects[i].attenuation.z, 0);
            spotLightCutOffs[i] = lightObjects[i].spotLightCutOff;
            spotLightInnerCutOffs[i] = lightObjects[i].spotLightInnerCutOff;
            lightTypes[i] = (float)lightObjects[i].type; 

            if (shadowMapRenderers[i].lightCamera == null || shadowMapRenderers[i].shadowMap == null)
                continue;


            _shadowMapWidths[i] = shadowMapRenderers[i].shadowMap.width;
            _shadowMapHeights[i] = shadowMapRenderers[i].shadowMap.height;
            _lightViewProjs[i] = shadowMapRenderers[i].lightCamera.projectionMatrix * shadowMapRenderers[i].lightCamera.worldToCameraMatrix;
            _shadowBiases[i] = shadowMapRenderers[i].shadowBias;
            _shadowMapFilterSizes[i] = shadowMapRenderers[i].shadowFilterSize;
            material.SetTexture($"_shadowMap{i}", shadowMapRenderers[i].shadowMap);
        }

        material.SetVectorArray("_lightPositions", lightPositions);
        material.SetVectorArray("_lightDirections", lightDirections);
        material.SetColorArray("_lightColors", lightColors);
        material.SetFloatArray("_lightIntensities", lightIntensities);
        material.SetVectorArray("_attenuations", attenuations);
        material.SetFloatArray("_spotLightCutOffs", spotLightCutOffs);
        material.SetFloatArray("_spotLightInnerCutOffs", spotLightInnerCutOffs);
        material.SetFloatArray("_lightTypes", lightTypes);

        material.SetFloatArray("_shadowMapWidths", _shadowMapWidths);
        material.SetFloatArray("_shadowMapHeights", _shadowMapHeights);
        material.SetMatrixArray("_lightViewProjs", _lightViewProjs);

        material.SetFloatArray("_shadowBiases", _shadowBiases);
        material.SetFloatArray("_shadowMapFilterSizes", _shadowMapFilterSizes);
        material.SetInt("_LIGHTAMT", LightAmt);
    }
}
