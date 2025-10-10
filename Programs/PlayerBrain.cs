using Godot;
using System;

public partial class PlayerBrain : CharacterBody3D
{
	[Export]public float Speed = 5.0f;
	[Export] public float JumpVelocity = 4.5f;
	private PlayerMovement Movement;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Movement = new PlayerMovement(this,Speed,JumpVelocity);
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Movement.UpdateMovement(delta);
	}
	public override void _Input(InputEvent @event)
    {
        Movement.HandleInput(@event);
    }
}
