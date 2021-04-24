extends StaticBody2D
class_name Room

const PLAYER_NODE_NAME = "Player" # used for travel

var door_top: AnimatedSprite
var cs_door_top: CollisionShape2D
var door_right: AnimatedSprite
var cs_door_right: CollisionShape2D
var door_bottom: AnimatedSprite
var cs_door_bottom: CollisionShape2D
var door_left: AnimatedSprite
var cs_door_left: CollisionShape2D

var level # untyped to avoid cycle

func _ready():
	door_top = get_node("Door_Top")
	cs_door_top = get_node("CollisionShape_Door_Top")
	assert(door_top != null and cs_door_top != null)
	door_right = get_node("Door_Right")
	cs_door_right = get_node("CollisionShape_Door_Right")
	assert(door_right != null and cs_door_right != null)
	door_bottom = get_node("Door_Bottom")
	cs_door_bottom = get_node("CollisionShape_Door_Bottom")
	assert(door_bottom != null and cs_door_bottom != null)
	door_left = get_node("Door_Left")
	cs_door_left = get_node("CollisionShape_Door_Left")
	assert(door_left != null and cs_door_left != null)

func _on_Door_top_TravelArea_area_entered(_area):
	assert(level)
	level.call_deferred("request_travel_north")
	
func _on_Door_bottom_TravelArea_area_entered(_area):
	assert(level)
	level.call_deferred("request_travel_south")

func _on_Door_right_TravelArea_area_entered(_area):
	assert(level)
	level.call_deferred("request_travel_east")

func _on_Door_left_TravelArea_area_entered(_area):
	assert(level)
	level.call_deferred("request_travel_west")
	
func door_open_top():
	door_top.animation = "Opening"
	cs_door_top.disabled = true

func door_close_top():
	door_top.animation = "Closing"
	cs_door_top.disabled = false

func door_open_right():
	door_right.animation = "Opening"
	cs_door_right.disabled = true

func door_close_right():
	door_right.animation = "Closing"
	cs_door_right.disabled = false
	
func door_open_bottom():
	door_bottom.animation = "Opening"
	cs_door_bottom.disabled = true
	
func door_close_bottom():
	door_bottom.animation = "Closing"
	cs_door_bottom.disabled = false

func door_open_left():
	door_left.animation = "Opening"
	cs_door_left.disabled = true

func door_close_left():
	door_left.animation = "Closing"
	cs_door_left.disabled = false
	
