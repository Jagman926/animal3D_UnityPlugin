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
	
	drawPhongMulti_shadowmap_projective_fs4x.glsl
	Phong shading with shadow mapping and projective texturing.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410


// ****TO-DO: 
//	0) complete and combine projective texturing and shadow mapping shaders
//  1) Copy Phong 
//  2) Copy Shadows
//	3) Copy projection

//Function for screening
vec3 screen(vec3 firstValue, vec3 secondValue);

layout (location = 0) out vec4 rtFragColor;

// PHONG (1)

//Phong Functions
vec3 phongReflection(int arrayValue);	//(1)
float getDiffuse(vec3 normal, vec3 lightDir);	//(1)
float getSpecular(vec3 view, vec3 reflection);	//(1)
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position);	//(1)

//Light data
const int MAX_LIGHTS = 4;	//(1)
uniform int uLightCt;	//(1)
uniform vec4 uLightPos[MAX_LIGHTS];	//(1)
uniform vec4 uLightCol[MAX_LIGHTS];	//(1)		
uniform float uLightSz[MAX_LIGHTS];	//(1)

//Texture data
uniform sampler2D uTex_dm;	// (1)
uniform sampler2D uTex_sm;	// (1)

//vertex data
in vec2 vTexcoord;		// (1)
in vec4 vNormals;		// (1)
in vec4 vPosition;		// (1)
in vec4 vCamPos;		// (1)

//-------------
//Shadow Data	//(2)
uniform sampler2D uTex_shadow;  //(2)

in vec4 vPassShadowCoord;	// (2)

//-----------
//Projection Data (3)
uniform sampler2D uImage6;  // (3)


void main()
{
	// DUMMY OUTPUT: all fragments are PURPLE
	//rtFragColor = vec4(0.5, 0.0, 1.0, 1.0);

	// Phong
	vec3 phongShade = vec3(0.0, 0.0, 0.0);		//(1)

											
	vec3 view = normalize(-vCamPos.xyz);			//(1)
	vec3 normal = normalize(vNormals.xyz);		//(1)

	for(int i = 0; i < uLightCt; i++)					//(1)
	{
		phongShade += phongReflection(i);		//(1)
				
	}		//(1)

	rtFragColor = vec4(phongShade, 1.0);		//(1)

	// ---------------------------------------------

	// shadow mapping
	vec4 screen_proj = 	vPassShadowCoord / 
		vPassShadowCoord.w;	//This is how clipping "works" (2)

		vec4 sampleShadow = texture(uTex_shadow, screen_proj.xy);	//(2)

		float shadowValue = sampleShadow.x;	//(2)
		float shadowTest = screen_proj.z > shadowValue + 0.0001 ? 0.2 : 1.0;		//(2)

		
		//rtFragColor.rgb *= shadowTest;	//(2)

	// ----------------------------------
	// Projection mapping

	vec4 sampleTexture = texture2D(uImage6,screen_proj.xy);		//(2)

	rtFragColor = vec4(screen(rtFragColor.rgb, sampleTexture.rgb) * shadowTest, 1.0);

}

//Screen function
vec3 screen(vec3 bottomLayer, vec3 topLayer)
{
return 1 - (1 - bottomLayer) * (1 - topLayer);
}

//Phong (1)
vec3 phongReflection(int arrayValue)																   // (1)
{																									   // (1)
vec3 phong;																							   // (1)
																									   // (1)
	vec3 view = normalize(-vCamPos.xyz);																   // (1)
	vec3 normal = normalize(vNormals.xyz);															   // (1)
	vec3 lightDir = normalize(uLightPos[arrayValue].xyz - vCamPos.xyz);								   // (1)
	vec3 reflection = reflect(-lightDir.xyz, normal.xyz);											   // (1)
																									   // (1)
	vec4 diffuseAlbedo = texture2D(uTex_dm, vTexcoord); 											   // (1)
	vec4 specularAlbedo = texture2D(uTex_sm, vTexcoord); 											   // (1)
								   
	float attenuation = getAttenuation(uLightSz[arrayValue], uLightPos[arrayValue], vPosition);	

	vec3 diffuse = getDiffuse(normal, lightDir) * diffuseAlbedo.xyz;
																									
	
	vec3 specular = getSpecular(view, reflection) * specularAlbedo.xyz;																							
																										// (1)
	phong =  attenuation  * ( diffuse + specular ) * uLightCol[arrayValue].xyz;							// (1)
	return phong;																						// (1)
																										// (1)
}

//Phong (1)
//get diffuse float at point
float getDiffuse(vec3 normal, vec3 lightDir)
{
	float diffuse = (max(dot(normal,lightDir),0.0));
	return diffuse;
}

//Phong (1)
//get specular float at a point
float getSpecular(vec3 view, vec3 reflection)
{
	float specular = (pow(max(dot(view, reflection), 0.0), 2));	
	return specular;
}

//Phong (1)
//get attenuation at a position
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position)
{

float lightDistance = length(lightPosition - position);
float attenuation =  1.0 / (1.0 + lightSize * pow(lightDistance, 2));
return attenuation;

}
