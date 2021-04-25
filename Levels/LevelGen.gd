extends Node
class_name LevelGen

enum Directions {NORTH, EAST, SOUTH, WEST}

export var max_walk_length: int # max rooms for each walker to walk
export var max_rooms_total: int # max total rooms to generate
export var min_rooms_total: int # min total rooms to generate
export var branch_chance: int # 0..100 odds of walker branching
export var walker_branch_decay_rate: float # 0..1 how fast the branch_chance decays each walk

var _total_rooms_made: int
var _objective_placed: bool
var _last_node_processed: RoomTreeNode

class RoomTreeNode:
	var north: RoomTreeNode
	var east: RoomTreeNode
	var south: RoomTreeNode
	var west: RoomTreeNode
	
	# the room instance Node2D from the scene tree
	var room_inst: Room
	
	# set to true if this room should have the objective terminal spawned
	var has_objective_terminal: bool
	
	
# generates a level and returns the 'root' node where the player should spawn.
func generate_level_nodes() -> RoomTreeNode:
	assert(max_rooms_total > 0)
	assert(min_rooms_total > 0)
	assert(max_rooms_total > min_rooms_total)
	assert(max_walk_length > 0)
	
	var room = RoomTreeNode.new()
	_total_rooms_made = 0
	_objective_placed = false
	_process_node(room)
	
	# if we haven't placed the objective yet, place it at the last room made
	if _objective_placed == false:
		_last_node_processed.has_objective_terminal = true
		
	return room


func _process_node(node: RoomTreeNode):
	var dirs = []
	_last_node_processed = node
	
	if node.north == null:
		dirs.append(Directions.NORTH)
	if node.east == null:
		dirs.append(Directions.EAST)
	if node.south == null:
		dirs.append(Directions.SOUTH)
	if node.west == null:
		dirs.append(Directions.WEST)
	
	dirs.shuffle()
	
	# get the number of new rooms to create, limited by max total rooms
	var new_door_count = (randi() % (dirs.size()+1)) 
	if new_door_count + _total_rooms_made > max_rooms_total:
		new_door_count = max_rooms_total - _total_rooms_made
	
	# stop processing if we don't have any new doors to make
	if new_door_count < 1:
		if _total_rooms_made < min_rooms_total:
			new_door_count = 1
		else:
			return
		
	assert(new_door_count > 0)
	
	# loop over the number of rooms to create
	var culled_dirs = dirs.slice(0, new_door_count-1)
	for i in culled_dirs:
		match i:
			Directions.NORTH:
				node.north = RoomTreeNode.new()
				node.north.south = node
			Directions.EAST:
				node.east = RoomTreeNode.new()
				node.east.west = node
			Directions.SOUTH:
				node.south = RoomTreeNode.new()
				node.south.north = node
			Directions.WEST:
				node.west = RoomTreeNode.new()
				node.west.east = node
				
	_total_rooms_made += new_door_count
	culled_dirs.shuffle()
	for i in culled_dirs:
		match i:
			Directions.NORTH:
				node.north = RoomTreeNode.new()
				node.north.south = node
				_process_node(node.north)
			Directions.EAST:
				node.east = RoomTreeNode.new()
				node.east.west = node
				_process_node(node.east)
			Directions.SOUTH:
				node.south = RoomTreeNode.new()
				node.south.north = node
				_process_node(node.south)
			Directions.WEST:
				node.west = RoomTreeNode.new()
				node.west.east = node
				_process_node(node.west)
		

# Takes the RoomTreeNode and instances a new room and adds it to the level.
# If an instance already exists, it will get returned.
# NOTE: root should be a Level type object
func instance_room_to(root: Node2D, node: RoomTreeNode):
	var room: Room
	
	if node.room_inst != null:
		# get the room that was already instanced and reinsert it into the tree
		room = node.room_inst
		assert(room.is_inside_tree() == false)
		root.add_child(room)
	else:
		# create the instance of the selected room resource
		room = _get_room_scene_resource().instance()
		room.level = root
		node.room_inst = room
		root.add_child(room)
	
		# does it have the objective terminal? if so, spawn that in too
		# as well as a set of stairs
		if node.has_objective_terminal:
			var term: Node2D = _get_objective_terminal_resource().instance()
			room.add_child(term)
			term.global_position = Vector2(50, 58)
			
			var stairs: StairsDown = _get_stairs_down_resource().instance()
			stairs.hide_and_disable()
			room.add_child(stairs)
			stairs.global_position = Vector2(160, 112)
			var _err = stairs.connect("StairsDownUsed", root, "request_travel_down_stairs")
			assert(_err == OK)
	
	# show the doors for connected rooms
	room.enable_travel_areas(false)
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

func _get_stairs_down_resource() -> Resource:
	return load("res://Props/StairsDown.tscn")
	
func _get_objective_terminal_resource() -> Resource:
	return load("res://Props/HackingTerminal.tscn")
	
# returns the room resource to room instance. can be extended for theming
func _get_room_scene_resource() -> Resource:
	#return load("res://Levels/Designs/Dungeon-Stone-Room.tscn")
	return load("res://Levels/Designs/SciFi-Metal-Room.tscn")
