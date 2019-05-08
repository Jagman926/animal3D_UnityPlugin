using AOT;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using UnityEngine.Experimental.Rendering;

public class TestScripts : MonoBehaviour
{
    // --- Unity Forum on writting texture to framebuffer using OpenGL ---
    // https://forum.unity.com/threads/how-to-render-to-texture-using-opengl.360499/
    // --- Unity Native Plugin Interface documentation ---
    // https://docs.unity3d.com/Manual/NativePluginInterface.html
    // --- Unity IssuePluginEvent documentation ---
    // https://docs.unity3d.com/ScriptReference/GL.IssuePluginEvent.html
    // --- Use Unity Debug.Log from C++ ---
    // https://stackoverflow.com/questions/43732825/use-debug-log-from-c

    [SerializeField]
    [Range(0, 1)]
    float red = 0f;

    [SerializeField]
    [Range(0, 1)]
    float green = 0f;

    [SerializeField]
    [Range(0, 1)]
    float blue = 0f;

    [SerializeField]
    [Range(0, 1)]
    float alpha = 1f;

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate void DebugDelegate(string str);

    static void CallBackFunction(string str) { Debug.Log(str); }

    // Other platforms load plugins dynamically, so pass the name
    // of the plugin's dynamic library.
    [DllImport("animal3D-DemoProject_x64")]
    static extern void RegisterDebugCallback(debugCallback cb);
    // Create string param callback delegate
    delegate void debugCallback(IntPtr request, int color, int size);
    enum Color { red, green, blue, black, white, yellow, orange };
    [MonoPInvokeCallback(typeof(debugCallback))]
    static void OnDebugCallback(IntPtr request, int color, int size)
    {
        //Ptr to string
        string debug_string = Marshal.PtrToStringAnsi(request, size);

        //Add Specified Color
        debug_string =
            String.Format("{0}{1}{2}{3}{4}",
            "<color=",
            ((Color)color).ToString(),
            ">",
            debug_string,
            "</color>"
            );

        Debug.Log(debug_string);
    }

    [DllImport("animal3D-DemoProject_x64")]
    private static extern IntPtr Execute();

    [DllImport("animal3D-DemoProject_x64")]
    private static extern void SetBackgroundColor(float r, float g, float b, float a);

    void OnEnable()
    {
        // Unity Debug.Log hookup
        // TO-DO: On second play Unity is hung-up on something and will not advanced through initialize.
        // When the register is uncommented, it does not have the issue even when the debug functions are called
        // with null reference
        //RegisterDebugCallback(OnDebugCallback);
    }

    private void Awake()
    {
        // Set Color
        red = 0f;
        green = 0f;
        blue = 0f;
        alpha = 1f;
        SetBackgroundColor(red, green, blue, alpha);
    }

    void OnPostRender()
    {
        SetBackgroundColor(red, green, blue, alpha);
        GL.IssuePluginEvent(Execute(), 1);

        // OpenGL call that will turn camera red after rendering has happened
        // needs to be called every frame since camera renders every frame (does not work in Update)
        // GL.Clear(false, true, Color.red);
    }
}
