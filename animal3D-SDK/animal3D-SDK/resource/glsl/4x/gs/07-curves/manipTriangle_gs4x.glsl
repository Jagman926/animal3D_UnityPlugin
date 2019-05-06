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
	
	manipTriangle_gs4x.glsl
	Manipulate a single input triangle.
*/


/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	1) declare input and output varying data
//	2) either copy input directly to output for each vertex, or 
//		do something with the vertices first (e.g. explode, invert)

layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;

uniform mat4 uP;

in vbPassBlockData
{
 vec4 vPosition;
 vec4 vNormals;
 vec2 vTexcoord;
} vPassData_in[];

out vbPassBlockData
{
 vec4 vPosition;
 vec4 vNormals;
 vec2 vTexcoord;
} vPassData_out;


void main()
{
const float explodeSz = 0.5;
const float textureMultiply = 5;

	//for(int i = 2; i >= 0; i--)	//Invert geometry
	for(int i = 0; i < 3; i++)
	{
		//vPassData_out.vPosition =  vPassData_in[i].vPosition +(normalize(vPassData_in[i].vNormals) * explodeSz);	//(2*) Explode
		//vPassData_out.vPosition =  vPassData_in[i].vPosition +(normalize(vPassData_in[i].vNormals) * -explodeSz);  //(2*) inverted explosion
		vPassData_out.vPosition = vPassData_in[i].vPosition;	//(2*) Regular position output

		vPassData_out.vNormals =  vPassData_in[i].vNormals;		//(2) normals

		//vPassData_out.vTexcoord = vPassData_in[i].vTexcoord; //(2) regular texcoord output
		vPassData_out.vTexcoord = vPassData_in[i].vTexcoord * textureMultiply;	//(2) multiply texcoords
		
		gl_Position = uP * vPassData_out.vPosition;
		EmitVertex();
	}
	EndPrimitive();
}
