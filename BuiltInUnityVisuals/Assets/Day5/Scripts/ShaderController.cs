using UnityEngine;
using System.Collections;

public class ShaderController : MonoBehaviour
{
    void Start()
    {
        GetComponent<Renderer>().material.SetColor("_BaseColor", Color.red);       
    }
}
