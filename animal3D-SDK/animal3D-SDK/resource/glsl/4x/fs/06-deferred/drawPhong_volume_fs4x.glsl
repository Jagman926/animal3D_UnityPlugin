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
	
	drawPhong_volume_fs4x.glsl
	Perform Phong shading for a single light within a volume; output 
		components to MRT.
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
//	2) declare varyings for light volume geometry
//		-> biased clip-space position, index
//	3) declare uniform blocks
//		-> implement data structure matching data in renderer
//		-> replace old lighting uniforms with new block
//	4) declare multiple render targets
//		-> diffuse lighting, specular lighting
//	5) compute screen-space coordinate for current light
//	6) retrieve new geometric inputs (no longer from varyings)
//		-> *test by outputting as color
//	7) use new inputs where appropriate in lighting
//		-> remove anything that can be deferred further


vec4 phongReflection(int arrayValue, vec3 normals, vec4 position, vec2 texCoord);	//(0)
float getDiffuse(vec3 normal, vec3 lightDir);	//(0)
float getSpecular(vec3 view, vec3 reflection);	//(0)
float getAttenuation(float lightSize, vec4 lightPosition, vec4 position);	//(0)

layout (location = 0) out vec4 rtDiffuse;	//(4)
layout (location = 1) out vec4 rtSpecular;	//(4)

uniform sampler2D uImage4; //position	(1)
uniform sampler2D uImage5; //normal	(1)
uniform sampler2D uImage6; //texcoord	(1)
uniform sampler2D uImage7; //depth	(1)



//(2)
in vec4 vPassBiasClipCoord;
flat in int vPassInstanceID;

struct sPointLight
{
		vec4 worldPos;					
		vec4 viewPos;			
		vec4 color;				
		float radius;			
		float radiusInvSq;		
		float pad[2];			
};

//(3)
#define max_lights 1024
uniform ubPointLight
{
			sPointLight uPointLight[max_lights];	
};

void main()
{
	// DUMMY OUTPUT: all fragments are FADED MAGENTA
	//rtFragColor = vec4(1.0, 0.5, 1.0, 1.0);
	//rtDiffuse = uPointLight[vPassInstanceID].color;

	vec4 texcoord = vPassBiasClipCoord / vPassBiasClipCoord.w;	// (5)

	vec4 gPosition = texture(uImage4, texcoord.xy);	//(2)
	vec4 gNormal = texture(uImage5, texcoord.xy);	//(2)
	vec2 gTexcoord = texture(uImage6, texcoord.xy).xy;	//(2)

	//rtDiffuse = gPosition;// (6*)
	//rtDiffuse = gNormal;// (6*)
	//rtDiffuse = vec4 (gTexcoord.xy, 0.0, 1.0); // (6*)
	
	
	vec3 normal = normalize(gNormal.xyz);														 // (0)
	vec3 lightDir = normalize(uPointLight[vPassInstanceID].viewPos.xyz - gPosition.xyz);		// (0)
	vec3 reflection = reflect(-lightDir, normal);											   // (0)
												
	float attenuation = getAttenuation(uPointLight[vPassInstanceID].radius, uPointLight[vPassInstanceID].viewPos, gPosition);	 //(0)

	float diffuse = getDiffuse(normal, lightDir) ;	//(0)
																									
	
	float specular = getSpecular(lightDir, reflection);		//(0)																					
										
	rtDiffuse = ( diffuse *  uPointLight[vPassInstanceID].color ) * attenuation; //(7)
	rtSpecular =  ( specular *  uPointLight[vPassInstanceID].color ) * attenuation;	//(7)
	rtDiffuse = vec4(rtDiffuse.rgb, 1.0);	//(7)
	rtSpecular = vec4(rtSpecular.rgb, 1.0);	//(7)
	
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

float lightDistance = length(lightPosition.xyz - position.xyz);
float attenuation = smoothstep(lightSize, 0, lightDistance);
return attenuation;

}
