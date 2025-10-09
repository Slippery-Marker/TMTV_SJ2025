using Godot;
using System;

public partial class Player : CharacterBody3D
{
	private PlayerMovement Movement;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        Movement= new PlayerMovement(this);
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
    {
		Movement.UpdateMovement(delta);
    }
}
