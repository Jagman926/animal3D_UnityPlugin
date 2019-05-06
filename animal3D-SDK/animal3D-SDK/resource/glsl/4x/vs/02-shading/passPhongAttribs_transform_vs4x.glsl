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
	
	passPhongAttribs_transform_vs4x.glsl
	Transform position attribute and pass attributes related to Phong shading 
		model down the pipeline.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	1) declare separate uniforms for MV and P matrices
//	2) transform object-space position to eye-space
//	3) transform eye-space position to clip space, store as output
//	4) declare normal attribute
//		-> look in 'a3_VertexDescriptors.h' for the correct location index
//	5) declare normal MV matrix
//	6) transform object-space normal to eye-space using the correct matrix
//	7) declare texcoord attribute
//	8) declare varyings for lighting data
//	9) copy lighting data to varyings

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 aNormal;	//(4)
layout (location = 8) in vec2 aTexcoord;	//(7)


uniform mat4 uMV; // (1)
uniform mat4 uP;	//(1)
uniform mat4 uMV_nrm;	//(5)

out vbPassBlockData
{
 vec4 vPosition;
 vec4 vNormals;
 vec2 vTexcoord;
} vPassData_out;


void main()
{
	// DUMMY OUTPUT: directly assign input position to output position
	//	gl_Position = aPosition;
	
	gl_Position = uP*uMV*aPosition;	//(2) // (3)

	
	
	vPassData_out.vNormals = uMV_nrm * aNormal;	// (6)

	//vNormals = uLightPos - aPosition;

	//gl_Position = uMV_nrm*aNormal;
	

	vPassData_out.vTexcoord = aTexcoord;

	vPassData_out.vPosition = uMV * aPosition;
	

}
