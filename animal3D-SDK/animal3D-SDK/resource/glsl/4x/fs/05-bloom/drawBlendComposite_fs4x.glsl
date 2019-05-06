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
//	1) declare image handles (see blend pass in render)
//	2) sample and *test images 
//	3) implement some multi-image blending algorithms
//	4) output result as blend between multiple images


vec4 screen(vec4 layerOne, vec4 layerTwo, vec4 layerThree = vec4(1.0), vec4 layerFour = vec4(1.0));
vec4 overlay(vec4 layerOne, vec4 layerTwo, vec4 layerThree = vec4(1.0), vec4 layerFour = vec4(1.0));

in vec2 vPassTexcoord;

uniform sampler2D uImage0;
uniform sampler2D uImage1;
uniform sampler2D uImage2;
uniform sampler2D uImage3;

layout (location = 0) out vec4 rtFragColor;


void main()
{
	// DUMMY OUTPUT: all fragments are PURPLE
//	rtFragColor = vec4(0.5, 0.0, 1.0, 1.0);


	vec4 sample0 = texture(uImage0, vPassTexcoord);	//(2)
	//rtFragColor = sample0;	//(2*)

	vec4 sample1 = texture(uImage1, vPassTexcoord); //(2)
	//rtFragColor = sample1;	//(2*)

	vec4 sample2 = texture(uImage2, vPassTexcoord); //(2)
	//rtFragColor = sample2;	//(2*)

	vec4 sample3 = texture(uImage3, vPassTexcoord); //(2)
	//rtFragColor = sample3;	//(2*)

	vec4 total = screen(sample0, sample1, sample2, sample3);	//(3)
	//vec4 total = overlay(sample0, sample1, sample2, sample3);	//(3)
	rtFragColor = total;	//(4)


	// DEBUGGING
	//rtFragColor = vec4(vPassTexcoord, 0.0, 1.0);
	//rtFragColor = sample0;
}


//Screen function	// (3)
vec4 screen(vec4 layerOne, vec4 layerTwo, vec4 layerThree, vec4 layerFour)
{
	return 1.0 - (1.0 - layerOne) * (1.0 - layerTwo) * (1.0 - layerThree) * (1.0 - layerFour);
}


//Overlay function // (3 extra)
vec4 overlay(vec4 layerOne, vec4 layerTwo, vec4 layerThree, vec4 layerFour)
{
	vec4 color = length(layerOne) < 0.5 ? (2.0 * layerOne * layerTwo * layerThree * layerFour) :	(1.0 - 2.0 * (1.0 - layerOne) * (1.0 - layerTwo) * (1.0 - layerThree) * (1.0 - layerFour));

	return color;
}