using UnityEditor;
using UnityEngine;

public class RenderTextureExporter : EditorWindow
{
    public RenderTexture renderTexture;
    public Material material;
    public int textureWidth = 512;
    public int textureHeight = 512;
    public string savePath = "Assets/Textures/GeneratedTexture.png";

    [MenuItem("Tools/Render Texture Exporter")]
    public static void ShowWindow()
    {
        RenderTextureExporter window = GetWindow<RenderTextureExporter>("Render Texture Exporter");
        window.minSize = new Vector2(200, 300);
    }

    void OnGUI()
    {
        GUILayout.Label("Render Texture Settings", EditorStyles.boldLabel);
        
        EditorGUILayout.Space();
        
        renderTexture = (RenderTexture)EditorGUILayout.ObjectField("Render Texture", renderTexture, typeof(RenderTexture), false);
        
        EditorGUILayout.Space();
        
        material = (Material)EditorGUILayout.ObjectField("Material", material, typeof(Material), false);

        EditorGUILayout.Space();

        textureWidth = EditorGUILayout.IntField("Texture Width", textureWidth);
        textureHeight = EditorGUILayout.IntField("Texture Height", textureHeight);
        
        EditorGUILayout.Space();
        
        GUILayout.BeginHorizontal();
        savePath = EditorGUILayout.TextField("Save Path", savePath);
        if (GUILayout.Button("Browse", GUILayout.Width(75)))
        {
            string path = EditorUtility.SaveFilePanel("Save Texture as PNG", "", "GeneratedTexture.png", "png");
            if (!string.IsNullOrEmpty(path))
            {
                savePath = path;
            }
        }
        GUILayout.EndHorizontal();

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Export Texture", GUILayout.Width(150), GUILayout.Height(40)))
        {
            ExportRenderTexture();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }

    void ExportRenderTexture()
    {
        if (renderTexture == null || material == null)
        {
            Debug.LogError("Render Texture and Material are required!");
            return;
        }

        RenderTexture tempRT = RenderTexture.GetTemporary(textureWidth, textureHeight, 24);
        Graphics.Blit(null, tempRT, material);

        Texture2D texture = new Texture2D(textureWidth, textureHeight, TextureFormat.ARGB32, false);
        RenderTexture.active = tempRT;
        // 現在アクティブなRenderTextureを読み込む
        texture.ReadPixels(new Rect(0, 0, textureWidth, textureHeight), 0, 0);
        texture.Apply();
        RenderTexture.active = null;
        
        RenderTexture.ReleaseTemporary(tempRT);

        byte[] bytes = texture.EncodeToPNG();
        System.IO.File.WriteAllBytes(savePath, bytes);
        Debug.Log("Texture saved to " + savePath);
        AssetDatabase.Refresh();
    }
}