using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class LightObject : MonoBehaviour
{
    [SerializeField] private Vector3 direction = -Vector3.up;
    [SerializeField] private Material material;
    [SerializeField] private Color LightColor;
    [SerializeField]
    [Range(0.0f, 1.0f)]
    private float smoothness = 1.0f;
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
    }
}
