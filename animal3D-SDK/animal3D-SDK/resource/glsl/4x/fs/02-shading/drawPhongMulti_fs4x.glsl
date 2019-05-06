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
	
	drawPhongMulti_fs4x.glsl
	Calculate and output Phong shading model for multiple lights using data 
		from prior shader.
*/

/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/

#version 410

// ****TO-DO: 
//	1) declare varyings to read from vertex shader
//		-> *test all varyings by outputting them as color
//	2) declare uniforms for textures (diffuse, specular)
//	3) sample textures and store as temporary values
//		-> *test all textures by outputting samples
//	4) declare fixed-sized arrays for lighting values and other related values
//		-> *test lighting values by outputting them as color
//		-> one day this will be made easier... soon, soon...
//	5) implement Phong shading calculations
//		-> *save time where applicable
//		-> diffuse, specular, attenuation
//		-> remember to be modular (e.g. write a function)
//	6) calculate Phong shading model for one light
//		-> *test shading values (diffuse, specular) by outputting them as color
//	7) calculate Phong shading for all lights
//		-> *test shading values
//	8) add all light values appropriately
//	9) calculate final Phong model (with textures) and copy to output
//		-> *test the individual shading totals
//		-> use alpha channel from diffuse sample for final alpha


out vec4 rtFragColor;

					
const int MAX_LIGHTS = 4;


uniform int uLightCt;	//(1, 4)
uniform vec4 uLightPos[MAX_LIGHTS];	//(1, 4)
uniform vec4 uLightCol[MAX_LIGHTS];	//(1, 4)		
uniform float uLightSz[MAX_LIGHTS];	//(1, 4)

uniform sampler2D uTex_dm;	// (2)
uniform sampler2D uTex_sm;	// (2)

in vbPassBlockData
{
 vec4 vPosition;
 vec4 vNormals;
 vec2 vTexcoord;
} vPassData_in;


vec3 phongReflection(int arrayValue);
float getDiffuse(vec3 normal, vec3 lightDir);	//(0)
float getSpecular(vec3 view, vec3 reflection);	//(0)
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position);	//(0)


void main()
{

	// DUMMY OUTPUT: all fragments are FADED CYAN
	//rtFragColor = vec4(uLightSz[2], 0.0, 0.0, 1.0);


	//rtFragColor = vec4(vTexcoord, 0.0, 1.0); //(THIRD PICTURE)
	//rtFragColor = texture2D(uTex_dm, vTexcoord);	// (3)
	//rtFragColor = texture2D(uTex_sm, vTexcoord);	// (3)


	vec3 finalOutputColor = vec3(0.0, 0.0, 0.0);
	for(int i = 0; i < uLightCt; i++)	//one of these is one color (6) (7)
	{
	
	finalOutputColor += phongReflection(i); //(8) (7)
	}
	

	rtFragColor = vec4(finalOutputColor.xyz, 1.0);	//(9)
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



//Phong (0)
vec3 phongReflection(int arrayValue)														// (0)
{																							// (0)
	vec3 phong = vec3(0.0, 0.0, 0.0);														// (0)
	vec3 view = normalize(-vPassData_in.vPosition.xyz);	
	vec3 normal = normalize(vPassData_in.vNormals.xyz);										// (0)
	vec3 lightDir = normalize(uLightPos[arrayValue].xyz - vPassData_in.vPosition.xyz);		// (0)
	vec3 reflection = reflect(-lightDir, normal);									// (0)
	phong = lightDir.xyz;
	
																							
	vec4 diffuseAlbedo = texture(uTex_dm, vPassData_in.vTexcoord); 						// (0)
	vec4 specularAlbedo = texture(uTex_sm, vPassData_in.vTexcoord); 						// (0)
			
	
						   
	float attenuation = getAttenuation(uLightSz[arrayValue], uLightPos[arrayValue], vPassData_in.vPosition);	

	//float lightDistance = length(uLightPos[arrayValue] - vPassData_in.vPosition);
	//float attenuation =  1.0 / (1.0 + uLightSz[arrayValue] * pow(lightDistance, 2));
		
	vec3 diffuse = getDiffuse(normal, lightDir) * diffuseAlbedo.xyz;
	//vec3 diffuse = (max(dot(normal,lightDir),0.0)) * diffuseAlbedo.xyz;								
	
	vec3 specular = getSpecular(view, reflection) * specularAlbedo.xyz;																							
	//vec3 specular =  (pow(max(dot(view, reflection), 0.0), 2))* specularAlbedo.xyz;																							
																										// (0)
	phong =  attenuation  * ( diffuse + specular ) * uLightCol[arrayValue].xyz;							// (0)
	
	return phong;																						// (0)
																										// (0)
}
