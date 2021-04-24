extends KinematicBody2D

export(int) var MAX_SPEED = 140

var velocity = Vector2.ZERO

# NOTE: input wasn't handled on the _input() event because it seemed to queue
# up while switching rooms and altered the position of the player when it should
# have been disabled.

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	input_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO and self.visible:
		velocity = input_vector * MAX_SPEED 
	else:
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
