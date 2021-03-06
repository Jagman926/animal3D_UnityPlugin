/*
	Copyright 2011-2019 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	a3_demo_callbacks.c/.cpp
	Main implementation of window callback hooks.

	********************************************
	*** THIS IS THE LIBRARY'S CALLBACKS FILE ***
	*** App hooks your demo via this file.   ***
	********************************************
*/


#include "a3_dylib_config_export.h"
//#include "MyState.h"


#include "animal3D/a3/a3types_integer.h"

typedef struct MyState MyState;

struct MyState
{
	int dummy;
};



//[DllImport("animal3D-DemoProject")]
//static extern void nameoffunction(params);

#include <SDKDDKVer.h>
#include <gl/glew.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

#ifdef __c
extern "C"
{
#endif

	int	A3DYLIBSYMBOL TestOutput();
	a3ret A3DYLIBSYMBOL ColorScreen();

#ifdef __c
}
#endif

#ifdef __c
extern "C"
{
#endif

int TestOutput()
{
	return 26;
}

a3ret ColorScreen()
{
	glClearColor(1, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	return 3;
}

#ifdef __c
}
#endif


/*
//-----------------------------------------------------------------------------
// miscellaneous functions

// get the size of the persistent state to allocate
//	(good idea to keep it relatively constant, so that addresses don't change 
//	when the library is reloaded... that would mess everything up!)
inline a3ui32 a3demo_getPersistentStateSize()
{
	const a3ui32 minimum = sizeof(MyState);
	a3ui32 size = 1;
	while (size < minimum)
		size += size;
	return size;
}


// consistent text initialization
inline void a3demo_initializeText(a3_TextRenderer *text)
{
	a3textInitialize(text, 18, 1, 0, 0, 0);
}


//-----------------------------------------------------------------------------
// callback sub-routines

inline void a3demoCB_keyCharPress_main(MyState *demoState, a3i32 asciiKey,
	const a3ui32 demoSubMode, const a3ui32 demoOutput,
	const a3ui32 demoSubModeCount, const a3ui32 demoOutputCount)
{
	switch (asciiKey)
	{
		// sub-modes
	case '>':
		if (!demoState->previewIntermediatePostProcessing &&
			demoSubMode > demoStateRenderPass_composite &&
			demoSubMode < demoStateRenderPass_bloom_blend)
			demoState->demoSubMode[demoState->demoMode] = demoStateRenderPass_bloom_blend;
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting &&
			demoSubMode > demoStateRenderPass_scene &&
			demoSubMode < demoStateRenderPass_composite)
			demoState->demoSubMode[demoState->demoMode] = demoStateRenderPass_composite;
		break;
	case '<':
		if (!demoState->previewIntermediatePostProcessing &&
			demoSubMode > demoStateRenderPass_composite &&
			demoSubMode < demoStateRenderPass_bloom_blend)
			demoState->demoSubMode[demoState->demoMode] = demoStateRenderPass_composite;
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting &&
			demoSubMode > demoStateRenderPass_scene &&
			demoSubMode < demoStateRenderPass_composite)
			demoState->demoSubMode[demoState->demoMode] = demoStateRenderPass_scene;
		break;

		// toggle active camera
//	case 'v':
//		demoState->activeCamera = (demoState->activeCamera + 1) % demoStateMaxCount_cameraObject;
//		break;
//	case 'c':
//		demoState->activeCamera = (demoState->activeCamera - 1 + demoStateMaxCount_cameraObject) % demoStateMaxCount_cameraObject;
//		break;

		// toggle skybox
	case 'b':
		demoState->displaySkybox = 1 - demoState->displaySkybox;
		break;

		// toggle hidden volumes
	case 'h':
		demoState->displayHiddenVolumes = 1 - demoState->displayHiddenVolumes;
		break;

		// additional post-processing
	case 'n':
		demoState->additionalPostProcessing = 1 - demoState->additionalPostProcessing;
		break;

		// preview post-processing passes
	case 'r':
		demoState->previewIntermediatePostProcessing = 1 - demoState->previewIntermediatePostProcessing;
		if (!demoState->previewIntermediatePostProcessing &&
			demoSubMode > demoStateRenderPass_composite &&
			demoSubMode < demoStateRenderPass_bloom_blend)
			demoState->demoSubMode[demoState->demoMode] = demoStateRenderPass_bloom_blend;
		break;

		// toggle pipeline overlay
	case 'o':
		demoState->displayPipeline = 1 - demoState->displayPipeline;
		break;

		// toggle stencil test
	case 'i':
		demoState->stencilTest = 1 - demoState->stencilTest;
		break;

		// toggle single light only or decrease light count
	case 'l':
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting)
		{
			demoState->singleForwardLight = 1 - demoState->singleForwardLight;
			demoState->forwardLightCount = demoState->singleForwardLight ? 1 : demoStateMaxCount_lightObject;
		}
		else if (demoState->deferredLightCount > 0)
			demoState->deferredLightCount -= 4;
		break;

		// increase light count
	case 'L':
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting)
		{
		}
		else if (demoState->deferredLightCount < demoStateMaxCount_lightVolume)
			demoState->deferredLightCount += 4;
		break;

		// pipeline mode
	case 'p':
		demoState->lightingPipelineMode = (demoState->lightingPipelineMode + 1) % 3;
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting &&
			demoSubMode > demoStateRenderPass_scene &&
			demoSubMode < demoStateRenderPass_composite)
			demoState->demoSubMode[demoState->demoMode] = demoStateRenderPass_composite;
		break;

		// toggle forward shading mode
	case 'j':
		demoState->forwardShadingMode = (demoState->forwardShadingMode + demoState->forwardShadingModeCount - 1) % demoState->forwardShadingModeCount;
		break;
	case 'k':
		demoState->forwardShadingMode = (demoState->forwardShadingMode + 1) % demoState->forwardShadingModeCount;
		break;

		// toggle tangent bases on vertices
	case 'B':
		demoState->displayTangentBases = 1 - demoState->displayTangentBases;
		break;
	}
}

inline void a3demoCB_keyCharHold_main(MyState *demoState, a3i32 asciiKey)
{
	// handle special cases immediately
	switch (asciiKey)
	{
		// decrease light count
	case 'l':
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting)
		{
		}
		else if (demoState->deferredLightCount > 0)
			demoState->deferredLightCount -= 4;
		break;

		// increase light count
	case 'L':
		if (demoState->lightingPipelineMode != demoStatePipelineMode_deferredLighting)
		{
		}
		else if (demoState->deferredLightCount < demoStateMaxCount_lightVolume)
			demoState->deferredLightCount += 4;
		break;
	}
}


//-----------------------------------------------------------------------------
// callback prototypes
// NOTE: do not move to header; they should be private to this file
// NOTE: you may name these functions whatever you like, just be sure to 
//	update your debug config file: 
//	"<root>/resource/animal3D-data/animal3D-demoinfo-debug.txt"
// copy this config line and the DLL to your main config with a new name when 
//	you're happy with it: 
//	"<root>/resource/animal3D-data/animal3D-demoinfo.txt"


#ifdef __cplusplus
extern "C"
{
#endif	// __cplusplus

	A3DYLIBSYMBOL MyState *a3demoCB_load(MyState *demoState, a3boolean hotbuild);
	A3DYLIBSYMBOL MyState *a3demoCB_unload(MyState *demoState, a3boolean hotbuild);
//	A3DYLIBSYMBOL a3i32 a3demoCB_display(MyState *demoState);
	A3DYLIBSYMBOL a3i32 a3demoCB_idle(MyState *demoState);
//	A3DYLIBSYMBOL void a3demoCB_windowActivate(MyState *demoState);
//	A3DYLIBSYMBOL void a3demoCB_windowDeactivate(MyState *demoState);
//	A3DYLIBSYMBOL void a3demoCB_windowMove(MyState *demoState, a3i32 newWindowPosX, a3i32 newWindowPosY);
//	A3DYLIBSYMBOL void a3demoCB_windowResize(MyState *demoState, a3i32 newWindowWidth, a3i32 newWindowHeight);
	A3DYLIBSYMBOL void a3demoCB_keyPress(MyState *demoState, a3i32 virtualKey);
	A3DYLIBSYMBOL void a3demoCB_keyHold(MyState *demoState, a3i32 virtualKey);
	A3DYLIBSYMBOL void a3demoCB_keyRelease(MyState *demoState, a3i32 virtualKey);
	A3DYLIBSYMBOL void a3demoCB_keyCharPress(MyState *demoState, a3i32 asciiKey);
	A3DYLIBSYMBOL void a3demoCB_keyCharHold(MyState *demoState, a3i32 asciiKey);
	A3DYLIBSYMBOL void a3demoCB_mouseClick(MyState *demoState, a3i32 button, a3i32 cursorX, a3i32 cursorY);
//	A3DYLIBSYMBOL void a3demoCB_mouseDoubleClick(MyState *demoState, a3i32 button, a3i32 cursorX, a3i32 cursorY);
	A3DYLIBSYMBOL void a3demoCB_mouseRelease(MyState *demoState, a3i32 button, a3i32 cursorX, a3i32 cursorY);
//	A3DYLIBSYMBOL void a3demoCB_mouseWheel(MyState *demoState, a3i32 delta, a3i32 cursorX, a3i32 cursorY);
//	A3DYLIBSYMBOL void a3demoCB_mouseMove(MyState *demoState, a3i32 cursorX, a3i32 cursorY);
//	A3DYLIBSYMBOL void a3demoCB_mouseLeave(MyState *demoState);

#ifdef __cplusplus
}
#endif	// __cplusplus


//-----------------------------------------------------------------------------
// callback implementations

// demo is loaded
A3DYLIBSYMBOL MyState *a3demoCB_load(MyState *demoState, a3boolean hotbuild)
{
/*
	const a3ui32 stateSize = a3demo_getPersistentStateSize();
	
	// do any re-allocation tasks
	if (demoState && hotbuild)
	{
		const a3ui32 stateSize = a3demo_getPersistentStateSize();
		MyState copy = *demoState;

		// example 1: copy memory directly
		free(demoState);
		demoState = (MyState *)malloc(stateSize);
		memset(demoState, 0, stateSize);
		*demoState = copy;

		a3demo_refresh(demoState);
		a3trigInitSetTables(4, demoState->trigTable);
	}

	// do any initial allocation tasks
	else
	{
		// HEAP allocate persistent state
		// stack object will be deleted at the end of the function
		// good idea to set the whole block of memory to zero
		demoState = (MyState *)malloc(stateSize);
		memset(demoState, 0, stateSize);

		// set up trig table (A3DM)
		a3trigInit(4, demoState->trigTable);

		// initialize state variables
		// e.g. timer, thread, etc.
		a3timerSet(demoState->renderTimer, 30.0);
		a3timerStart(demoState->renderTimer);

		// text
		a3demo_initializeText(demoState->text);
		demoState->textInit = 1;
		demoState->textMode = 1;
		demoState->textModeCount = 3;	// 0=off, 1=controls, 2=data


		// enable asset streaming between loads
	//	demoState->streaming = 1;


		// create directory for data
		a3fileStreamMakeDirectory("./data");


		// set default GL state
		a3demo_setDefaultGraphicsState();

		// geometry
		a3demo_loadGeometry(demoState);


		// shaders
		a3demo_loadShaders(demoState);

		// textures
		a3demo_loadTextures(demoState);

		// scene objects
		a3demo_initScene(demoState);
	}


	// return persistent state pointer
	return demoState;
}

// demo is unloaded; option to unload to prep for hotbuild
A3DYLIBSYMBOL MyState *a3demoCB_unload(MyState *demoState, a3boolean hotbuild)
{
	// release things that need releasing always, whether hotbuilding or not
	// e.g. kill thread
	// nothing in this example, but then...

	// release persistent state if not hotbuilding
	// good idea to release in reverse order that things were loaded...
	//	...normally; however, in this case there are reference counters 
	//	to make sure things get deleted when they need to, so there is 
	//	no need to reverse!
	if (!hotbuild)
	{
		// free fixed objects
		a3textRelease(demoState->text);

		// free graphics objects
		a3demo_unloadGeometry(demoState);
		a3demo_unloadShaders(demoState);
		a3demo_unloadTextures(demoState);
		a3demo_unloadFramebuffers(demoState);

		// validate unload
		a3demo_validateUnload(demoState);

		// erase other stuff
		a3trigFree();

		// erase persistent state
		free(demoState);
		demoState = 0;
	}

	// return state pointer
	return demoState;
}

// window updates display
// **NOTE: DO NOT USE FOR RENDERING**
A3DYLIBSYMBOL a3i32 a3demoCB_display(MyState *demoState)
{
	// do nothing, should just return 1 to indicate that the 
	//	window's display area is controlled by the demo
	return 1;
}

// window idles
A3DYLIBSYMBOL a3i32 a3demoCB_idle(MyState *demoState)
{
	// perform any idle tasks, such as rendering
	if (!demoState->exitFlag)
	{
		if (a3timerUpdate(demoState->renderTimer) > 0)
		{
			// render timer ticked, update demo state and draw
			a3demo_update(demoState, demoState->renderTimer->secondsPerTick);
			a3demo_input(demoState, demoState->renderTimer->secondsPerTick);
			a3demo_render(demoState);

			// update input
			a3mouseUpdate(demoState->mouse);
			a3keyboardUpdate(demoState->keyboard);
			a3XboxControlUpdate(demoState->xcontrol);

			// render occurred this idle: return +1
			return +1;
		}

		// nothing happened this idle: return 0
		return 0;
	}

	// demo should exit now: return -1
	return -1;
}

// window gains focus
A3DYLIBSYMBOL void a3demoCB_windowActivate(MyState *demoState)
{
	// nothing really needs to be done here...
	//	but it's here just in case
}

// window loses focus
A3DYLIBSYMBOL void a3demoCB_windowDeactivate(MyState *demoState)
{
	// reset input; it won't track events if the window is inactive, 
	//	active controls will freeze and you'll get strange behaviors
	a3keyboardReset(demoState->keyboard);
	a3mouseReset(demoState->mouse);
	a3XboxControlReset(demoState->xcontrol);
	a3XboxControlSetRumble(demoState->xcontrol, 0, 0);
}

// window moves
A3DYLIBSYMBOL void a3demoCB_windowMove(MyState *demoState, a3i32 newWindowPosX, a3i32 newWindowPosY)
{
	// nothing needed here
}

// window resizes
A3DYLIBSYMBOL void a3demoCB_windowResize(MyState *demoState, a3i32 newWindowWidth, a3i32 newWindowHeight)
{
	a3ui32 i;
	a3_DemoCamera *camera;

	// account for borders here
	const a3i32 frameBorder = 64;
	const a3ui32 frameWidth = newWindowWidth + frameBorder + frameBorder;
	const a3ui32 frameHeight = newWindowHeight + frameBorder + frameBorder;
	const a3real windowAspect = (a3real)newWindowWidth / (a3real)newWindowHeight;
	const a3real frameAspect = (a3real)frameWidth / (a3real)frameHeight;

	// copy new values to demo state
	demoState->windowWidth = newWindowWidth;
	demoState->windowHeight = newWindowHeight;
	demoState->windowWidthInv = a3recip((a3real)newWindowWidth);
	demoState->windowHeightInv = a3recip((a3real)newWindowHeight);
	demoState->windowAspect = windowAspect;
	demoState->frameWidth = frameWidth;
	demoState->frameHeight = frameHeight;
	demoState->frameWidthInv = a3recip((a3real)frameWidth);
	demoState->frameHeightInv = a3recip((a3real)frameHeight);
	demoState->frameAspect = frameAspect;
	demoState->frameBorder = frameBorder;

	// framebuffers should be initialized or re-initialized here 
	//	since they are likely dependent on the window size
	a3demo_unloadFramebuffers(demoState);
	a3demo_loadFramebuffers(demoState);

	// use framebuffer deactivate utility to set viewport
	a3framebufferDeactivateSetViewport(a3fbo_depthDisable, -frameBorder, -frameBorder, demoState->frameWidth, demoState->frameHeight);

	// viewing info for projection matrix
	// initialize cameras dependent on viewport
	for (i = 0, camera = demoState->camera + i; i < demoStateMaxCount_cameraObject; ++i, ++camera)
	{
		camera->aspect = frameAspect;
		a3demo_updateCameraProjection(camera);
	}
}

// any key is pressed
A3DYLIBSYMBOL void a3demoCB_keyPress(MyState *demoState, a3i32 virtualKey)
{
	// persistent state update
//	a3keyboardSetState(demoState->keyboard, (a3_KeyboardKey)virtualKey, a3input_down);
}

// any key is held
A3DYLIBSYMBOL void a3demoCB_keyHold(MyState *demoState, a3i32 virtualKey)
{
	// persistent state update
//	a3keyboardSetState(demoState->keyboard, (a3_KeyboardKey)virtualKey, a3input_down);
}

// any key is released
A3DYLIBSYMBOL void a3demoCB_keyRelease(MyState *demoState, a3i32 virtualKey)
{
	// persistent state update
//	a3keyboardSetState(demoState->keyboard, (a3_KeyboardKey)virtualKey, a3input_up);
}

// ASCII key is pressed (immediately preceded by "any key" pressed call above)
// NOTE: there is no release counterpart
A3DYLIBSYMBOL void a3demoCB_keyCharPress(MyState *demoState, a3i32 asciiKey)
{
	a3ui32 demoSubMode = demoState->demoSubMode[demoState->demoMode];
	const a3ui32 demoSubModeCount = demoState->demoSubModeCount[demoState->demoMode];
	const a3ui32 demoOutput = demoState->demoOutputMode[demoState->demoMode][demoSubMode];
	const a3ui32 demoOutputCount = demoState->demoOutputCount[demoState->demoMode][demoSubMode];

	// persistent state update
	a3keyboardSetStateASCII(demoState->keyboard, (a3byte)asciiKey);

	// handle special cases immediately
	switch (asciiKey)
	{
		// uncomment to make escape key kill the current demo
		// if disabled, use 'exit demo' menu option
//	case 27: 
//		demoState->exitFlag = 1;
//		break;

		// reload (T) or toggle (t) text
	case 'T':
		if (!a3textIsInitialized(demoState->text))
		{
			a3demo_initializeText(demoState->text);
			demoState->textInit = 1;
		}
		else
		{
			a3textRelease(demoState->text);
			demoState->textInit = 0;
		}
		break;
	case 't':
		demoState->textMode = (demoState->textMode + 1) % demoState->textModeCount;
		break;

		// reload all shaders in real-time
	case 'P':
		a3demo_unloadShaders(demoState);
		a3demo_loadShaders(demoState);
		break;


		// change pipeline mode
	case '.':
		demoState->demoMode = (demoState->demoMode + 1) % demoState->demoModeCount;
		break;
	case ',':
		demoState->demoMode = (demoState->demoMode + demoState->demoModeCount - 1) % demoState->demoModeCount;
		break;

		// change pipeline stage
	case '>':
		demoSubMode = demoState->demoSubMode[demoState->demoMode] = (demoSubMode + 1) % demoSubModeCount;
		break;
	case '<':
		demoSubMode = demoState->demoSubMode[demoState->demoMode] = (demoSubMode + demoSubModeCount - 1) % demoSubModeCount;
		break;

		// change stage output
	case '}':
		demoState->demoOutputMode[demoState->demoMode][demoSubMode] = (demoOutput + 1) % demoOutputCount;
		break;
	case '{':
		demoState->demoOutputMode[demoState->demoMode][demoSubMode] = (demoOutput + demoOutputCount - 1) % demoOutputCount;
		break;


		// toggle grid
	case 'g':
		demoState->displayGrid = 1 - demoState->displayGrid;
		break;

		// toggle world axes
	case 'x':
		demoState->displayWorldAxes = 1 - demoState->displayWorldAxes;
		break;

		// toggle object axes
	case 'z':
		demoState->displayObjectAxes = 1 - demoState->displayObjectAxes;
		break;


		// update animation
	case 'm':
		demoState->updateAnimation = 1 - demoState->updateAnimation;
		break;
	}


	// callback for current mode
	switch (demoState->demoMode)
	{
		// main render pipeline
	case 0:
		a3demoCB_keyCharPress_main(demoState, asciiKey,
			demoSubMode, demoOutput, demoSubModeCount, demoOutputCount);
		break;

		// curve drawing
	case 1:
		break;
	}
}

// ASCII key is held
A3DYLIBSYMBOL void a3demoCB_keyCharHold(MyState *demoState, a3i32 asciiKey)
{
	// persistent state update
	a3keyboardSetStateASCII(demoState->keyboard, (a3byte)asciiKey);


	// callback for current mode
	switch (demoState->demoMode)
	{
		// main render pipeline
	case 0:
		a3demoCB_keyCharHold_main(demoState, asciiKey);
		break;

		// curve drawing
	case 1:
		break;
	}
}

// mouse button is clicked
A3DYLIBSYMBOL void a3demoCB_mouseClick(MyState *demoState, a3i32 button, a3i32 cursorX, a3i32 cursorY)
{
	// persistent state update
	a3mouseSetState(demoState->mouse, (a3_MouseButton)button, a3input_down);
	a3mouseSetPosition(demoState->mouse, cursorX, cursorY);

	// curve waypoint placement
	if (demoState->demoMode == 1)
	{
		if (button == a3mouse_left)
		{
			if (demoState->curveWaypointCount < demoStateMaxCount_curveWaypoint)
			{
				// set up new waypoint by unprojecting mouse position in NDC
				a3vec4 pos = {
					+((a3real)(cursorX + demoState->frameBorder) * demoState->frameWidthInv * a3realTwo - a3realOne),
					-((a3real)(cursorY + demoState->frameBorder) * demoState->frameHeightInv * a3realTwo - a3realOne),
					a3realZero, a3realOne
				};
				a3real4Real4x4MulR(demoState->curveCamera->projectionMatInv.m, pos.v);
				demoState->curveWaypoint[demoState->curveWaypointCount] = pos;
				demoState->curveHandle[demoState->curveWaypointCount] = pos;
				++demoState->curveWaypointCount;
			}
		}
		else if (button == a3mouse_right)
		{
			// delete previous waypoint by simply decrementing the count
			if (demoState->curveWaypointCount > 0)
				--demoState->curveWaypointCount;
		}
	}
}

// mouse button is double-clicked
A3DYLIBSYMBOL void a3demoCB_mouseDoubleClick(MyState *demoState, a3i32 button, a3i32 cursorX, a3i32 cursorY)
{
	// persistent state update
	a3mouseSetState(demoState->mouse, (a3_MouseButton)button, a3input_down);
	a3mouseSetPosition(demoState->mouse, cursorX, cursorY);
}

// mouse button is released
A3DYLIBSYMBOL void a3demoCB_mouseRelease(MyState *demoState, a3i32 button, a3i32 cursorX, a3i32 cursorY)
{
	// persistent state update
	a3mouseSetState(demoState->mouse, (a3_MouseButton)button, a3input_up);
	a3mouseSetPosition(demoState->mouse, cursorX, cursorY);
}

// mouse wheel is turned
A3DYLIBSYMBOL void a3demoCB_mouseWheel(MyState *demoState, a3i32 delta, a3i32 cursorX, a3i32 cursorY)
{
	// persistent state update
	a3mouseSetStateWheel(demoState->mouse, (a3_MouseWheelState)delta);
	a3mouseSetPosition(demoState->mouse, cursorX, cursorY);

	if (demoState->demoMode == 0)
	{
		// can use this to change zoom
		// zoom should be faster farther away
		a3_DemoCamera *camera = demoState->camera + demoState->activeCamera;
		camera->fovy -= camera->ctrlZoomSpeed * (camera->fovy / a3realOneEighty) * (a3f32)delta;
		camera->fovy = a3clamp(camera->ctrlZoomSpeed, a3realOneEighty - camera->ctrlZoomSpeed, camera->fovy);
		a3demo_updateCameraProjection(camera);
	}
}

// mouse moves
A3DYLIBSYMBOL void a3demoCB_mouseMove(MyState *demoState, a3i32 cursorX, a3i32 cursorY)
{
	// persistent state update
	a3mouseSetPosition(demoState->mouse, cursorX, cursorY);

	// curve waypoint placement
	if (demoState->demoMode == 1)
	{
		// if left is down, placing waypoint
		if (demoState->mouse->btn.btn[a3mouse_left])
		{
			// get cursor position in NDC
			a3vec4 pos = {
				+((a3real)(cursorX + demoState->frameBorder) * demoState->frameWidthInv * a3realTwo - a3realOne),
				-((a3real)(cursorY + demoState->frameBorder) * demoState->frameHeightInv * a3realTwo - a3realOne),
				a3realZero, a3realOne
			};
			a3real4Real4x4MulR(demoState->curveCamera->projectionMatInv.m, pos.v);
			demoState->curveHandle[demoState->curveWaypointCount - 1] = pos;
		}
	}
}

// mouse leaves window
A3DYLIBSYMBOL void a3demoCB_mouseLeave(MyState *demoState)
{
	// reset mouse state or any buttons pressed will freeze
	a3mouseReset(demoState->mouse);
}

*/

//-----------------------------------------------------------------------------
