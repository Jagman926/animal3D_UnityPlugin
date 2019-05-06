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
	
	drawCurveHandles_gs4x.glsl
	Draw curve control values.
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
//	3) draw line between waypoint and handle
//	4) draw shape for handle (e.g. diamond)

#define max_verts 8
#define max_waypoints 32

layout (points) in;
layout (line_strip, max_vertices = max_verts) out;

uniform mat4 uMVP;
flat in int vPassInstanceID[]; //(1)

uniform ubCurveWaypoint					   //(2)
{										   //(2)
	vec4 vCurveWaypoint[max_waypoints];	   //(2)
} ubWaypoints;							   //(2)

uniform ubCurveHandle					   //(2)
{										   //(2)
	vec4 vCurveHandle[max_verts];		   //(2)
} ubHandles;							   //(2)

void main()
{
	int index = vPassInstanceID[0];
	
		//(3) draw handle line {								 //(3)
		gl_Position = uMVP *ubWaypoints.vCurveWaypoint[index];	 //(3)
		EmitVertex();											 //(3)
																 //(3)
		gl_Position = uMVP * ubHandles.vCurveHandle[index];		 //(3)
		EmitVertex();											 //(3)
																 //(3)
		EndPrimitive();											 //(3)
		//(3) }

		gl_Position = uMVP * (ubHandles.vCurveHandle[index] + vec4(-0.3, 0.0, 0.0, 0.0));	 //(4)
		EmitVertex();																		 //(4)
																							 //(4)
		gl_Position = uMVP * (ubHandles.vCurveHandle[index] + vec4(0.0, -0.3, 0.0, 0.0));	 //(4)
		EmitVertex();																		 //(4)
																							 //(4)
		gl_Position = uMVP * (ubHandles.vCurveHandle[index] + vec4(0.3, 0.0, 0.0, 0.0));	 //(4)
		EmitVertex();																		 //(4)
																							 //(4)
		gl_Position = uMVP * (ubHandles.vCurveHandle[index] + vec4(0.0, 0.3, 0.0, 0.0));	 //(4)
		EmitVertex();																		 //(4)
																							 //(4)
		gl_Position = uMVP * (ubHandles.vCurveHandle[index] + vec4(-0.3, 0.0, 0.0, 0.0));	 //(4)
		EmitVertex();
	
	EndPrimitive();
}
