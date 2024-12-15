using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Shader2Manager : MonoBehaviour
{
    [SerializeField] Material material;
    [SerializeField] private float Addition;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Addition += Time.deltaTime;
        SendToShader(material);
    }

    private void SendToShader(Material material)
    {
        material.SetFloat("_revealValue", Mathf.Sin(Addition));
    }
}
