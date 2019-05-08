#include <a3_dylib_config_export.h>
#include <SDKDDKVer.h>
#include <windows.h>
#include <GL/glew.h>
#include "UnityDemoState.h"

#include "DebugCPP.h"

UnityDemoState pUnityDemoState;

void Rendering()
{
	glClearColor(pUnityDemoState.r, pUnityDemoState.g, pUnityDemoState.b, pUnityDemoState.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

typedef enum UnityGfxRenderer
{
	kUnityGfxRendererNull = 4,
	kUnityGfxRendererOpenGLCore = 17,
} UnityGfxRenderer;

typedef enum UnityGfxDeviceEventType
{
	kUnityGfxDeviceEventInitialize = 0,
	kUnityGfxDeviceEventShutdown = 1,
	kUnityGfxDeviceEventBeforeReset = 2,
	kUnityGfxDeviceEventAfterReset = 3,
} UnityGfxDeviceEventType;

struct UnityInterfaceGUID
{
	UnityInterfaceGUID(unsigned long long high, unsigned long long low) : m_GUIDHigh(high), m_GUIDLow(low) { }
	unsigned long long m_GUIDHigh;
	unsigned long long m_GUIDLow;
};

struct IUnityInterface {};
typedef void(__stdcall * IUnityGraphicsDeviceEventCallback)(UnityGfxDeviceEventType eventType);

struct IUnityInterfaces
{
	IUnityInterface* (__stdcall* GetInterface)(UnityInterfaceGUID guid);
	void(__stdcall* RegisterInterface)(UnityInterfaceGUID guid, IUnityInterface * ptr);
	template<typename INTERFACE>
	INTERFACE* Get()
	{
		return static_cast<INTERFACE*>(GetInterface(UnityInterfaceGUID(0x7CBA0A9CA4DDB544ULL, 0x8C5AD4926EB17B11ULL)));
	}
	void Register(IUnityInterface* ptr)
	{
		RegisterInterface(UnityInterfaceGUID(0x7CBA0A9CA4DDB544ULL, 0x8C5AD4926EB17B11ULL), ptr);
	}
};

struct IUnityGraphics : IUnityInterface
{
	void(__stdcall* RegisterDeviceEventCallback)(IUnityGraphicsDeviceEventCallback callback);
};

typedef void(__stdcall* UnityRenderingEvent)(int eventId);
void(__stdcall* UnregisterDeviceEventCallback)(IUnityGraphicsDeviceEventCallback callback);
static UnityGfxRenderer DeviceType = kUnityGfxRendererNull;

static void __stdcall OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType)
{
	if (eventType == kUnityGfxDeviceEventInitialize)
	{
		DeviceType = kUnityGfxRendererOpenGLCore;
	}
	if (eventType == kUnityGfxDeviceEventShutdown)
	{
		DeviceType = kUnityGfxRendererNull;
	}
}

static void __stdcall OnRenderEvent(int eventID)
{
	Rendering();
}


extern "C" void	__declspec(dllexport) __stdcall UnityPluginLoad(IUnityInterfaces* unityInterfaces)
{
	IUnityInterfaces* s_UnityInterfaces = unityInterfaces;
	IUnityGraphics* s_Graphics = s_UnityInterfaces->Get<IUnityGraphics>();
	s_Graphics->RegisterDeviceEventCallback(OnGraphicsDeviceEvent);
	OnGraphicsDeviceEvent(kUnityGfxDeviceEventInitialize);
}

extern "C" void __declspec(dllexport) __stdcall UnityPluginUnload()
{
	UnregisterDeviceEventCallback(OnGraphicsDeviceEvent);
}

extern "C" UnityRenderingEvent __declspec(dllexport) __stdcall Execute()
{
	return OnRenderEvent;
}

extern "C" void __declspec(dllexport) __stdcall SetBackgroundColor(float r, float g, float b, float a)
{
	pUnityDemoState.r = r;
	pUnityDemoState.g = g;
	pUnityDemoState.b = b;
	pUnityDemoState.a = a;
}

extern "C" void __declspec(dllexport) __stdcall TestDebugCalls()
{
	Debug::Log("Hellow Red", Color::Red);
	Debug::Log("Hellow Green", Color::Green);
	Debug::Log("Hellow Blue", Color::Blue);
	Debug::Log("Hellow Black", Color::Black);
	Debug::Log("Hellow White", Color::White);
	Debug::Log("Hellow Yellow", Color::Yellow);
	Debug::Log("Hellow Orange", Color::Orange);
	Debug::Log(true, Color::Black);
	Debug::Log(false, Color::Red);
}
