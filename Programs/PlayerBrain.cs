using Godot;
using System;
public partial class PlayerBrain : CharacterBody3D
{
	[Export] public float Speed = 5.0f;
	[Export] public float JumpVelocity = 4.5f;
	[Export] public NodePath RayCastPath { get; set; }
	private PlayerMovement Movement;
	//private PlayerInteract Interact;
	public override void _Ready()
	{
		Movement = new PlayerMovement(this, Speed, JumpVelocity);
		//Interact = new PlayerInteract(RayCastPath);
		//Interact._Ready();
		//Interact.check();
	}
	public override void _Process(double delta)
	{
		Movement.UpdateMovement(delta);
		//Interact.Update();
	}
	public override void _Input(InputEvent @event)
	{
		Movement.HandleInput(@event);
	}
}
//Godot C# is pain, maybe i should have started with gdscript 😭😭😭😭😭