cbuffer cb : register(b0)
{
	float4x4 mvp; // MVP行列
	float4 mulColor; // 乗算カラー
};

struct VSInput
{
	float4 pos : POSITION;
	float2 uv : TEXCOORD0;
};

struct PSInput
{
	float4 pos : SV_POSITION;
	float2 uv : TEXCOORD0;
};

Texture2D<float4> sceneTexture : register(t0); // シーンテクスチャ
sampler Sampler : register(s0);

PSInput VSMain(VSInput In)
{
	PSInput psIn;
	psIn.pos = mul(mvp, In.pos);
	psIn.uv = In.uv;
	return psIn;
}

float4 PSMain(PSInput In) : SV_Target0
{
	float4 color = sceneTexture.Sample(Sampler, In.uv);

    // step-7 ピクセルカラーをモノクロ化する
	/*
	float Y = 0.299f * color.r + 0.587f * color.g + 0.114f * color.b;
	color.r = Y;
	color.g = Y;
	color.b = Y;
	*/
	
	// 赤のモノクロ
	/*
	float Y = 0.299f * color.r + 0.587f * color.g + 0.114f * color.b;
	color.r = Y * 1.0f;
	color.g = Y * 0.0f;
	color.b = Y * 0.0f;
	*/

	// 階調の反転
	/*
	color.r = 1.0f - color.x;
	color.g = 1.0f - color.y;
	color.b = 1.0f - color.z;
	*/
	
	// ソラリゼーション
	color.r = (color.r * 2 - 1) * (color.r * 2 - 1);
	color.g = (color.g * 2 - 1) * (color.g * 2 - 1);
	color.b = (color.b * 2 - 1) * (color.b * 2 - 1);

	return color;
}
