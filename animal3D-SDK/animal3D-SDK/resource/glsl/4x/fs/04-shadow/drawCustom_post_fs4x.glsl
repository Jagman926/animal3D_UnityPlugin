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
	
	drawCustom_post_fs4x.glsl
	Custom post-processing fragment shader.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	0) start with texturing FS
//	1) declare any other uniforms, textures or otherwise, that would be 
//		appropriate for some post-processing effect
//	2) implement some simple post-processing algorithm (e.g. outlines)

uniform sampler2D uTex_dm;	//(1)
uniform sampler2D uTex_nm;	//(1)
uniform double uTime;		//(10

//Source code belongs to : https://github.com/kiwipxl/GLSL-shaders/blob/master/outline.glsl
//Code creates an outline around anything that  

layout (location = 0) out vec4 rtFragColor;

in vec2 vPassTexcoord;
in vec4 vPosition;


void main()
{
	//(2) Outline alpha
	float lineThickness = 0.3;	//(2)

	rtFragColor = texture(uTex_dm, vPassTexcoord);

	//Dont do anything that has a alpha. Post processing effect only works when skybox off
	if(rtFragColor.a <= 0.5) 
	{
		vec2 size = textureSize(uTex_dm, 0);

		float uvX = vPassTexcoord.x * size.x;
		float uvY = vPassTexcoord.y * size.y;

		float sum = 0.0;

		//For loop gets points next to texcoord 
			//and checks to see of theirs a value that isn't alpha
		for(int n = 0; n < 9; ++n)
		{
			uvY = (vPassTexcoord.y * size.y) + (lineThickness * float(n - 4.5));
			float tempSum = 0.0;
			tempSum += texelFetch(uTex_dm, ivec2(uvX - (4.0 * lineThickness), uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX - (3.0 * lineThickness), uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX - (2.0 * lineThickness), uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX - lineThickness, uvY), 0).a;			
			tempSum += texelFetch(uTex_dm, ivec2(uvX, uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX + lineThickness, uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX + (2.0 * lineThickness), uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX + (3.0 * lineThickness), uvY), 0).a;
			tempSum += texelFetch(uTex_dm, ivec2(uvX + (4.0 * lineThickness), uvY), 0).a;
			sum += tempSum / 9.0;
		}

		//If its close to something thats not alpha draw a color on top of it
		if(sum / 9.0 >= 0.1)
		{
		rtFragColor = vec4(sin(float(-uTime)), sin(float(uTime)), 1.0, 1.0);
		}
	}

}
