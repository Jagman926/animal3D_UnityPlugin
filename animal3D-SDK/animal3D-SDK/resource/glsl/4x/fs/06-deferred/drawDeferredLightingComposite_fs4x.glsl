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
	
	drawDeferredLightingComposite_fs4x.glsl
	Composite deferred lighting.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	1) declare images with results of lighting pass
//	2) declare remaining geometry inputs (atlas coordinates) and atlas textures
//	3) declare any other shading variables not involved in lighting pass
//	4) sample inputs to get components of Phong shading model
//		-> surface colors, lighting results
//		-> *test by outputting as color
//	5) compute final Phong shading model (i.e. the final sum)

in vec2 vPassTexcoord;

layout (location = 0) out vec4 rtFragColor;


uniform sampler2D uImage0; //Diffuse Atlas	(2)
uniform sampler2D uImage1; //Specular Atlas	(2)
uniform sampler2D uImage4; //Diffuse Output 	(1)
uniform sampler2D uImage5; //Specular Output	(1)
uniform sampler2D uImage6; //texcoord Output	(1)

void main()
{
	// DUMMY OUTPUT: all fragments are FADED CYAN
	//rtFragColor = vec4(0.5, 1.0, 1.0, 1.0);
		
	vec4 gTexcoord = texture(uImage6, vPassTexcoord); //(4)

	vec4 texcoord = gTexcoord / gTexcoord.w;	//(3)

	vec4 gDiffuseAtlas = texture(uImage0, texcoord.xy);	//(4)
	vec4 gSpecularAtlas = texture(uImage1, texcoord.xy);	//(4)
	vec4 gDiffuse = texture(uImage4, vPassTexcoord);	//(4)
	vec4 gSpecular = texture(uImage5, vPassTexcoord);		//(4)

	//rtFragColor = gTexcoord;  //(4*)
	//rtFragColor = gDiffuseAtlas;  //(4*)
	//rtFragColor = gDiffuse;  //(4*)
	//rtFragColor  = gSpecularAtlas;  //(4*)
	//rtFragColor  = gSpecular;  //(4*)


	rtFragColor = vec4((gDiffuse.xyz * gDiffuseAtlas.xyz) + (gSpecular.xyz * gSpecularAtlas.xyz), gTexcoord.w);	//(5)

}
