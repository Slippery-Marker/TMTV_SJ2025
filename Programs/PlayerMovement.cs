using Godot;
using System;
public class PlayerMovement
{
    private PlayerBrain _player;
    private float _speed;
    private float _jumpVelocity;
    public PlayerMovement(PlayerBrain player, float speed, float jumpVelocity)
    {
        _player = player;
        _speed = speed;
        _jumpVelocity = jumpVelocity;
    }
    private float GetGravity()
    {
        return (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
    }
    public void UpdateMovement(double delta)
    {
        Vector3 velocity = _player.Velocity;
        // Add the gravity.
        if (!_player.IsOnFloor())
        {
            velocity.Y -= GetGravity() * (float)delta;
        }
        if (Input.IsActionJustPressed("Jump") && _player.IsOnFloor())
        {
            velocity.Y = _jumpVelocity;
        }
        Vector2 inputDir = Input.GetVector("Leftward", "Rightward", "Forward", "Backward");
        Vector3 direction = (_player.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
        if (direction != Vector3.Zero)
        {
            velocity.X = direction.X * _speed;
            velocity.Z = direction.Z * _speed;
        }
        else
        {
            velocity.X = Mathf.MoveToward(_player.Velocity.X, 0, _speed);
            velocity.Z = Mathf.MoveToward(_player.Velocity.Z, 0, _speed);
        }
        _player.Velocity = velocity;
        _player.MoveAndSlide();
    }
    public void HandleInput(InputEvent @event)
    {
        if (@event.IsActionPressed("Exit"))
        {
            _player.GetTree().Quit();
        }
    }
}