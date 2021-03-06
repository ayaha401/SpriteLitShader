using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class SpriteLitShaderGUI : ShaderGUI
{
    MaterialProperty MainTex;
    MaterialProperty Width;
    MaterialProperty WidthXMul;
    MaterialProperty WidthYMul;
    MaterialProperty Mode;
    MaterialProperty Color;
    MaterialProperty OutLineColor;


    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] Prop)
    {
        var material = (Material)materialEditor.target;

        MainTex = FindProperty("_MainTex", Prop, false);
        Width = FindProperty("_Width", Prop, false);
        WidthXMul = FindProperty("_WidthXMul", Prop, false);
        WidthYMul = FindProperty("_WidthYMul", Prop, false);
        Mode = FindProperty("_Mode", Prop, false);
        Color = FindProperty("_Color", Prop, false);
        OutLineColor = FindProperty("_OutLineColor", Prop, false);


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

        // ================================================================================================
        GUILayout.Box("", GUILayout.Height(2), GUILayout.ExpandWidth(true));
        // ================================================================================================

        GUILayout.Label("OutLine", EditorStyles.boldLabel);
        using (new EditorGUILayout.VerticalScope("box"))
        {
            materialEditor.ShaderProperty(Width, new GUIContent("Width"));
            materialEditor.ShaderProperty(WidthXMul, new GUIContent("Width X Mul"));
            materialEditor.ShaderProperty(WidthYMul, new GUIContent("Width Y Mul"));
            
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(Mode, new GUIContent("Mode"));
            materialEditor.ShaderProperty(OutLineColor, new GUIContent("OutLineColor"));
        }
        // base.OnGUI (materialEditor, Prop);
    }
}
