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
	
	drawPhongMulti_deferred_fs4x.glsl
	Perform Phong shading on multiple lights, deferred.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/



#version 410

// ****TO-DO: 
//	0) copy entirety of Phong multi-light shader
//	1) geometric inputs from scene objects are not received from VS!
//		-> we are drawing a textured FSQ so where does the geometric 
//			input data come from? declare appropriately
//	2) retrieve new geometric inputs (no longer from varyings)
//		-> *test by outputting as color
//	3) use new inputs where appropriate in lighting


//Phong Functions
vec4 phongReflection(int arrayValue, vec3 normals, vec4 position, vec2 texCoord);	//(0)
float getDiffuse(vec3 normal, vec3 lightDir);	//(0)
float getSpecular(vec3 view, vec3 reflection);	//(0)
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position);	//(0)

//Light data
const int MAX_LIGHTS = 4;	//(0)
uniform int uLightCt;	//(0)
uniform vec4 uLightPos[MAX_LIGHTS];	//(0)
uniform vec4 uLightCol[MAX_LIGHTS];	//(0)		
uniform float uLightSz[MAX_LIGHTS];	//(0)

in vec2 vPassTexcoord;

//(1)
uniform sampler2D uImage4; //position
uniform sampler2D uImage5; //normal
uniform sampler2D uImage6; //texcoord
uniform sampler2D uImage7; //depth
uniform sampler2D uImage0; //Diffuse
uniform sampler2D uImage1; //Specular

layout (location = 0) out vec4 rtFragColor;


void main()
{
	// DUMMY OUTPUT: all fragments are PURPLE
	//rtFragColor = vec4(0.5, 0.0, 1.0, 1.0);
	//rtFragColor = vec4(vPassTexcoord, 0.0, 1.0);

	vec4 gPosition = texture(uImage4, vPassTexcoord);	//(2)
	vec4 gNormal = texture(uImage5, vPassTexcoord);	//(2)
	vec2 gTexcoord = texture(uImage6, vPassTexcoord).xy;	//(2)
	float gDepth = texture(uImage7, vPassTexcoord).x;	//(2)

	//rtFragColor = gPosition; //(2*)
	//rtFragColor = vec4(gNormal.rgb * 0.5 + 0.5, 1.0); //(2*)
	//rtFragColor = vec4(gTexcoord, 0.0, 1.0); //(2*)
	//rtFragColor = vec4(gDepth, gDepth, gDepth, 1.0); //(2*)

	// Phong
	vec4 phongShade = vec4( 0.0);		//(0)

											

	for(int i = 0; i < uLightCt; i++)					//(0)
	{
		phongShade += phongReflection(i, gNormal.xyz, gPosition, gTexcoord);		//(0)
				
	}		//(0)

	float diffuseAlpha = texture2D(uImage0, gTexcoord).a;
	rtFragColor = vec4(phongShade.xyz, diffuseAlpha);		//(0)

	// ---------------------------------------------
}

//Phong (0)
vec4 phongReflection(int arrayValue, vec3 normals, vec4 position, vec2 texCoord)																   // (0)
{																									   // (0)
	vec4 phong;																							   // (0)
																									   // (0)
	vec4 vCamPos = position;

	vec3 view = normalize(-vCamPos.xyz);																   // (0)
	vec3 normal = normalize(normals);															   // (0)
	vec3 lightDir = normalize(uLightPos[arrayValue].xyz - vCamPos.xyz);								   // (0)
	vec3 reflection = reflect(-lightDir.xyz, normal.xyz);											   // (0)
																									   // (0)
	vec4 diffuseAlbedo = texture2D(uImage0, texCoord); 											   // (0)
	vec4 specularAlbedo = texture2D(uImage1, texCoord); 											   // (0)
								   
	float attenuation = getAttenuation(uLightSz[arrayValue], uLightPos[arrayValue], position);	

	vec4 diffuse = getDiffuse(normal, lightDir) * diffuseAlbedo;
																									
	
	vec4 specular = getSpecular(view, reflection) * specularAlbedo;																							
										
	phong =  attenuation  * ( diffuse + specular ) * uLightCol[arrayValue];							// (0)
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

