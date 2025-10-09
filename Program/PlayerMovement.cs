using Godot;
using System;

public class PlayerMovement
{
	private Player _owner;
	public const float Speed = 5.0f;
	public const float JumpVelocity = 4.5f;

	public PlayerMovement(Player owner)
	{
		_owner = owner;
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
			Vector3 gravity_vector = Vector3.Down * GetGravity() * (float)delta;
			velocity += gravity_vector;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("Jump") && _owner.IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		// Get the input direction and handle the movement/deceleration.
		Vector2 inputDir = Input.GetVector("MRight", "MLeft", "MBackward", "MForward");
		Vector3 direction = (_owner.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(_owner.Velocity.X, 0, Speed);
			velocity.Z = Mathf.MoveToward(_owner.Velocity.Z, 0, Speed);
		}

		_owner.Velocity = velocity;
		_owner.MoveAndSlide();
	}
}
