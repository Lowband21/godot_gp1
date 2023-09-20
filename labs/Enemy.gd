extends RigidBody2D

const MOVE_FORCE = 2000
const TOLERANCE = 10  # A small speed under which the enemy is considered "stuck".

@export var start_point: Vector2
@export var end_point: Vector2

var move_direction = 1
var current_target

# Reference to the Timer node.
@onready var stuck_timer = $Timer

func _ready():
	start_point = position
	end_point = Vector2(position.x + 200, position.y)
	position = start_point
	current_target = end_point
	set_direction_towards_target()
	$AnimatedSprite2D.play()

	# Start the timer
	stuck_timer.start()

func set_direction_towards_target():
	move_direction = 1 if current_target.x > position.x else -1

func _physics_process(delta):
	# Apply continuous force towards the direction.
	apply_central_force(Vector2(move_direction * MOVE_FORCE, 0))

	# If heading right and reaches or overshoots the target
	if move_direction == 1 and position.x >= current_target.x - TOLERANCE:
		current_target = start_point
		set_direction_towards_target()
	# If heading left and reaches or overshoots the target
	elif move_direction == -1 and position.x <= current_target.x + TOLERANCE:
		current_target = end_point
		set_direction_towards_target()

	# If the enemy's speed drops below the tolerance, restart the timer.
	if abs(linear_velocity.x) < TOLERANCE:
		if stuck_timer.is_stopped():
			stuck_timer.start()
	else:
		stuck_timer.stop()

# This function gets called when the timer times out, indicating the enemy is "stuck".
func _on_Timer_timeout():
	# Reapply the movement.
	set_direction_towards_target()
	# Provide a burst of motion to get it moving again.
	apply_impulse(Vector2.ZERO, Vector2(move_direction * MOVE_FORCE, 0))
