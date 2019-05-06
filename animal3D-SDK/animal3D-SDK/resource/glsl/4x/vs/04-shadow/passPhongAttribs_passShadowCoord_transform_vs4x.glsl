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
	
	passPhongAttribs_passShadowCoord_transform_vs4x.glsl
	Transform position attribute for rasterization and shadow coordinate; pass 
		attributes related to Phong and projection.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	0) copy entirety of Phong vertex shader
//	1) declare uniform for projector transform
//	2) declare varying for shadow coordinate
//	3) calculate and copy shadow coordinate

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 aNormal;
layout (location = 8) in vec2 aTexcoord;

uniform mat4 uMV, uP;
uniform mat4 uMV_nrm;

uniform mat4 uMVPB_proj;	// (1)

out vec4 vPassShadowCoord;	// (2)

out vec2 vTexcoord;	//(0)

out vec4 vNormals;	//(0)

out vec4 vPosition;	//(0)

out vec4 vCamPos;	//(0)


void main()
{
	vec4 pos_eye = uMV * aPosition;	//(0)
	gl_Position = uP * pos_eye;

	vec4 nrm_eye = uMV_nrm * aNormal;	//(0)

	vPassShadowCoord = uMVPB_proj * aPosition;	// (3)
	
	//PHONG (0)
	vTexcoord = aTexcoord;	
	vPosition = aPosition;
	vCamPos = uMV * aPosition;
	vNormals = uMV_nrm * aNormal;

}
