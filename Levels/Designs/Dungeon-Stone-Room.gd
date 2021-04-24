extends StaticBody2D


const PLAYER_NODE_NAME = "Player" # used for travel

var door_top: AnimatedSprite
var cs_door_top: CollisionShape2D
var door_bottom: AnimatedSprite
var cs_door_bottom: CollisionShape2D

var world: Node2D

func _ready():
	door_top = get_node("Door_Top")
	cs_door_top = get_node("CollisionShape_Door_Top")
	door_bottom = get_node("Door_Bottom")
	cs_door_bottom = get_node("CollisionShape_Door_Bottom")
	world = get_node("/root/World") 
	assert(world != null)

func _on_Door_top_TravelArea_area_entered(area):
	travel_to_room()

func door_open_top():
	door_top.animation = "Opening"
	cs_door_top.disabled = true
	
func door_open_bottom():
	door_bottom.animation = "Opening"
	cs_door_bottom.disabled = true
	
func travel_to_room():
	# instance an add a new room
	var new_room = load("res://Levels/Designs/Dungeon-Stone-Room.tscn").instance() 
	assert(new_room != null)
	
	# add the new room to the world and open the bottom door as a test
	world.add_child(new_room)
	new_room.door_open_bottom()
		
	# hard reset player position to bottom for the test
	var player = world.get_node(PLAYER_NODE_NAME)
	assert(player != null)
	player.set_global_position(Vector2(160,185))
	
	queue_free()
