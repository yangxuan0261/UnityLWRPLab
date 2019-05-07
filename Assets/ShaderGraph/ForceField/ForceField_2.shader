Shader "test/ForceField_2"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_RimStrength("RimStrength",Range(0, 10)) = 2
		_IntersectPower("IntersectPower", Range(0, 3)) = 2
	}

	SubShader
	{
		ZWrite Off
		Cull Off
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

			float _RimStrength;
			float _IntersectPower;

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

			fixed4 _Color;


			fixed4 frag(v2f i) : SV_Target
			{
				//获取已有的深度信息,此时的深度图里没有力场的信息
				//判断相交
				float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
				float partZ = i.screenPos.z;

				float diff = sceneZ - partZ;
				float intersect = (1 - diff) * _IntersectPower;

				//圆环
				float rim = 1 - abs(dot(i.normal, normalize(i.viewDir))) * _RimStrength;
				float glow = max(intersect, rim);
				float dtVal = smoothstep(0, 1, intersect);

				fixed4 col = _Color;
				col.a = dtVal + rim;
				return col;
			}

			ENDCG
		}
	}
}