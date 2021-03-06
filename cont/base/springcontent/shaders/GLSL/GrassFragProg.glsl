#version 410 core

uniform sampler2D shadingTex;
uniform sampler2D grassShadingTex;
uniform sampler2D bladeTex;

#ifdef HAVE_SHADOWS
uniform sampler2DShadow shadowMap;
uniform float groundShadowDensity;
#endif
uniform float infoTexIntensityMul;

#ifdef HAVE_INFOTEX
uniform sampler2D infoMap;
#endif

uniform samplerCube specularTex;
uniform vec3 specularLightColor;
uniform vec3 ambientLightColor;
uniform vec3 camDir;
uniform vec4 fogColor;


in vec3 wsNormal;
in vec4 shadingTexCoords;
in vec2 bladeTexCoords;
in vec3 ambientDiffuseLightTerm;
#if defined(HAVE_SHADOWS) || defined(SHADOW_GEN)
in vec4 shadowTexCoords;
#endif

in float fogFactor;

layout(location = 0) out vec4 fragColor;


void main() {
#ifdef SHADOW_GEN
	{
		fragColor = vec4(1.0);
		return;
	}
#endif

	vec4 matColor = texture(bladeTex, bladeTexCoords);

	matColor.rgb *= texture(grassShadingTex, shadingTexCoords.pq).rgb;
	matColor.rgb *= texture(shadingTex, shadingTexCoords.st).rgb * 2.0;


	vec3 reflectDir = reflect(camDir, normalize(wsNormal));
	vec3 specular   = texture(specularTex, reflectDir).rgb;

	// TODO: make specular distr. customizable?
	fragColor.rgb = matColor.rgb * ambientDiffuseLightTerm + 0.1 * specular * specularLightColor;
	fragColor.a   = matColor.a;

#ifdef HAVE_SHADOWS
	float shadowCoeff = mix(1.0, textureProj(shadowMap, shadowTexCoords), groundShadowDensity);

	fragColor.rgb *= mix(ambientLightColor, vec3(1.0), shadowCoeff);
#endif

#ifdef HAVE_INFOTEX
	fragColor.rgb += (texture(infoMap, shadingTexCoords.st).rgb * infoTexIntensityMul);
	fragColor.rgb -= (vec3(0.5, 0.5, 0.5) * float(infoTexIntensityMul == 1.0));
#endif

	fragColor.rgb = mix(fogColor.rgb, fragColor.rgb, fogFactor);
}

