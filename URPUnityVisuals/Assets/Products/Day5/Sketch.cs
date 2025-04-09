using UnityEngine;

public class Sketch : MonoBehaviour
{
    [SerializeField] private Material mat;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // Set the material to use for the post-processing effect
        Graphics.Blit(src, dest, mat);
    }

}
