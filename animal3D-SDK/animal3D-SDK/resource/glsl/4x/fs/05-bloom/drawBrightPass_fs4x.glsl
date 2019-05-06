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
	
	drawBrightPass_fs4x.glsl
	Perform bright pass filter: bright stays bright, dark gets darker.
*/


/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/


#version 410

// ****TO-DO: 
//	1) implement a function to calculate the relative luminance of a color
//	2) implement a general tone-mapping or bright-pass filter
//	3) sample the input texture
//	4) filter bright areas, output result

in vec2 vPassTexcoord;

uniform sampler2D uImage0;

layout (location = 0) out vec4 rtFragColor;


void main()
{
	// DUMMY OUTPUT: all fragments are ORANGE
//	rtFragColor = vec4(1.0, 0.5, 0.0, 1.0);


	vec4 sample0 = texture(uImage0, vPassTexcoord); //(3)
	float lum = ((0.2126*sample0.r) + (0.7152*sample0.g) + (0.0722*sample0.b));	// (1)

	//rtFragColor = vec4(lum, lum, lum, 1.0);

	//TO-DO Make it better 
	
	//https://learnopengl.com/Advanced-Lighting/HDR
	float gamma = 2.7;
	vec3 mapped = lum / (lum + vec3(1.0));	

	mapped = pow(mapped, vec3(1.0 / gamma));
	
	rtFragColor.rgb = sample0.rgb* lum  * mapped; // (4)


	// DEBUGGING
	//rtFragColor = vec4(vPassTexcoord, 0.0, 1.0);
	//rtFragColor = 0.1 + sample0;
	

	
}
