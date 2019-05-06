using System.Reflection;
using UnityEditor.ShaderGraph;
using UnityEngine;

[Title("Custom", "My Custom Node1")] // 创建节点时 节点所在的组
public class MyCustomNode : CodeFunctionNode {
    public MyCustomNode() {
        name = "My Custom Node2";
    }

    protected override MethodInfo GetFunctionToConvert() {
        return GetType().GetMethod("MyCustomFunction",
            BindingFlags.Static | BindingFlags.NonPublic);
    }

    static string MyCustomFunction(
        [Slot(0, Binding.None)] DynamicDimensionVector A, [Slot(1, Binding.None)] DynamicDimensionVector B, [Slot(2, Binding.None)] out DynamicDimensionVector Out) {
        return @"
{
	Out = A + B;
} 
";
    }
}