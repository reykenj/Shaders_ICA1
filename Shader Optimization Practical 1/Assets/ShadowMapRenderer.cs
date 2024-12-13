using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class ShadowMapRenderer : MonoBehaviour
{
    [SerializeField]
    private LightObject lightObject;
    [SerializeField]
    private int shadowMapResolution = 1024;
    [SerializeField]
    private float shadowBias = 0.005f;
    private Camera lightCamera;
    private RenderTexture shadowMap;
    // Start is called before the first frame update
    void Start()
    {
        lightObject = GetComponent<LightObject>();
        if (lightObject == null)
        {
            Debug.LogError("ShadowMapper requires light object lol");
            return;
        }
        CreateLightCamera();
    }

    // Update is called once per frame
    void Update()
    {
        if (lightCamera == null || shadowMap == null)
            return;
        UpdateLightCamera();
        SendShadowDataToShader();
    }

    private void CreateLightCamera()
    {
        shadowMap = new RenderTexture(shadowMapResolution,
                                      shadowMapResolution,
                                      24,
                                      RenderTextureFormat.Depth);
        shadowMap.Create();

        // Create shadow camera
        GameObject lightCamObj = new GameObject("Light Camera");
        lightCamera = lightCamObj.AddComponent<Camera>();
        lightCamera.enabled = false;
        lightCamera.clearFlags = CameraClearFlags.Depth;
        lightCamera.backgroundColor = Color.white;
        lightCamera.targetTexture = shadowMap;

        //Configure Camera Type
        lightCamera.nearClipPlane = 0.1f;
        lightCamera.farClipPlane = 100.0f;
        lightCamera.orthographic = true;
        lightCamera.orthographicSize = 30;

        lightCamObj.transform.SetParent(lightObject.transform, false);
    }

    private void UpdateLightCamera()
    {
        //sync shadow camera with light transform
        lightCamera.transform.position = lightObject.transform.position;
        lightCamera.transform.forward = lightObject.GetDirection();
        
        // Render shadow map manually
        lightCamera.Render();
    }

    private void SendShadowDataToShader()
    {
        Material material = lightObject.GetMaterial();
        if(material == null) return;

        Matrix4x4 lightViewProjMatrix = lightCamera.projectionMatrix * lightCamera.worldToCameraMatrix;

        material.SetTexture("_shadowMap", shadowMap);
        material.SetFloat("_shadowBias", shadowBias);
        material.SetMatrix("_lightViewProj", lightViewProjMatrix);
    }

    private void OnDestroy()
    {
        if (shadowMap != null)
        {
            shadowMap.Release();
        }
        if (lightCamera != null)
        {
            Destroy(lightCamera.gameObject);
        }
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(),
            shadowMap,
            ScaleMode.ScaleToFit,
            false);
    }
}
