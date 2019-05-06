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
	
	drawCurveSegment_gs4x.glsl
	Draw curve segment using interpolation algorithm.
*/
/* This file was modified by RJ Bourdelais with permission of the author.
We certify that this work is entirely our own.  The assessor of this
project may  reproduce  this  project  and  provide  copies  to
other  academic  staff, and/or communicate a copy of this project
to a plagiarism-checking service, which may retain a copy of the
project on its database*/


#version 410

// ****TO-DO: 
//	1) declare input varying data
//	2) declare uniform blocks
//	3) implement interpolation sampling function(s)
//	4) implement curve drawing function(s)
//	5) call choice curve drawing function in main

#define max_verts 32
#define max_waypoints 32

layout (points) in;
layout (line_strip, max_vertices = max_verts) out;

uniform mat4 uMVP;
flat in int vPassInstanceID[];	//(1)

uniform ubCurveWaypoint						//(2)
{											//(2)
	vec4 vCurveWaypoint[max_waypoints];		//(2)
} ubWaypoints;								//(2)

uniform ubCurveHandle						//(2)
{											//(2)
	vec4 vCurveHandle[max_verts];			//(2)
} ubHandles;								//(2)

vec4 interpolate(vec4 A, vec4 B, float t)	//(3)
{											//(3)
	//return mix(A, B, t);					//(3)
	return A + (t * (B - A));				//(3)
}

vec4 quadratic_bezier(vec4 A, vec4 B, vec4 C, float t)	//(4)
{														//(4)
	vec4 D = interpolate(A, B, t);						//(4)
	vec4 E = interpolate(B, C, t);						//(4)
	vec4 P = interpolate(D, E, t);						//(4)
	return P;											//(4)
}

vec4 cubic_bezier(vec4 A, vec4 B, vec4 C, vec4 D, float t)	//(4)
{															//(4)
	vec4 E = interpolate(A, B, t);							//(4)
	vec4 F = interpolate(B, C, t);							//(4)
	vec4 G = interpolate(C, D, t);							//(4)
	return quadratic_bezier(E, F, G, t);					//(4)
}

const float pi = 3.14159265359f;


void main()
{
	int index = vPassInstanceID[0];
	
	//first point
	gl_Position = uMVP * ubWaypoints.vCurveWaypoint[index];
	EmitVertex();

	//points in between
	for (float i = 1; i <= max_verts; i++)
	{
		float value = i / max_verts;	// interpolate point IE t 
		
		//(5)
		gl_Position = uMVP * cubic_bezier(ubWaypoints.vCurveWaypoint[index],
			ubWaypoints.vCurveWaypoint[index] + 0.4 *(ubWaypoints.vCurveWaypoint[index] + ubHandles.vCurveHandle[index]),
			ubWaypoints.vCurveWaypoint[index+  1] + 0.5 *(ubWaypoints.vCurveWaypoint[index + 1] - ubHandles.vCurveHandle[index + 1]),
			ubWaypoints.vCurveWaypoint[index + 1], value);
		
		EmitVertex();
	}
	
	//last point
	gl_Position = uMVP * ubWaypoints.vCurveWaypoint[index+1];
	EmitVertex();
	
	EndPrimitive();

}
