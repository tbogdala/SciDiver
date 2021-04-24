extends Node
class_name LevelGen

export var max_walk_length: int # max rooms for each walker to walk
export var max_rooms_total: int # max total rooms to generate
export var min_rooms_total: int # min total rooms to generate
export var branch_chance: float # 0..1 odds of walker branching

class RoomTreeNode:
	var north: RoomTreeNode
	var east: RoomTreeNode
	var south: RoomTreeNode
	var west: RoomTreeNode
	var room_inst: Node2D
	
# generates a level and returns the 'root' node where the player should spawn.
func generate_level_nodes() -> RoomTreeNode:
	var room = RoomTreeNode.new()
	room.north = RoomTreeNode.new()
	room.north.south = room
	return room

# Takes the RoomTreeNode and instances a new room and adds it to the level.
# If an instance already exists, it will get returned.
# NOTE: root should be a Level type object
func instance_room_to(root: Node2D, node: RoomTreeNode) -> Node2D:
	var room: Room
	
	if node.room_inst != null:
		# get the room that was already instanced and reinsert it into the tree
		room = node.room_inst
		assert(room.is_inside_tree() == false)
		root.add_child(room)
	else:
		# create the instance of the selected room resource
		var room_res = get_room_scene_to_instance()
		room = room_res.instance()
		room.level = root
		node.room_inst = room
		root.add_child(room)
	
	# show the doors for connected rooms
	# TODO: for now all doors will start open
	if node.north: 
		room.door_top.visible = true
		room.door_open_top()
	else:
		room.door_top.visible = false
		room.door_close_top()
		
	if node.east: 
		room.door_right.visible = true
		room.door_open_right()
	else:
		room.door_right.visible = false
		room.door_close_right()
		
	if node.south:
		room.door_bottom.visible = true
		room.door_open_bottom()
	else:
		room.door_bottom.visible = false
		room.door_close_bottom()
		
	if node.west: 
		room.door_left.visible = true
		room.door_open_left()
	else:
		room.door_left.visible = false
		room.door_close_left()
		
	return room

# returns the room resource to instance. can be extended for theming
func get_room_scene_to_instance() -> Resource:
	return load("res://Levels/Designs/Dungeon-Stone-Room.tscn")
