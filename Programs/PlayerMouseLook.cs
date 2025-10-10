using Godot;
using System;
public partial class PlayerMouseLook : Camera3D
{
    [Export] public NodePath PlayerNodePath { get; set; }
    private Node3D _playerNode;
    [Export] public float Sensitivity { get; set; } = 0.005f;
    [Export(PropertyHint.Range, "-1.57,0.0,0.01")]
    public Vector2 VertRotLimit { get; set; } = new Vector2(-Mathf.Pi / 2, Mathf.Pi / 2);
    [Export] public float MaxFps { get; set; } = 10f;
    public override void _Ready()
    {
        Input.MouseMode = Input.MouseModeEnum.Captured;
        if (PlayerNodePath != null && !PlayerNodePath.IsEmpty)
        {
            _playerNode = GetNode<Node3D>(PlayerNodePath);
        }
    }
    public override void _Input(InputEvent @event)
    {
        // Safety check
        if (_playerNode == null) return;
        if (@event is InputEventMouseMotion MouseMovement)
        {
            Vector2 velocity = MouseMovement.Relative * Sensitivity;
            velocity = new Vector2(
                Godot.Mathf.Clamp(velocity.X, -MaxFps, MaxFps),
                Godot.Mathf.Clamp(velocity.Y, -MaxFps, MaxFps)
            );
            Vector3 camRotation = Rotation;
            camRotation.X += -velocity.Y;
            camRotation.X = Godot.Mathf.Clamp(camRotation.X, VertRotLimit.X, VertRotLimit.Y);

            Rotation = camRotation;
            _playerNode.RotateY(-velocity.X);
        }
    }
}
// This piece of code was possible by watching Royas Godot's "Godot 4 C# FPS Controller" youtube tutorial and fixing errors that came up by asking Google Gemini about the said errors.
//i do not know why i would get errors when i followed all of the steps correctly, my guess would be Godot Version Differences (i am using a newer version (4.5)) but i've been wrong multiple times.