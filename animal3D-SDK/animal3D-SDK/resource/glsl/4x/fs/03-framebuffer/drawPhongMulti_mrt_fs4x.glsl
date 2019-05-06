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
	
	drawPhongMulti_mrt_fs4x.glsl
	Phong shading model with splitting to multiple render targets (MRT).
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
//	1) declare eight render targets
//	2) output appropriate data to render targets


vec3 phongReflection(int arrayValue);	//(0)

float getDiffuse(vec3 normal, vec3 lightDir);
float getSpecular(vec3 view, vec3 reflection);

float getAttenuation(float lightSize, vec4 lightPosition, vec4 position);
					
const int MAX_LIGHTS = 4;  //(0)


uniform int uLightCt;	//(0)
uniform vec4 uLightPos[MAX_LIGHTS];	//(0)
uniform vec4 uLightCol[MAX_LIGHTS];	//(0)		
uniform float uLightSz[MAX_LIGHTS];	//(0)

uniform sampler2D uTex_dm;	// (0)
uniform sampler2D uTex_sm;	// (0)

in vbPassBlockData
{
 vec4 vPosition;	//(1)
 vec4 vNormals;	//(1)
 vec2 vTexcoord;	//(1)
 vec4 vCamPos;
} vPassData_in;



//testing
layout (location = 0) out vec4 rtPositionData;			 // (1)
layout (location = 1) out vec4 rtNormals;				 // (1)
layout (location = 2) out vec4 rtTexcoord;				 // (1)
layout (location = 3) out vec4 rtDiffuseSample;			 // (1)
layout (location = 4) out vec4 rtSpecularSample;		 // (1)
layout (location = 5) out vec4 rtDiffuseTotal;			 // (1)
layout (location = 6) out vec4 rtSpecularTotal;			 // (1)
layout (location = 7) out vec4 rtPhongShading;			 // (1)

void main()
{
	rtPositionData = vPassData_in.vCamPos; //(2)
	
	rtNormals = vec4(normalize(vPassData_in.vNormals).xyz, 1.0);	// (2)

	rtTexcoord = vec4(vPassData_in.vTexcoord, 0.0, 1.0);	//(2)

	rtDiffuseSample = texture2D(uTex_dm, vPassData_in.vTexcoord);	//(2)

	rtSpecularSample = texture2D(uTex_sm, vPassData_in.vTexcoord);	//(2)

	vec3 diffuseTot = vec3(0.0, 0.0, 0.0);
	vec3 specularTot = vec3(0.0, 0.0, 0.0);
	vec3 phongShade = vec3(0.0, 0.0, 0.0);

											
	vec3 view = normalize(-vPassData_in.vCamPos.xyz);		
	vec3 normal = normalize(vPassData_in.vNormals.xyz);

	for(int i = 0; i < uLightCt; i++)	
	{
		phongShade += phongReflection(i);

		vec3 lightDir = normalize(uLightPos[i].xyz - vPassData_in.vCamPos.xyz);					   
		vec3 reflection = reflect(-lightDir.xyz, normal.xyz);				
				
		float attenuation = getAttenuation(uLightSz[i], uLightPos[i], vPassData_in.vPosition );

		diffuseTot += ( attenuation * getDiffuse(normal, lightDir)  * uLightCol[i].xyz);
		
		specularTot +=  (attenuation * getSpecular(view, reflection)  * uLightCol[i].xyz);

	}

	rtDiffuseTotal = vec4(diffuseTot, 1.0);		//(2)
	rtSpecularTotal = vec4(specularTot, 1.0);	//(2)
	rtPhongShading = vec4(phongShade, 1.0);		//(2)

}


vec3 phongReflection(int arrayValue)																   // (0)
{																									   // (0)
vec3 phong;																							   // (0)
																									   // (0)
	vec3 view = normalize(-vPassData_in.vCamPos.xyz);																   // (0)
	vec3 normal = normalize(vPassData_in.vNormals.xyz);															   // (0)
	vec3 lightDir = normalize(uLightPos[arrayValue].xyz - vPassData_in.vCamPos.xyz);								   // (0)
	vec3 reflection = reflect(-lightDir.xyz, normal.xyz);											   // (0)
																									   // (0)
	vec4 diffuseAlbedo = texture2D(uTex_dm, vPassData_in.vTexcoord); 											   // (0)
	vec4 specularAlbedo = texture2D(uTex_sm, vPassData_in.vTexcoord); 											   // (0)
								   
	float attenuation = getAttenuation(uLightSz[arrayValue], uLightPos[arrayValue], vPassData_in.vPosition);	

	vec3 diffuse = getDiffuse(normal, lightDir) * diffuseAlbedo.xyz;
																									
	
	vec3 specular = getSpecular(view, reflection) * specularAlbedo.xyz;																							
																										// (0)
	phong =  attenuation  * ( diffuse + specular ) * uLightCol[arrayValue].xyz;							// (0)
	return phong;																						// (0)
																										// (0)
}


//get diffuse float at point
float getDiffuse(vec3 normal, vec3 lightDir)
{
	float diffuse = (max(dot(normal,lightDir),0.0));
	return diffuse;
}

//get specular float at a point
float getSpecular(vec3 view, vec3 reflection)
{
	float specular = (pow(max(dot(view, reflection), 0.0), 2));	
	return specular;
}

//get attenuation at a position
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position)
{

float lightDistance = length(lightPosition - position);
float attenuation =  1.0 / (1.0 + lightSize * pow(lightDistance, 2));
return attenuation;

}