#if UNITY_EDITOR 

using UnityEditor;
using UnityEngine;

public class SandWindow : EditorWindow
{
    [MenuItem ("Tool/Sand Shader/Pipeline Window")]
    static void Init()
    {
        EditorWindow.GetWindow(typeof(SandWindow));
    }

    void OnGUI()
    {
        Rect menuRect = new Rect(0, 0, 200, 180);
        BeginWindows();
        menuRect = GUILayout.Window(1, menuRect, MenuWindow, "Menu Window");
        EndWindows();
        
    }


    void MenuWindow(int unusedWindowID)
    {
        GUILayout.Button("Name");
    }
}

#endif