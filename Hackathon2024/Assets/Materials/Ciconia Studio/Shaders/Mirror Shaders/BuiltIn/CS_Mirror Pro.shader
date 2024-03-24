Shader "Ciconia Studio/CS_Mirror/Builtin/Pro"
{
	Properties
	{
		[Space(35)][Header(Mirror Reflection________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_Intensity("Intensity", Float) = 1
		[HideInInspector]_ReflectionTex("ReflectionTex", 2D) = "black" {}
		[Space(35)][Header(Main Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GlobalXYTilingXYZWOffsetXY("Global --> XY(TilingXY) - ZW(OffsetXY)", Vector) = (1,1,0,0)
		_Color("Color", Color) = (0,0,0,1)
		[Toggle]_InvertABaseColor("Invert Alpha", Float) = 0
		_MainTex("Base Color", 2D) = "gray" {}
		_Saturation("Saturation", Range( -1 , 8)) = 0
		_Brightness("Brightness", Range( 1 , 8)) = 1
		[Toggle(_EXLUDEREFLECTIONFROMSATURATIONANDBRIGHTNESS_ON)] _ExludeReflectionfromSaturationandBrightness("Exlude Reflection from Saturation and Brightness", Float) = 0
		[Space(35)]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Intensity", Float) = 0.3
		_RefractionScale("Refraction", Float) = 0
		[Space(35)]_MetallicGlossMap("Mask Map  -->M(R) - Ao(G) - S(A)", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 2)) = 0
		_Glossiness("Smoothness", Range( 0 , 2)) = 0.5
		[Space(10)][KeywordEnum(MetallicAlpha,BaseColorAlpha)] _Source("Source", Float) = 0
		[Space(15)]_AoIntensity("Ao Intensity", Range( 0 , 2)) = 0
		[Space(35)][Header(Mask Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)][Toggle]_VisualizeDirt("Visualize Dirt", Float) = 0
		[Space(15)][Toggle]_InvertMask("Invert Mask", Float) = 0
		_DetailMask("Detail Mask", 2D) = "black" {}
		_IntensityMask("Intensity", Range( 0 , 1)) = 1
		[Space(15)]_ContrastDetailMap("Contrast", Float) = 0
		_SpreadDetailMap("Spread", Range( 0 , 1)) = 0.5
		[Space(35)][Header(Additional Reflection________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_ColorCubemap1("Color ", Color) = (1,1,1,1)
		[HDR]_Cubemap("Cubemap", CUBE) = "black" {}
		[Space(10)]_ReflectionIntensity("Intensity", Range( 0 , 10)) = 0.2
		_BlurReflection("Blur", Range( 0 , 7)) = 0.5
		[Space(15)]_ReflectionBlend("Reflection Blend", Range( 0 , 1)) = 0
		[Toggle]_InvertReflectionBlend("Invert", Float) = 0
		[Space(35)][Header(Dirt Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GlobalTODirt("Global --> XY(TilingXY) - ZW(OffsetXY)", Vector) = (1,1,0,0)
		[Space(15)]_DetailColor("Color", Color) = (1,1,1,0)
		_DetailAlbedoMap("Base Color", 2D) = "white" {}
		_DetailSaturation("Saturation", Float) = 0
		_DetailBrightness("Brightness", Range( 1 , 8)) = 1
		[Space(35)][Toggle]_BlendMainNormal("Blend Main Normal", Float) = 1
		_DetailNormalMap("Normal Map", 2D) = "bump" {}
		_DetailNormalMapScale("Scale", Float) = 0.3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[Space(35)]_DetailMetallicGlossMap("Metallic Map  -->(Smoothness A)", 2D) = "white" {}
		_DetailMetallic("Metallic", Range( 0 , 2)) = 0
		_DetailGlossiness("Smoothness", Range( 0 , 2)) = 0.5
		[Space(10)][KeywordEnum(MetallicAlpha,BaseColorAlpha)] _DetailSource("Source", Float) = 0
		[Space(15)][Toggle]_UseAoFromMainProperties("Use Ao From Main Properties", Float) = 1
		[Space(35)][Header(Broken Properties______________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Toggle(_ACTIVEBROKENMAP_ON)] _ActiveBrokenmap("Enable", Float) = 0
		[Space(15)]_BrokenColor("Color -->(Opacity A)", Color) = (1,1,1,1)
		_BrokenMapMaskA("Broken Map -->(Mask A)", 2D) = "black" {}
		_BrokenBrightness("Brightness", Float) = 1
		[Space(35)]_BrokenNormal("Broken Normal", 2D) = "bump" {}
		_BrokenBumpScale("Scale", Float) = 0.3
		_BrokenRefractionScale("Refraction", Float) = 0
		[Space(15)]_BrokenMetallic("Metalness", Range( 0 , 1)) = 1
		_BrokenSmoothness("Smoothness", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ACTIVEBROKENMAP_ON
		#pragma shader_feature_local _EXLUDEREFLECTIONFROMSATURATIONANDBRIGHTNESS_ON
		#pragma shader_feature_local _SOURCE_METALLICALPHA _SOURCE_BASECOLORALPHA
		#pragma shader_feature_local _DETAILSOURCE_METALLICALPHA _DETAILSOURCE_BASECOLORALPHA
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldRefl;
			INTERNAL_DATA
		};

		uniform float _BlendMainNormal;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float4 _GlobalXYTilingXYZWOffsetXY;
		uniform float _BumpScale;
		uniform sampler2D _DetailNormalMap;
		uniform float4 _DetailNormalMap_ST;
		uniform float4 _GlobalTODirt;
		uniform float _DetailNormalMapScale;
		uniform float _ContrastDetailMap;
		uniform float _InvertMask;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform float _SpreadDetailMap;
		uniform float _IntensityMask;
		uniform sampler2D _BrokenNormal;
		uniform float4 _BrokenNormal_ST;
		uniform float _BrokenBumpScale;
		uniform sampler2D _BrokenMapMaskA;
		uniform float4 _BrokenMapMaskA_ST;
		uniform float4 _BrokenColor;
		uniform float _VisualizeDirt;
		uniform float _Brightness;
		uniform sampler2D _ReflectionTex;
		uniform float _BrokenRefractionScale;
		uniform float _RefractionScale;
		uniform float _Intensity;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Saturation;
		uniform float _DetailBrightness;
		uniform float4 _DetailColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform float _DetailSaturation;
		uniform float _BrokenBrightness;
		uniform samplerCUBE _Cubemap;
		uniform float _BlurReflection;
		uniform float _ReflectionIntensity;
		uniform float4 _ColorCubemap1;
		uniform float _InvertReflectionBlend;
		uniform float _ReflectionBlend;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _Metallic;
		uniform sampler2D _DetailMetallicGlossMap;
		uniform float4 _DetailMetallicGlossMap_ST;
		uniform float _DetailMetallic;
		uniform float _BrokenMetallic;
		uniform float _Glossiness;
		uniform float _InvertABaseColor;
		uniform float _DetailGlossiness;
		uniform float _BrokenSmoothness;
		uniform float _UseAoFromMainProperties;
		uniform float _AoIntensity;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 break26_g1059 = uv_BumpMap;
			float GlobalTilingX79 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
			float GlobalTilingY78 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
			float2 appendResult14_g1059 = (float2(( break26_g1059.x * GlobalTilingX79 ) , ( break26_g1059.y * GlobalTilingY78 )));
			float GlobalOffsetX80 = _GlobalXYTilingXYZWOffsetXY.z;
			float GlobalOffsetY81 = _GlobalXYTilingXYZWOffsetXY.w;
			float2 appendResult13_g1059 = (float2(( break26_g1059.x + GlobalOffsetX80 ) , ( break26_g1059.y + GlobalOffsetY81 )));
			float3 tex2DNode4_g1058 = UnpackScaleNormal( tex2D( _BumpMap, ( ( appendResult14_g1059 + appendResult13_g1059 ) + float2( 0,0 ) ) ), _BumpScale );
			float3 temp_output_460_0 = tex2DNode4_g1058;
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			float2 break26_g1061 = uv_DetailNormalMap;
			float Global2TilingX237 = ( _GlobalTODirt.x - 1.0 );
			float Global2TilingY238 = ( _GlobalTODirt.y - 1.0 );
			float2 appendResult14_g1061 = (float2(( break26_g1061.x * Global2TilingX237 ) , ( break26_g1061.y * Global2TilingY238 )));
			float Global2OffsetX236 = _GlobalTODirt.z;
			float Global2OffsetY235 = _GlobalTODirt.w;
			float2 appendResult13_g1061 = (float2(( break26_g1061.x + Global2OffsetX236 ) , ( break26_g1061.y + Global2OffsetY235 )));
			float3 NormalDetail161 = UnpackScaleNormal( tex2D( _DetailNormalMap, ( appendResult14_g1061 + appendResult13_g1061 ) ), _DetailNormalMapScale );
			float clampResult63_g1062 = clamp( ( _ContrastDetailMap + 1.0 ) , 1.0 , 500.0 );
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			float4 tex2DNode27_g1062 = tex2D( _DetailMask, uv_DetailMask );
			float4 clampResult38_g1062 = clamp( CalculateContrast(clampResult63_g1062,( (( _InvertMask )?( ( 1.0 - tex2DNode27_g1062 ) ):( tex2DNode27_g1062 )) + (-1.0 + (_SpreadDetailMap - 0.0) * (1.05 - -1.0) / (1.0 - 0.0)) )) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_output_39_0_g1062 = ( clampResult38_g1062 * _IntensityMask );
			float4 Mask147 = temp_output_39_0_g1062;
			float3 lerpResult73 = lerp( temp_output_460_0 , NormalDetail161 , Mask147.rgb);
			float3 lerpResult74 = lerp( temp_output_460_0 , BlendNormals( temp_output_460_0 , NormalDetail161 ) , Mask147.rgb);
			float2 uv_BrokenNormal = i.uv_texcoord * _BrokenNormal_ST.xy + _BrokenNormal_ST.zw;
			float3 tex2DNode61_g1074 = UnpackScaleNormal( tex2D( _BrokenNormal, uv_BrokenNormal ), _BrokenBumpScale );
			float3 BrokenNormal441 = tex2DNode61_g1074;
			float2 uv_BrokenMapMaskA = i.uv_texcoord * _BrokenMapMaskA_ST.xy + _BrokenMapMaskA_ST.zw;
			float4 tex2DNode60_g1074 = tex2D( _BrokenMapMaskA, uv_BrokenMapMaskA );
			float BrokenMask446 = ( tex2DNode60_g1074.a * _BrokenColor.a );
			float3 lerpResult443 = lerp( (( _BlendMainNormal )?( lerpResult74 ):( lerpResult73 )) , BrokenNormal441 , BrokenMask446);
			#ifdef _ACTIVEBROKENMAP_ON
				float3 staticSwitch464 = lerpResult443;
			#else
				float3 staticSwitch464 = (( _BlendMainNormal )?( lerpResult74 ):( lerpResult73 ));
			#endif
			float3 Normal76 = staticSwitch464;
			o.Normal = Normal76;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 BrokenRefraction494 = ( tex2DNode61_g1074 * _BrokenRefractionScale );
			#ifdef _ACTIVEBROKENMAP_ON
				float4 staticSwitch463 = ( ase_screenPosNorm + float4( BrokenRefraction494 , 0.0 ) );
			#else
				float4 staticSwitch463 = ase_screenPosNorm;
			#endif
			float3 NormalRefractionLayer1456 = ( tex2DNode4_g1058 * _RefractionScale );
			float clampResult216 = clamp( _Intensity , 0.0 , 100.0 );
			float4 temp_output_54_0_g1065 = ( tex2Dlod( _ReflectionTex, float4( ( staticSwitch463 + float4( NormalRefractionLayer1456 , 0.0 ) ).xy, 0, 0.0) ) * clampResult216 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 break26_g1066 = uv_MainTex;
			float2 appendResult14_g1066 = (float2(( break26_g1066.x * GlobalTilingX79 ) , ( break26_g1066.y * GlobalTilingY78 )));
			float2 appendResult13_g1066 = (float2(( break26_g1066.x + GlobalOffsetX80 ) , ( break26_g1066.y + GlobalOffsetY81 )));
			float4 tex2DNode7_g1065 = tex2D( _MainTex, ( ( appendResult14_g1066 + appendResult13_g1066 ) + float2( 0,0 ) ) );
			float4 temp_output_20_0_g1065 = ( _Color * tex2DNode7_g1065 );
			#ifdef _EXLUDEREFLECTIONFROMSATURATIONANDBRIGHTNESS_ON
				float4 staticSwitch56_g1065 = temp_output_20_0_g1065;
			#else
				float4 staticSwitch56_g1065 = ( temp_output_54_0_g1065 + temp_output_20_0_g1065 );
			#endif
			float clampResult27_g1065 = clamp( _Saturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g1065 = staticSwitch56_g1065.xyz;
			float desaturateDot29_g1065 = dot( desaturateInitialColor29_g1065, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g1065 = lerp( desaturateInitialColor29_g1065, desaturateDot29_g1065.xxx, -clampResult27_g1065 );
			float4 temp_output_31_0_g1065 = CalculateContrast(_Brightness,float4( desaturateVar29_g1065 , 0.0 ));
			#ifdef _EXLUDEREFLECTIONFROMSATURATIONANDBRIGHTNESS_ON
				float4 staticSwitch57_g1065 = ( temp_output_54_0_g1065 + temp_output_31_0_g1065 );
			#else
				float4 staticSwitch57_g1065 = temp_output_31_0_g1065;
			#endif
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float2 break26_g1064 = uv_DetailAlbedoMap;
			float2 appendResult14_g1064 = (float2(( break26_g1064.x * Global2TilingX237 ) , ( break26_g1064.y * Global2TilingY238 )));
			float2 appendResult13_g1064 = (float2(( break26_g1064.x + Global2OffsetX236 ) , ( break26_g1064.y + Global2OffsetY235 )));
			float4 tex2DNode7_g1063 = tex2D( _DetailAlbedoMap, ( appendResult14_g1064 + appendResult13_g1064 ) );
			float clampResult27_g1063 = clamp( _DetailSaturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g1063 = ( _DetailColor * tex2DNode7_g1063 ).rgb;
			float desaturateDot29_g1063 = dot( desaturateInitialColor29_g1063, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g1063 = lerp( desaturateInitialColor29_g1063, desaturateDot29_g1063.xxx, -clampResult27_g1063 );
			float4 AlbedoDetail145 = CalculateContrast(_DetailBrightness,float4( desaturateVar29_g1063 , 0.0 ));
			float4 lerpResult143 = lerp( staticSwitch57_g1065 , AlbedoDetail145 , Mask147);
			float2 _Vector0 = float2(1,101);
			float4 temp_cast_14 = (_Vector0.x).xxxx;
			float4 temp_cast_15 = (_Vector0.y).xxxx;
			float4 clampResult42_g1074 = clamp( CalculateContrast(_BrokenBrightness,tex2DNode60_g1074) , temp_cast_14 , temp_cast_15 );
			float4 temp_output_20_0_g1074 = ( _BrokenColor * clampResult42_g1074 );
			float4 lerpResult424 = lerp( lerpResult143 , ( temp_output_20_0_g1074 * _BrokenColor.a ) , BrokenMask446);
			#ifdef _ACTIVEBROKENMAP_ON
				float4 staticSwitch462 = lerpResult424;
			#else
				float4 staticSwitch462 = lerpResult143;
			#endif
			float4 BaseColor114 = (( _VisualizeDirt )?( Mask147 ):( staticSwitch462 ));
			o.Albedo = BaseColor114.rgb;
			float4 texCUBENode27_g1071 = texCUBElod( _Cubemap, float4( normalize( WorldReflectionVector( i , Normal76 ) ), _BlurReflection) );
			float clampResult39_g1071 = clamp( _ReflectionIntensity , 0.0 , 100.0 );
			float4 clampResult60_g1071 = clamp( ( texCUBENode27_g1071 * ( texCUBENode27_g1071.a * clampResult39_g1071 ) * _ColorCubemap1 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float temp_output_57_0_g1071 = ( 1.0 - _ReflectionBlend );
			float4 temp_output_49_0_g1071 = Mask147;
			float lerpResult59_g1071 = lerp( temp_output_57_0_g1071 , 0.0 , temp_output_49_0_g1071.x);
			float lerpResult54_g1071 = lerp( 0.0 , temp_output_57_0_g1071 , temp_output_49_0_g1071.x);
			float4 Cubemap221 = ( clampResult60_g1071 * ( (( _InvertReflectionBlend )?( lerpResult54_g1071 ):( lerpResult59_g1071 )) + _ReflectionBlend ) );
			o.Emission = Cubemap221.rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float2 break26_g1070 = uv_MetallicGlossMap;
			float2 appendResult14_g1070 = (float2(( break26_g1070.x * GlobalTilingX79 ) , ( break26_g1070.y * GlobalTilingY78 )));
			float2 appendResult13_g1070 = (float2(( break26_g1070.x + GlobalOffsetX80 ) , ( break26_g1070.y + GlobalOffsetY81 )));
			float4 tex2DNode3_g1069 = tex2D( _MetallicGlossMap, ( ( appendResult14_g1070 + appendResult13_g1070 ) + float2( 0,0 ) ) );
			float2 uv_DetailMetallicGlossMap = i.uv_texcoord * _DetailMetallicGlossMap_ST.xy + _DetailMetallicGlossMap_ST.zw;
			float2 break26_g1068 = uv_DetailMetallicGlossMap;
			float2 appendResult14_g1068 = (float2(( break26_g1068.x * Global2TilingX237 ) , ( break26_g1068.y * Global2TilingY238 )));
			float2 appendResult13_g1068 = (float2(( break26_g1068.x + Global2OffsetX236 ) , ( break26_g1068.y + Global2OffsetY235 )));
			float4 tex2DNode3_g1067 = tex2D( _DetailMetallicGlossMap, ( appendResult14_g1068 + appendResult13_g1068 ) );
			float DetailMetallic176 = ( tex2DNode3_g1067.r * _DetailMetallic );
			float lerpResult179 = lerp( ( tex2DNode3_g1069.r * _Metallic ) , DetailMetallic176 , Mask147.r);
			float BrokenMetallic500 = ( tex2DNode60_g1074.a * _BrokenMetallic );
			float lerpResult498 = lerp( lerpResult179 , BrokenMetallic500 , BrokenMask446);
			#ifdef _ACTIVEBROKENMAP_ON
				float staticSwitch533 = lerpResult498;
			#else
				float staticSwitch533 = lerpResult179;
			#endif
			float Metallic151 = staticSwitch533;
			o.Metallic = Metallic151;
			float BaseColorAlpha122 = (( _InvertABaseColor )?( ( 1.0 - tex2DNode7_g1065.a ) ):( tex2DNode7_g1065.a ));
			#if defined(_SOURCE_METALLICALPHA)
				float staticSwitch23_g1069 = ( tex2DNode3_g1069.a * _Glossiness );
			#elif defined(_SOURCE_BASECOLORALPHA)
				float staticSwitch23_g1069 = ( _Glossiness * BaseColorAlpha122 );
			#else
				float staticSwitch23_g1069 = ( tex2DNode3_g1069.a * _Glossiness );
			#endif
			float DetailBaseColorAlpha163 = tex2DNode7_g1063.a;
			#if defined(_DETAILSOURCE_METALLICALPHA)
				float staticSwitch23_g1067 = ( tex2DNode3_g1067.a * _DetailGlossiness );
			#elif defined(_DETAILSOURCE_BASECOLORALPHA)
				float staticSwitch23_g1067 = ( _DetailGlossiness * DetailBaseColorAlpha163 );
			#else
				float staticSwitch23_g1067 = ( tex2DNode3_g1067.a * _DetailGlossiness );
			#endif
			float DetailSmoothness175 = staticSwitch23_g1067;
			float lerpResult181 = lerp( staticSwitch23_g1069 , DetailSmoothness175 , Mask147.r);
			float BrokenSmoothness488 = ( tex2DNode60_g1074.a * _BrokenSmoothness );
			float lerpResult489 = lerp( lerpResult181 , BrokenSmoothness488 , BrokenMask446);
			#ifdef _ACTIVEBROKENMAP_ON
				float staticSwitch534 = lerpResult489;
			#else
				float staticSwitch534 = lerpResult181;
			#endif
			float Smoothness152 = staticSwitch534;
			o.Smoothness = Smoothness152;
			float blendOpSrc34_g1069 = tex2DNode3_g1069.g;
			float blendOpDest34_g1069 = ( 1.0 - _AoIntensity );
			float temp_output_531_36 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc34_g1069 ) * ( 1.0 - blendOpDest34_g1069 ) ) ));
			float lerpResult266 = lerp( temp_output_531_36 , 1.0 , Mask147.r);
			float AmbientOcclusion268 = (( _UseAoFromMainProperties )?( temp_output_531_36 ):( lerpResult266 ));
			o.Occlusion = AmbientOcclusion268;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}