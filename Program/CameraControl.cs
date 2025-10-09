using Godot;
using System;
// Removed: using System.Numerics; (Avoids conflicts with Godot.Vector2/Vector3)

public partial class CameraControl : Camera3D
{
    // --- Exported Properties (Configuration) ---

    // Correct export style for Godot structs (must be public properties)
    [Export(PropertyHint.Range, "-1.57,1.57,0.01")] // Hint for a useful range: -90 to +90 degrees in radians
    public Vector2 RotationLimit { get; set; } = new Vector2(-Mathf.Pi / 2, Mathf.Pi / 2); // (Min, Max) Pitch in Radians
    
    [Export]
    public float Sensitivity { get; set; } = 0.005f; // Standard mouse sensitivity is very small
    
    [Export]
    public float MaxCamMoveFps { get; set; } = 15f; // Max velocity for clamping

    // Use NodePath for exporting node references
    [Export]
    public NodePath PlayerPath { get; set; } 

    // --- Private Fields (State) ---

    private CharacterBody3D _playerNode; // The actual reference to the player
    private float _pitch = 0f;          // Current accumulated vertical angle (Pitch/X-rotation)

    // --- Godot Lifecycle Methods ---

    public override void _Ready()
    {
        Input.MouseMode = Input.MouseModeEnum.Captured;

        // Get the Player Node reference from the exported path
        if (PlayerPath != null && !PlayerPath.IsEmpty)
        {
            // Cast to CharacterBody3D (assuming your player is this type)
            _playerNode = GetNode<CharacterBody3D>(PlayerPath);
        }
        else
        {
            GD.PrintErr("FATAL ERROR: PlayerPath not set for CameraControl!");
        }

        // Initialize pitch to the current camera rotation (prevents snapping)
        _pitch = Rotation.X;
    }

    public override void _Input(InputEvent @event)
    {
        // Must check if the player node exists before using it
        if (_playerNode == null) return;
        
        if (@event is InputEventMouseMotion mouseMotion)
        {
            // Get the mouse delta and scale it by sensitivity
            Vector2 delta = mouseMotion.Relative * Sensitivity;
            
            // ----------------------------------------------------------------------
            // PITCH (Vertical Look - Applied to Camera)
            // Mouse Y-axis movement (mouseMotion.Relative.Y) controls Pitch (X-rotation)
            // Standard FPS inverts Y-axis, so we add a negative sign:
            // ----------------------------------------------------------------------
            
            // Accumulate Pitch
            _pitch += -delta.Y; 
            
            // Clamp Pitch to prevent looking too far up/down or going upside-down
            _pitch = Mathf.Clamp(_pitch, RotationLimit.X, RotationLimit.Y);
            
            // Apply the pitch rotation to *this* Camera3D node
            Rotation = new Vector3(_pitch, 0, 0);

            // ----------------------------------------------------------------------
            // YAW (Horizontal Look - Applied to Player Body)
            // Mouse X-axis movement (mouseMotion.Relative.X) controls Yaw (Y-rotation)
            // ----------------------------------------------------------------------

            // Rotate the parent CharacterBody3D (Player) around the Y-axis
            // We use the simpler RotateY() method on the CharacterBody3D
            _playerNode.RotateY(-delta.X); 
            
            // NOTE: We do NOT multiply delta by frame time here. Mouse input is an
            // instantaneous delta, so it is frame-rate independent by nature.
        }
    }
    
    // _Process is no longer needed since we handle rotation directly in _Input.
    // However, if you wanted to smooth the rotation, you would accumulate delta in _Input
    // and apply the smooth rotation in _Process. For raw FPS controls, this is simpler:
    public override void _Process(double delta)
    {
        // Cleaned up _Process. Keep this blank or remove it if you don't need it for anything else.
    }
}