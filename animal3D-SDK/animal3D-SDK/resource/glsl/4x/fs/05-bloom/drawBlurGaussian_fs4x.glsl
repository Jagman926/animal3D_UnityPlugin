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
	
	drawBlurGaussian_fs4x.glsl
	Implements and performs Gaussian blur algorithms.
*/


/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/


#version 410

// ****TO-DO: 
//	1) declare uniforms used in this algorithm (see blur pass in render)
//	2) implement one or more 1D Gaussian blur functions
//	3) output result as blurred image

in vec2 vPassTexcoord;


uniform sampler2D uImage0;

uniform vec2 uPixelSz;	//(1) axis to blend on

layout (location = 0) out vec4 rtFragColor;

int pascals[5] = int[5](1, 4, 6, 4, 1);

vec4 calcGaussianBlur1D_Loop(in sampler2D image, in vec2 center, in vec2 axis)
{
	vec4 color = vec4(0.0);

	int startPos = (pascals.length - 1) / -2; //where the axis starts

	//loop through each to array value    attempted to 
	for(int i = 0; i < pascals.length; i++)
	{	
		color += texture(image, center + (axis * (i + startPos))) * pascals[i];	//Add up color from position
	}

	return color / pow(pascals.length-1, 2); //divide it by the power
}


// Gaussian blur with 1D kernel about given axis
//	weights are selected by rows in Pascal's triangle
//		2^0 = 1:		1
//		2^1 = 2:		1	1
//		2^2 = 4:		1	2	1
//		2^3 = 8:		1	3	3	1
//		2^4 = 16:		1	4	6	4	1
vec4 calcGaussianBlur1D_4(in sampler2D image, in vec2 center, in vec2 axis)	// (2)
{

	vec4 color = vec4(0.0);
	
	color += texture(image, center + axis) * 2.0;
	color += texture(image, center + axis) * 6.0;
	color += texture(image, center + axis) * 15.0;
	color += texture(image, center) * 20.0;
	color += texture(image, center - axis) * 15.0;
	color += texture(image, center - axis) * 6.0;
	color += texture(image, center - axis) * 2.0;

	return color/64.0;

	// dummy: sample image at center
	//return texture(image, center);
}


void main()
{


	// DUMMY OUTPUT: all fragments are LIME
//	rtFragColor = vec4(0.0, 1.0, 0.5, 1.0);

	//rtFragColor = calcGaussianBlur1D_4(uImage0, vPassTexcoord, uPixelSz);	//(3)
	rtFragColor = calcGaussianBlur1D_Loop(uImage0, vPassTexcoord, uPixelSz);	//(3)

	// DEBUGGING
	//vec4 sample0 = texture(uImage0, vPassTexcoord);
//	rtFragColor = vec4(vPassTexcoord, 0.0, 1.0);
	//rtFragColor = 1.0 - sample0;

}
