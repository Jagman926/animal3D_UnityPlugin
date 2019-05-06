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
	
	drawGBuffers_fs4x.glsl
	Output attributes to MRT ("g-buffers").
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	1) declare varyings (attribute data) to receive from vertex shader
//	2) declare g-buffer render targets
//	3) pack attribute data into outputs

layout (location = 0) out vec4 rtPosition;
layout (location = 1) out vec4 rtNormal;
layout (location = 2) out vec4 rtTexcoord;

in vec4 vNormals;
in vec4 vTexcoord;
in vec4 vPosition;
in vec4 vAtlas;

void main()
{
	// DUMMY OUTPUT: all fragments are FADED YELLOW
	//rtFragColor = vec4(1.0, 1.0, 0.5, 1.0);

	rtNormal = vec4(vNormals.xyz, 1.0); //(1*)
	rtTexcoord = vAtlas; //(1*)
	//rtFragColor = vTexcoord;	//(1*)
	rtPosition = vPosition;	//(1*)



}
