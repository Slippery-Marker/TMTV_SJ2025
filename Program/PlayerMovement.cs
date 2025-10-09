using Godot;
using System;
public partial class PlayerMovement
{
    private Player _owner;
    private float _speed;
    private float _jumpVelocity;
    public PlayerMovement(Player owner, float speed, float jumpVelocity)
    {
        _owner = owner;
        _speed = speed;
        _jumpVelocity = jumpVelocity;
    }
    private float GetGravity()
    {
        return (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
    }
    public void UpdateMovement(double delta) 
    {
        Vector3 velocity = _owner.Velocity; 
        // Add the gravity.
        if (!_owner.IsOnFloor())
        {
            velocity.Y -= GetGravity() * (float)delta; 
        }
        if (Input.IsActionJustPressed("Jump") && _owner.IsOnFloor())
        {
            velocity.Y = _jumpVelocity; 
        }
        Vector2 inputDir = Input.GetVector("MRight", "MLeft", "MBackward", "MForward");
        Vector3 direction = (_owner.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
        if (direction != Vector3.Zero)
        {
            velocity.X = direction.X * _speed; 
            velocity.Z = direction.Z * _speed;
        }
        else
        {
            velocity.X = Mathf.MoveToward(_owner.Velocity.X, 0, _speed);
            velocity.Z = Mathf.MoveToward(_owner.Velocity.Z, 0, _speed);
        }
        _owner.Velocity = velocity;
        _owner.MoveAndSlide();
    }
}