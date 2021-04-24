extends StaticBody2D
class_name Room

const PLAYER_NODE_NAME = "Player" # used for travel

var door_top: AnimatedSprite
var cs_door_top: CollisionShape2D
var door_bottom: AnimatedSprite
var cs_door_bottom: CollisionShape2D

var level # untyped to avoid cycle

func _ready():
	door_top = get_node("Door_Top")
	cs_door_top = get_node("CollisionShape_Door_Top")
	door_bottom = get_node("Door_Bottom")
	cs_door_bottom = get_node("CollisionShape_Door_Bottom")
	

func _on_Door_top_TravelArea_area_entered(_area):
	assert(level)
	level.call_deferred("request_travel_north")
	
func _on_Door_bottom_TravelArea_area_entered(area):
	assert(level)
	level.call_deferred("request_travel_south")
	
func door_open_top():
	door_top.animation = "Opening"
	cs_door_top.disabled = true

func door_close_top():
	door_top.animation = "Closing"
	cs_door_top.disabled = false
	
func door_open_bottom():
	door_bottom.animation = "Opening"
	cs_door_bottom.disabled = true
	
func door_close_bottom():
	door_bottom.animation = "Closing"
	cs_door_bottom.disabled = false
