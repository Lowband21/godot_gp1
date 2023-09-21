extends RigidBody2D

# Constants and Variables
var speed = 800
var jump_strength = 2000
var air_control = 0.5  # Between 0 and 1, where 1 is full control in the air, and 0 is no control.
var jump_count = 0
var max_jumps = 2  # Allows for double jump
var grounded_threshold = 0  # Linear velocity y threshold for considering the player as grounded

# Input
var movement_input = 0

# Returns true if the character is considered grounded.
func is_grounded():
	return $GroundCheck.is_colliding()

func _ready():
	self.gravity_scale = 6  # Adjust as necessary for the desired gravity effect

func _process(delta):
	movement_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	# Animation and flipping
	if abs(movement_input) > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = movement_input < 0
	else:
		$AnimatedSprite2D.play("up")
		

	
func _physics_process(delta):
	# Movement
	var control_factor = 1 if is_grounded() else air_control
	var target_velocity = Vector2(movement_input * speed, linear_velocity.y)
	linear_velocity = linear_velocity.lerp(target_velocity, control_factor)

	# Jumping logic
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		linear_velocity.y = -jump_strength  # Initial velocity for jump
		jump_count += 1

	if is_grounded() and linear_velocity.y > -1:  # Add a small threshold for y velocity to ensure character is descending or at rest.
		jump_count = 0  # Reset jump count when grounded

