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
	
	drawTangentBasis_gs4x.glsl
	Draw tangent basis.
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
//	2) draw tangent basis in place of each vertex

layout (triangles) in;
layout (line_strip, max_vertices = 18) out;

uniform mat4 uP;

in mat4 vPassTangentBasis[];	//(1)
out vec4 vPassColor;	//(2)

void main()
{
	
	//Standard basis used for color
	mat4 standardBasis = mat4(
		1.0, 0.0, 0.0, 1.0,
		0.0, 1.0, 0.0, 1.0,
		0.0, 0.0, 1.0, 1.0,
		0.0, 0.0, 0.0, 1.0);
	
	const float size = 0.2;	//length of tangent line
	
	//for (int i = 0; i < 3; i++) //draws extra tangents but for each triangle point
	for (int i = 0; i < 1; i++)	//One tangent for each triangle point
	{

	//Optimize by normalizing and multiplying by projection matrix first then storing it
		mat4 tangent = uP * mat4(
			normalize(vPassTangentBasis[i][0])* size, 
			normalize(vPassTangentBasis[i][1])* size, 
			normalize(vPassTangentBasis[i][2])* size, 
			vPassTangentBasis[i][3]);
				
		for(int j = 0; j < 3; j++)	//(2)
		{
			vPassColor = standardBasis[j]; //Set color

			gl_Position = (tangent[3]); //(2) first point
			EmitVertex(); 

			gl_Position = tangent[3] + tangent[j]; //(2) second point
			EmitVertex();

			EndPrimitive();

		}

	}

}
