using Godot;
using System;

public partial class HelloWorld : MeshInstance3D
{
    public override void _Ready()
    {
        GD.Print("Hello World");
    }
}
