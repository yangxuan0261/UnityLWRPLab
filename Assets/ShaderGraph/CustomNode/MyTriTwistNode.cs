using System.Reflection;
using UnityEngine;
using UnityEditor.ShaderGraph;

[Title("Procedural", "Noise", "MyTriTwistNode")]
public class MyTriTwistNode : CodeFunctionNode
{
    public MyTriTwistNode()
    {
        name = "MyTriTwistNode";
    }

    public override string documentationURL
    {
        get { return "https://blog.csdn.net/yangxuan0261"; }
    }

    protected override MethodInfo GetFunctionToConvert()
    {
        return GetType().GetMethod("TriTwistFunc", BindingFlags.Static | BindingFlags.NonPublic);
    }

    static string TriTwistFunc(
        [Slot(0, Binding.MeshUV0)] Vector2 UV,
        [Slot(1, Binding.None, 500f, 500f, 500f, 500f)] Vector1 Scale,
        [Slot(2, Binding.None)] out Vector1 Out)
    {
        return
            @"
{
        Out = step(UV.x, Scale);
}
";
    }

/* 已经找不到这个 虚函数了
    public override void GenerateNodeFunction(FunctionRegistry registry, GenerationMode generationMode)
        {
            registry.ProvideFunction("unity_noise_randomValue", s => s.Append(@"
    inline float unity_noise_randomValue (float2 uv)
    {
    return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
    }"));

            registry.ProvideFunction("unity_noise_interpolate", s => s.Append(@"
    inline float unity_noise_interpolate (float a, float b, float t)
    {
    return (1.0-t)*a + (t*b);
    }
    "));

            registry.ProvideFunction("unity_valueNoise", s => s.Append(@"
    inline float unity_valueNoise (float2 uv)
    {
    float2 i = floor(uv);
    float2 f = frac(uv);
    f = f * f * (3.0 - 2.0 * f);

    uv = abs(frac(uv) - 0.5);
    float2 c0 = i + float2(0.0, 0.0);
    float2 c1 = i + float2(1.0, 0.0);
    float2 c2 = i + float2(0.0, 1.0);
    float2 c3 = i + float2(1.0, 1.0);
    float r0 = unity_noise_randomValue(c0);
    float r1 = unity_noise_randomValue(c1);
    float r2 = unity_noise_randomValue(c2);
    float r3 = unity_noise_randomValue(c3);

    float bottomOfGrid = unity_noise_interpolate(r0, r1, f.x);
    float topOfGrid = unity_noise_interpolate(r2, r3, f.x);
    float t = unity_noise_interpolate(bottomOfGrid, topOfGrid, f.y);
    return t;
    }"));

            base.GenerateNodeFunction(registry, generationMode);
        }
    */

}
