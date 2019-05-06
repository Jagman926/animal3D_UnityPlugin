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
	
	passPhongAttribs_transform_atlas_vs4x.glsl
	Transform position attribute and pass attributes related to Phong shading 
		model down the pipeline. Also transforms texture coordinates.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/



#version 410

// ****TO-DO: 
//	1) declare transformation uniforms
//	2) declare varyings (attribute data) to send to fragment shader
//	3) transform input data appropriately
//	4) copy transformed data to varyings

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 aNormal;
layout (location = 8) in vec4 aTexcoord;

out vec4 vNormals; //(2)
out vec4 vTexcoord;	//(2)
out vec4 vPosition;	//(2)
out vec4 vAtlas;	//(2)

uniform mat4 uMV;	//(1)
uniform mat4 uP;	//(1)
uniform mat4 uMV_nrm; //(1)
uniform mat4 uAtlas;	//(1)

void main()
{
	// DUMMY OUTPUT: directly assign input position to output position
	gl_Position = uP*uMV*aPosition; //(3)
	vNormals = normalize(uMV_nrm * aNormal);	//(3,4)
	vTexcoord = aTexcoord;	//(3,4)
	vPosition = uMV * aPosition;	//(3,4)
	vAtlas = uAtlas * vTexcoord;	//(3,4)
}
