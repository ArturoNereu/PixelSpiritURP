// When creating shaders for Lightweight Render Pipeline you can you the ShaderGraph which is super AWESOME!
// However, if you want to author shaders in shading language you can use this teamplate as a base.
// Please note, this shader does not match perfomance of the built-in LWRP Lit shader.
// This shader works with LWRP 5.7.2 version and above
Shader "PixelSpirit/01_Justice"
{
	Properties
	{
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
		LOD 300

		Pass
		{

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
		float2 uv           : TEXCOORD0;
	};

	struct Varyings
	{
		float2 uv                       : TEXCOORD0;
	};

		Varyings LitPassVertex(Attributes input)
		{
			Varyings output;

			
			// TRANSFORM_TEX is the same as the old shader library.
			output.uv = input.uv;

			return output;
		}

		half4 LitPassFragment(Varyings input) : SV_Target
		{

			half3 color = 1;

			return half4(1,1,1, 1);
		}
		ENDHLSL
		}
	}
		FallBack "Hidden/InternalErrorShader"

			// Uses a custom shader GUI to display settings. Re-use the same from Lit shader as they have the
			// same properties.
			CustomEditor "UnityEditor.Rendering.URP.LitShaderGUI"
}