// When creating shaders for Lightweight Render Pipeline you can you the ShaderGraph which is super AWESOME!
// However, if you want to author shaders in shading language you can use this teamplate as a base.
// Please note, this shader does not match perfomance of the built-in LWRP Lit shader.
// This shader works with LWRP 5.7.2 version and above
Shader "Unlit/Template"
{
	Properties
	{
		[MainColor] _BaseColor("Color", Color) = (0.5,0.5,0.5,1)
	}

	SubShader
	{
		// With SRP we introduce a new "RenderPipeline" tag in Subshader. This allows to create shaders
		// that can match multiple render pipelines. If a RenderPipeline tag is not set it will match
		// any render pipeline. In case you want your subshader to only run in LWRP set the tag to
		// "LightweightPipeline"
		Tags{"RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline" "IgnoreProjector" = "True"}
		LOD 300

		// ------------------------------------------------------------------
		// Forward pass. Shades GI, emission, fog and all lights in a single pass.
		// Compared to Builtin pipeline forward renderer, LWRP forward renderer will
		// render a scene with multiple lights with less drawcalls and less overdraw.
		Pass
		{
			// "Lightmode" tag must be "LightweightForward" or not be defined in order for
			// to render objects.
			Name "StandardLit"
			Tags{"LightMode" = "LightweightForward"}

			Blend[_SrcBlend][_DstBlend]
			ZWrite[_ZWrite]
			Cull[_Cull]

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard SRP library
			// All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			#pragma vertex LitPassVertex
			#pragma fragment LitPassFragment
		
		#include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"

		struct Attributes
		{
			float4 positionOS   : POSITION;
			float2 uv           : TEXCOORD0;
			float2 uvLM         : TEXCOORD1;
		};

		struct Varyings
		{
			float2 uv                       : TEXCOORD0;
			float2 uvLM                     : TEXCOORD1;

		};

			Varyings LitPassVertex(Attributes input)
			{
				Varyings output;

				// VertexPositionInputs contains position in multiple spaces (world, view, homogeneous clip space)
				// Our compiler will strip all unused references (say you don't use view space).
				// Therefore there is more flexibility at no additional cost with this struct.
				VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);

				// TRANSFORM_TEX is the same as the old shader library.
				output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
				output.uvLM = input.uvLM.xy * unity_LightmapST.xy + unity_LightmapST.zw;

				return output;
			}

			half4 LitPassFragment(Varyings input) : SV_Target
			{
				// Surface data contains albedo, metallic, specular, smoothness, occlusion, emission and alpha
				// InitializeStandarLitSurfaceData initializes based on the rules for standard shader.
				// You can write your own function to initialize the surface data of your shader.
				SurfaceData surfaceData;
				InitializeStandardLitSurfaceData(input.uv, surfaceData);

				half3 color = 1;

				return half4(color, surfaceData.alpha);
			}
			ENDHLSL
			}
		}
		FallBack "Hidden/InternalErrorShader"

		// Uses a custom shader GUI to display settings. Re-use the same from Lit shader as they have the
		// same properties.
		CustomEditor "UnityEditor.Rendering.URP.LitShaderGUI"
}