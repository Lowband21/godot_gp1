extends RigidBody2D

var speed = 500
var movement_input = 0

func _process(delta):
	movement_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Update animation
	if movement_input != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

	# Flip character
	if movement_input > 0:
		$AnimatedSprite2D.flip_h = false
	elif movement_input < 0:
		$AnimatedSprite2D.flip_h = true
	
func _integrate_forces(state):
	var applied_velocity = Vector2()
	applied_velocity.x = movement_input * speed
	state.linear_velocity = applied_velocity

func _on_body_entered(body):  # optional, if you need collision logic
	# Handle collision logic here
	pass
