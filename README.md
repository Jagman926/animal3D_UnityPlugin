# Animal3D Plugin for Unity

**Animal3D Created by: Dan Buckstein**
*Animal3D Edited with permission of author*

**Original Unity Plugin Extension Created by: Josh Grazda and RJ Bourdelais**
[Original Animal3D Unity Plugin](https://github.com/RJBStudent/Graphics2-Midterm "Original Animal3D Unity Plugin")
Branch: RJ_Branch_v3

## What is Animal3D?

animal3D is a render pipeline created by Dan Buckstein. It was created with the intent of students extending the current functionality. To allow more access to what animal3D can offer, we have decided to create a plugin for Unity to provide more power over the rendering pipeline in Unity.

### Team Members and Contributions

**Josh Grazda**

- Unity C# test script
- Dll gate C file

**RJ Bourdelais**

- Unity C# test script
- Clear background C functionality for Unity

## Set-up Animal3D DLL for Unity

1. Launch Animal3D LAUNCH_VS.bat
2. For each project in the solution explorer, right click and select properties. 
   Then in Configuartion Properties/General Set Platform Toolset to Visual Studio 2015 (v140)
3. When building make sure project is in Release x64
4. [Switch to OpenGLCore](https://docs.unity3d.com/560/Documentation/Manual/UsingDX11GL3Features.html "OpenGLCore") as current Graphics API
5. Create a folder called Plugins in the asset hierarchy, then inside that create another folder
   labeled x86_64
6. Inside of Animal3D's "bin/x64/v140/Release/(project name)" drag the dll into the x86_64 folder you 
   created in unity
7. In your script of choice in Unity, add "using System.Runtime.InteropServices;"
   at the top
8. At the top of the class add [DllImport("dllName")] and whatever function you are externing below it. the function should follow the guidelines static extern (return type) (FunctionName)(Parameters);
9. Repeat step 7 and 8 for each script with the necessary functions

- If step 7-9 are unclear, please refer to [Unity's Native Plug-ins Documentation]("https://docs.unity3d.com/Manual/NativePlugins.html") for assistance in setting up plugin support

## Current Functionality
- Clear screen color adjustable on camera Test Script