using Godot;
using System;
public partial class Player : CharacterBody3D
{
    [Export] 
    public float Speed { get; set; } = 5.0f; 
    [Export] 
    public float JumpVelocity { get; set; } = 4.5f;
    private PlayerMovement Movement;
    public override void _Ready()
    {
        Movement = new PlayerMovement(this, Speed, JumpVelocity); 
    }
    public override void _PhysicsProcess(double delta)
    {
        Movement.UpdateMovement(delta);
    }
}