using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class SpriteLitOpaqueShaderGUI : ShaderGUI
{
    MaterialProperty MainTex;
    MaterialProperty Color;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] Prop)
    {
        var material = (Material)materialEditor.target;

        MainTex = FindProperty("_MainTex", Prop, false);
        Color = FindProperty("_Color", Prop, false);

        GUILayout.Label("Information", EditorStyles.boldLabel);
        using (new EditorGUILayout.VerticalScope("box"))
        {
            using (new EditorGUILayout.HorizontalScope())
            {
                GUILayout.Label("Version");
                GUILayout.FlexibleSpace();
                GUILayout.Label("Version 1.1.0");
            }

            using (new EditorGUILayout.HorizontalScope())
            {
                GUILayout.Label("How to use (Japanese)");
                GUILayout.FlexibleSpace();
                if(GUILayout.Button("How to use (Japanese)"))
                {
                    System.Diagnostics.Process.Start("https://github.com/ayaha401/SpriteLitShader/wiki");
                }
            }
        }

        // ================================================================================================
        GUILayout.Box("", GUILayout.Height(2), GUILayout.ExpandWidth(true));
        // ================================================================================================

        GUILayout.Label("Main", EditorStyles.boldLabel);
        using (new EditorGUILayout.VerticalScope("box"))
        {
            materialEditor.ShaderProperty(MainTex, new GUIContent("MainTex"));
            materialEditor.ShaderProperty(Color, new GUIContent("Color"));
        }
    }
}
