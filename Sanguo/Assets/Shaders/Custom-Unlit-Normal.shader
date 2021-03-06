// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Custom/Unlit Color" {
Properties {
 	_Color ("Tint", Color) = (1, 1, 1, 1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
	Tags 
		{ 
            "Queue"="Transparent" 
            "IgnoreProjector"="True"
            "RenderType"="Opaque" 
        }

	Cull Off 
    Lighting Off 
    Fog { Mode Off }
    Blend SrcAlpha OneMinusSrcAlpha
        
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord) * i.color * _Color;
				col.a = _Color.a;
				return col;
			}
		ENDCG
	}
}

}
