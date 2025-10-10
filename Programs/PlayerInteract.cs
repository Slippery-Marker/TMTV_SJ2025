using Godot;
using System;
public partial class PlayerInteract : RayCast3D
{
	private NodePath NP{ get; set; }
	private RayCast3D RC3D;
	public PlayerInteract(NodePath _NP)
    {
		NP = _NP;
    }
	public override void _Ready()
	{
		if (NP != null && !NP.IsEmpty)
		{
			RC3D.GetNode<RayCast3D>(NP);
			RC3D.Enabled = true;
		}
	}
	public void check()
    {
        if (NP == null)
        {
            GD.PrintErr("Error: Failed to find RayCast3D with relative path!");
        }
    }
	public void Update()
	{
		RC3D.ForceRaycastUpdate();
		RC3D.ForceRaycastUpdate();
        if (RC3D.IsColliding())
		{
			GodotObject Collider = RC3D.GetCollider();
			if (Collider is Node Collidername)
			{
				GD.Print($"Raycast Hit {Collidername.Name}");
			}
            else
            {
				GD.Print($"Raycast Hit {Collider.GetType().Name}");
            }
			GD.Print(RC3D.GetCollider());
        }
    }
}
//i will surely kill people, THE FUCK IS THIS C# DOCUMENTATION GODOT!!!I CANT GET SHIT TO WORK!!!