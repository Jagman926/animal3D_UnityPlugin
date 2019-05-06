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
	
	drawCustom_fs4x.glsl
	Custom effects for MRT.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

//Using these tutorials. All code belongs to the original owners
/*
* https://thebookofshaders.com/edit.php?log=161119150756
* https://thebookofshaders.com/edit.php#09/zigzag.frag
* http://glslsandbox.com/e#52385.5
* https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5
*/

#version 410

// ****TO-DO: 
//	0) copy entirety of other fragment shader to start, or start from scratch: 
//		-> declare varyings to read from vertex shader
//		-> *test all varyings by outputting them as color
//	1) declare at least four render targets
//	2) implement four custom effects, outputting each one to a render target

// ()


float random(vec2 st);
vec2 mirrorTile(vec2 st, float zoom);
float fillY(vec2 st, float pct,float antia);

uniform sampler2D uTex_dm;	// (0)
uniform sampler2D uTex_sm;	// (0)

in vbPassBlockData
{
 vec4 vPosition;	//(1)
 vec4 vNormals;	//(1)
 vec2 vTexcoord;	//(1)
} vPassData_in;



//testing
layout (location = 0) out vec4 rtNoise;			 // (1) https://thebookofshaders.com/edit.php?log=161119150756
layout (location = 1) out vec4 rtStripes;				 // (1)  https://thebookofshaders.com/edit.php#09/zigzag.frag
layout (location = 2) out vec4 rtLines;				 // (1) http://glslsandbox.com/e#52385.5
layout (location = 3) out vec4 rtBlur;			 // (1)

void main()
{	

	//Random
	float r = random(vPassData_in.vTexcoord);
	rtNoise = vec4(vec3(r), 1.0);			// https://thebookofshaders.com/edit.php?log=161119150756 (2)

	//----------------------------------------------------------------
	// Stripes
	vec2 mirrored = mirrorTile(vPassData_in.vTexcoord * vec2(1.0, 2.0), 1.0);
	float xPos= vPassData_in.vTexcoord.x*10.0;
	float sinA= floor(1.0+sin( xPos*3.14));
	float sinB = floor(1.0+sin((xPos+2.0)*3.14));
	float fractale = fract(xPos);

	vec3 color = vec3(fillY(vPassData_in.vTexcoord,mix(sinA, sinB ,fractale),0.01));

	rtStripes = vec4(color, 1.0);	// https://thebookofshaders.com/edit.php#09/zigzag.frag (2)

	//----------------------------------------------------------------
	// creates a line and circle based of of sin
	float lengthValue = 0.2 / length(vPassData_in.vTexcoord);		
	float yValue = vPassData_in.vPosition.y * abs(sin(1.0));
	float xValue = vPassData_in.vPosition.x / abs(cos(1.0));
	float total = (yValue + xValue) / 2.0;
	rtLines = vec4(vec3(cos(yValue), sin(lengthValue)  , cos( xValue /1.0)), total); // http://glslsandbox.com/e#52385.5 (2)

	//----------------------------------------------------------------
	//Gets a blur
	vec4 sum = vec4(0.0, 0.0, 0.0, 0.0);
	for(int i = -4; i < 5; i++)
	{
		sum += (texture2D(uTex_dm, vec2(vPassData_in.vTexcoord.x + i*0.1, vPassData_in.vTexcoord.y + i*0.1)) * texture2D(uTex_sm, vec2(vPassData_in.vTexcoord.x + i*0.1, vPassData_in.vTexcoord.y + i*0.1)))* 0.1;
	}
	rtBlur = vec4(sum.xyz, 1.0);	//https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5 (2)

}


// https://thebookofshaders.com/edit.php?log=161119150756 (2)
float random (vec2 pos)
{
    return fract(sin(dot(pos.xy, vec2(1,1))) * 43758.5453123);
}


// https://thebookofshaders.com/edit.php#09/zigzag.frag (2)
vec2 mirrorTile(vec2 pos, float zoom){
    pos *= zoom;
    if (fract(pos.y * 0.5) > 0.5){
        pos.x = pos.x+0.5;
        pos.y = 1.0-pos.y;
    }
    return fract(pos);
}

// https://thebookofshaders.com/edit.php#09/zigzag.frag (2)
float fillY(vec2 pos, float mixed,float antia){
  return  smoothstep( mixed-antia, mixed, pos.y);
}