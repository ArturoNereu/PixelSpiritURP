using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderSwitcher : MonoBehaviour
{
    [SerializeField]
    Material m_CanvasObjectMaterial;

    // Start is called before the first frame update
    void Start()
    {
        m_CanvasObjectMaterial = GetComponent<Renderer>().material;

        //SwitchToShaderGraph("Shader Graphs/01_Justice");
    }

    void SwitchToShader(string shaderName)
    {

    }

    void SwitchToShaderGraph(string shadergraphName)
    {
        m_CanvasObjectMaterial.shader = Shader.Find(shadergraphName);
    }
}
