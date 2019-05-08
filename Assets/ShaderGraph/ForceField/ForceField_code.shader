Shader "test/ForceField_2"
{
	Properties
	{
		_Offset("Offset", Range(0, 3)) = 2
		_FresnelPower("FresnelPower",Range(0, 10)) = 2
		_MainColor("MainColor", Color) = (0,0,0,0)
	}

	SubShader
	{
		ZWrite Off
		// Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

		Tags
		{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}

		Pass
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD3;
			};

			float _FresnelPower;
			float _Offset;
			fixed4 _MainColor;

			sampler2D _CameraDepthTexture;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				COMPUTE_EYEDEPTH(o.screenPos.z);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));
				return o;
			}



			fixed4 frag(v2f i) : SV_Target
			{
				//获取已有的深度信息,此时的深度图里没有力场的信息
				//判断相交
				float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
				float partZ = i.screenPos.w - _Offset;

				float intersect = 1 - (sceneZ - partZ);

				//圆环
				float rim = pow((1.0 - saturate(dot(normalize(i.normal), normalize(i.viewDir)))), _FresnelPower);
				float smoothVal = smoothstep(0, 1, intersect);

				_MainColor.a = smoothVal + rim;
				return _MainColor;
			}

			ENDCG
		}
	}
}