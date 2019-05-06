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
	
	drawPhongMulti_shadowmap_fs4x.glsl
	Phong shading with shadow mapping.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	0) copy entirety of Phong fragment shader
//	1) declare shadow map texture
//	2) declare varying to receive shadow coordinate
//	3) perform perspective divide to acquire projector's screen-space coordinate
//		-> *try outputting this as color
//	4) sample shadow map using screen-space coordinate
//		-> *try outputting this on its own
//	5) perform shadow test
//		-> *try outputting result (boolean)
//	6) apply shadow to shading model

//THREE LINES FOR PROJECTION // TEN TOTAL FOR BOTH

layout (location = 0) out vec4 rtFragColor;
layout (location = 1) out vec4 rtNormal;

//Output Normal as rtFrag

uniform sampler2D uTex_shadow;  //(1)

in vec4 vPassShadowCoord;	// (2)

// PHONG (0)

//Phong Functions
vec3 phongReflection(int arrayValue);	//(0)
float getDiffuse(vec3 normal, vec3 lightDir);	//(0)
float getSpecular(vec3 view, vec3 reflection);	//(0)
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position);	//(0)

//Light data
const int MAX_LIGHTS = 4;	//(0)
uniform int uLightCt;	//(0)
uniform vec4 uLightPos[MAX_LIGHTS];	//(0)
uniform vec4 uLightCol[MAX_LIGHTS];	//(0)		
uniform float uLightSz[MAX_LIGHTS];	//(0)

//Texture data
uniform sampler2D uTex_dm;	// (0)
uniform sampler2D uTex_sm;	// (0)

//vertex data
in vec2 vTexcoord;		// (0)
in vec4 vNormals;		// (0)
in vec4 vPosition;		// (0)
in vec4 vCamPos;		// (0)

void main()
{
	// DUMMY OUTPUT: all fragments are LIME
	//rtFragColor = vec4(0.0, 1.0, 0.5, 1.0);

	// Phong
	vec3 phongShade = vec3(0.0, 0.0, 0.0);		//(0)

											
	vec3 view = normalize(-vCamPos.xyz);			//(0)
	vec3 normal = normalize(vNormals.xyz);		//(0)

	for(int i = 0; i < uLightCt; i++)					//(0)
	{
		phongShade += phongReflection(i);		//(0)
				
	}		//(0)

	rtFragColor = vec4(phongShade, 1.0);		//(0)

	// ---------------------------------------------

	// shadow mapping
	vec4 screen_proj = 	vPassShadowCoord / 
		vPassShadowCoord.w;	//This is how clipping "works" (3)

		vec4 sampleShadow = texture(uTex_shadow, screen_proj.xy);	//(2)

		float shadowValue = sampleShadow.x;	//(5)
		float shadowTest = screen_proj.z > shadowValue + 0.0001 ? 0.2 : 1.0;		//(5)

		
		//rtFragColor = screen_proj;	//(3*)
		//rtFragColor = sampleShadow;		//(4*)
		//rtFragColor = vec4(shadowTest, shadowTest, shadowTest, 1.0); //(5*)
		rtFragColor.rgb *= shadowTest;	//(6)
		rtNormal = vec4(normal * 0.5 + 0.5, 1.0); // multiply by half add half

}


//Phong (0)
vec3 phongReflection(int arrayValue)																   // (0)
{																									   // (0)
vec3 phong;																							   // (0)
																									   // (0)
	vec3 view = normalize(-vCamPos.xyz);																   // (0)
	vec3 normal = normalize(vNormals.xyz);															   // (0)
	vec3 lightDir = normalize(uLightPos[arrayValue].xyz - vCamPos.xyz);								   // (0)
	vec3 reflection = reflect(-lightDir.xyz, normal.xyz);											   // (0)
																									   // (0)
	vec4 diffuseAlbedo = texture2D(uTex_dm, vTexcoord); 											   // (0)
	vec4 specularAlbedo = texture2D(uTex_sm, vTexcoord); 											   // (0)
								   
	float attenuation = getAttenuation(uLightSz[arrayValue], uLightPos[arrayValue], vPosition);	

	vec3 diffuse = getDiffuse(normal, lightDir) * diffuseAlbedo.xyz;
																									
	
	vec3 specular = getSpecular(view, reflection) * specularAlbedo.xyz;																							
																										// (0)
	phong =  attenuation  * ( diffuse + specular ) * uLightCol[arrayValue].xyz;							// (0)
	return phong;																						// (0)
																										// (0)
}

//Phong (0)
//get diffuse float at point
float getDiffuse(vec3 normal, vec3 lightDir)
{
	float diffuse = (max(dot(normal,lightDir),0.0));
	return diffuse;
}

//Phong (0)
//get specular float at a point
float getSpecular(vec3 view, vec3 reflection)
{
	float specular = (pow(max(dot(view, reflection), 0.0), 2));	
	return specular;
}

//Phong (0)
//get attenuation at a position
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position)
{

float lightDistance = length(lightPosition - position);
float attenuation =  1.0 / (1.0 + lightSize * pow(lightDistance, 2));
return attenuation;

}
