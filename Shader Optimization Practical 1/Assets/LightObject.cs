using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class LightObject : MonoBehaviour
{
    public enum Type
    {
        DIRECTIONAL = 0,
        POINT = 1,
        SPOT = 2,
    }
    [SerializeField] private Type type;
    [SerializeField] private Vector3 direction = -Vector3.up;
    [SerializeField] private Material material;
    [SerializeField] private Color LightColor;
    [SerializeField]
    [Range(0.0f, 1.0f)]
    private float smoothness = 1.0f;
    [SerializeField]
    private Vector3 attenuation = new Vector3(1.0f, 0.09f, 0.032f);
    [SerializeField]
    [Range(0.0f, 360.0f)]
    private float spotLightCutOff = 20.0f;



    [SerializeField]
    [Range(0.0f, 1.0f)]
    private float intensity = 1.0f;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        direction = transform.rotation * new Vector3(0, -1, 0);
        direction = direction.normalized;
        SendToShader();
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, 1);
        Gizmos.DrawRay(transform.position, direction * 10.0f);
    }

    private void SendToShader()
    {
        material.SetVector("_lightPosition", transform.position);
        material.SetVector("_lightDirection", direction);
        material.SetColor("_lightColor", LightColor);
        material.SetFloat("_smoothness", smoothness);
        material.SetInteger("_lightType", (int)type);
        material.SetFloat("_lightIntensity", intensity);
        material.SetVector("_attenuation", attenuation);
        material.SetFloat("_spotLightCutOff", spotLightCutOff);
    }

    public Material GetMaterial()
    {
        return material;
    }

    public Vector3 GetDirection()
    {
        return direction;
    }
}
