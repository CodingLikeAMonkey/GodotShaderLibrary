using Godot;
using System;

public partial class Camera : Camera3D
{
    [Export(PropertyHint.Range, "0,10,0.01")]
    public float Sensitivity = 3.0f;

    [Export(PropertyHint.Range, "0,1000,0.1")]
    public float DefaultVelocity = 5.0f;

    [Export(PropertyHint.Range, "0,10,0.01")]
    public float SpeedScale = 1.17f;

    [Export(PropertyHint.Range, "1,100,0.1")]
    public float BoostSpeedMultiplier = 3.0f;

    [Export] public float MaxSpeed = 1000f;
    [Export] public float MinSpeed = 0.2f;

    private float _velocity;

    public override void _Ready()
    {
        _velocity = DefaultVelocity;
    }

    public override void _Input(InputEvent @event)
    {
        if (!Current)
            return;

        if (Input.MouseMode == Input.MouseModeEnum.Captured)
        {
            if (@event is InputEventMouseMotion motion)
            {
                Rotation = new Vector3(
                    Mathf.Clamp(Rotation.X - motion.Relative.Y / 1000f * Sensitivity, -Mathf.Pi / 2f, Mathf.Pi / 2f),
                    Rotation.Y - motion.Relative.X / 1000f * Sensitivity,
                    0
                );
            }
        }

        if (@event is InputEventMouseButton buttonEvent)
        {
            switch (buttonEvent.ButtonIndex)
            {
                case MouseButton.Right:
                    Input.MouseMode = buttonEvent.Pressed ? Input.MouseModeEnum.Captured : Input.MouseModeEnum.Visible;
                    break;

                case MouseButton.WheelUp:
                    _velocity = Mathf.Clamp(_velocity * SpeedScale, MinSpeed, MaxSpeed);
                    break;

                case MouseButton.WheelDown:
                    _velocity = Mathf.Clamp(_velocity / SpeedScale, MinSpeed, MaxSpeed);
                    break;
            }
        }
    }

    public override void _Process(double delta)
    {
        if (!Current)
            return;

        var direction = new Vector3(
            Convert.ToSingle(Input.IsPhysicalKeyPressed(Key.D)) - Convert.ToSingle(Input.IsPhysicalKeyPressed(Key.A)),
            Convert.ToSingle(Input.IsPhysicalKeyPressed(Key.E)) - Convert.ToSingle(Input.IsPhysicalKeyPressed(Key.Q)),
            Convert.ToSingle(Input.IsPhysicalKeyPressed(Key.S)) - Convert.ToSingle(Input.IsPhysicalKeyPressed(Key.W))
        ).Normalized();

        float speed = _velocity * (Input.IsPhysicalKeyPressed(Key.Shift) ? BoostSpeedMultiplier : 1f);

        Translate(direction * speed * (float)delta);
    }
}
