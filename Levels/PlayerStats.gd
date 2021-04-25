extends Node
class_name PlayerStats

export var total_kills: int setget _set_total_kills
export var depth_travelled: int setget _set_depth_travelled

signal TotalKillsChanged
signal DepthTravelledChanged


func _ready():
	reset_stats()

	
func reset_stats():
	total_kills = 0
	depth_travelled = 0


func increment_total_kills():
	self.total_kills += 1
	
	
func increment_depth_travelled():
	self.depth_travelled += 1

func _set_total_kills(val):
	total_kills = val
	emit_signal("TotalKillsChanged", val)
	
func _set_depth_travelled(val):
	depth_travelled = val
	emit_signal("DepthTravelledChanged", val)
