extends StaticBody2D
class_name Room

const PLAYER_NODE_NAME = "Player" # used for travel

var door_top: AnimatedSprite
var cs_door_top: CollisionShape2D
var cs_door_top_travel: CollisionShape2D
var door_right: AnimatedSprite
var cs_door_right: CollisionShape2D
var cs_door_right_travel: CollisionShape2D
var door_bottom: AnimatedSprite
var cs_door_bottom: CollisionShape2D
var cs_door_bottom_travel: CollisionShape2D
var door_left: AnimatedSprite
var cs_door_left: CollisionShape2D
var cs_door_left_travel: CollisionShape2D

var level # untyped to avoid cycle

var travelling = false

func _ready():
	door_top = get_node("Door_Top")
	cs_door_top = get_node("CollisionShape_Door_Top")
	cs_door_top_travel = door_top.get_node("Door_top_TravelArea/CollisionShape2D")
	assert(door_top != null and cs_door_top != null and cs_door_top_travel != null)
	door_right = get_node("Door_Right")
	cs_door_right = get_node("CollisionShape_Door_Right")
	cs_door_right_travel = door_right.get_node("Door_right_TravelArea/CollisionShape2D")
	assert(door_right != null and cs_door_right != null and cs_door_right_travel != null)
	door_bottom = get_node("Door_Bottom")
	cs_door_bottom = get_node("CollisionShape_Door_Bottom")
	cs_door_bottom_travel = door_bottom.get_node("Door_bottom_TravelArea/CollisionShape2D")
	assert(door_bottom != null and cs_door_bottom != null and cs_door_bottom_travel != null)
	door_left = get_node("Door_Left")
	cs_door_left = get_node("CollisionShape_Door_Left")
	cs_door_left_travel = door_left.get_node("Door_left_TravelArea/CollisionShape2D")
	assert(door_left != null and cs_door_left != null and cs_door_left_travel != null)

func enable_travel_areas(enable: bool):
	cs_door_top_travel.disabled = !enable
	cs_door_left_travel.disabled = !enable
	cs_door_bottom_travel.disabled = !enable
	cs_door_right_travel.disabled = !enable

func _on_Door_top_TravelArea_area_entered(_area):
	assert(level)
	if travelling: 
		return
	travelling = true
	level.call_deferred("request_travel_north")
	
	
func _on_Door_bottom_TravelArea_area_entered(_area):
	assert(level)
	if travelling: 
		return
	travelling = true
	level.call_deferred("request_travel_south")


func _on_Door_right_TravelArea_area_entered(_area):
	assert(level)
	if travelling: 
		return
	travelling = true
	level.call_deferred("request_travel_east")


func _on_Door_left_TravelArea_area_entered(_area):
	assert(level)
	if travelling: 
		return
	travelling = true
	level.call_deferred("request_travel_west")
	
	
func door_open_top():
	door_top.animation = "Opening"
	door_top.frame = 0
	door_top.playing = true
	cs_door_top.disabled = true
	cs_door_top_travel.disabled = false


func door_close_top():
	door_top.animation = "Closing"
	door_top.frame = 0
	door_top.playing = true
	cs_door_top.disabled = false
	cs_door_top_travel.disabled = true


func door_open_right():
	door_right.animation = "Opening"
	door_right.frame = 0
	door_right.playing = true
	cs_door_right.disabled = true
	cs_door_right_travel.disabled = false


func door_close_right():
	door_right.animation = "Closing"
	door_right.frame = 0
	door_right.playing = true
	cs_door_right.disabled = false
	cs_door_right_travel.disabled = true
	
	
func door_open_bottom():
	door_bottom.animation = "Opening"
	door_bottom.frame = 0
	door_bottom.playing = true
	cs_door_bottom.disabled = true
	cs_door_bottom_travel.disabled = false
	
	
func door_close_bottom():
	door_bottom.animation = "Closing"
	door_bottom.frame = 0
	door_bottom.playing = true
	cs_door_bottom.disabled = false
	cs_door_bottom_travel.disabled = true


func door_open_left():
	door_left.animation = "Opening"
	door_left.frame = 0
	door_left.playing = true
	cs_door_left.disabled = true
	cs_door_left_travel.disabled = false


func door_close_left():
	door_left.animation = "Closing"
	door_left.frame = 0
	door_left.playing = true
	cs_door_left.disabled = false
	cs_door_left_travel.disabled = true
	
