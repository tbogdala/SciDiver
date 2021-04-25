extends KinematicBody2D

enum States {IDLE, MOVE, ATTACK}

export(int) var MAX_SPEED = 140

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

var _current_state = States.IDLE
var velocity = Vector2.ZERO

func _ready():
	animation_state.start("Idle")

# NOTE: input wasn't handled on the _input() event because it seemed to queue
# up while switching rooms and altered the position of the player when it should
# have been disabled.

func _physics_process(_delta):
	if Input.is_action_just_pressed("player_hack"):
		for area in $PlayerTriggerArea.get_overlapping_areas():
			if area.name == "HackingArea":
				var level: Level = get_node("/root/World") as Level
				level.start_hacking_terminal()

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	input_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	input_vector = input_vector.normalized()
			
	if input_vector != Vector2.ZERO and self.visible:
		if _current_state == States.IDLE:
			_to_state(States.MOVE)
		
		velocity = input_vector * MAX_SPEED 
	else:
		if _current_state == States.MOVE:
			_to_state(States.IDLE)
			velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("player_attack_melee"):
		_to_state(States.ATTACK)
		
	match _current_state:
		States.IDLE:
			pass
			
		States.MOVE:
			animation_tree.set("parameters/Idle/blend_position", input_vector)
			animation_tree.set("parameters/Run/blend_position", input_vector)
			animation_tree.set("parameters/Attack/blend_position", input_vector)	
	
			velocity = move_and_slide(velocity)
			
		States.ATTACK:
			pass
			
			
func _to_state(new_state):
	match new_state:
		States.IDLE:
			animation_state.travel("Idle")
			
		States.MOVE:
			animation_state.travel("Run")
				
		States.ATTACK:
			animation_state.travel("Attack")
		
		_: 
			print("unknown state in player's state machine code")
		
	_current_state = new_state
	
	
func _attack_melee_finished():
	_to_state(States.IDLE)
