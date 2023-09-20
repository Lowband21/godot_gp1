extends RigidBody2D

const SPEED = 300.0
const JUMP_FORCE = 700.0
const MOVE_FORCE = 4000.0

var screen_size # Size of the game window.
#var mode

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
    #mode = MODE_CHARACTER # Set mode to character to prevent rotations
    screen_size = get_viewport().size

func _physics_process(delta):
    var move_direction = 0

    # Input for movement
    if Input.is_action_pressed("move_right"):
        move_direction += 1
    if Input.is_action_pressed("move_left"):
        move_direction -= 1

    # Apply force for movement
    apply_central_force(Vector2(move_direction * MOVE_FORCE, 0))

    # Handle Jump
    if Input.is_action_just_pressed("ui_accept"):
        apply_central_impulse(Vector2(0, -JUMP_FORCE))

    # Animation
    if move_direction != 0:
        $AnimatedSprite2D.play()
    else:
        $AnimatedSprite2D.stop()
