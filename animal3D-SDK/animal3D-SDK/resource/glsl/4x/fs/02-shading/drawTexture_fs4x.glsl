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
	
	drawTexture_fs4x.glsl
	Draw texture sample using texture coordinate from prior shader.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	1) declare varying to read texture coordinate
//		-> *test varying by outputting it as color; shows red-green gradient
//	2) declare texture uniform for diffuse map
//	3) sample texture in main
//	4) copy texture sample to output

out vec4 rtFragColor;

in vec2 vPassTexcoord;	 // (1)


uniform sampler2D uTex_dm;	// (2)


void main()
{
	// DUMMY OUTPUT: all fragments are FADED YELLOW
	//rtFragColor = vec4(1.0, 1.0, 0.5, 1.0);
	//rtFragColor = vec4(vPassTexcoord, 0.0, 1.0); //testing varying texCoord
	rtFragColor = texture2D(uTex_dm, vPassTexcoord);	// (3,4)
	
}
