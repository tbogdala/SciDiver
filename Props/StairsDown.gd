extends StaticBody2D
class_name StairsDown

signal StairsDownUsed

# NOTE: trigger is set to be a oneshot 
func _on_StairsDown_AreaTrigger_area_entered(_area):
	pass # Replace with function body.
	emit_signal("StairsDownUsed")
	
func hide_and_disable():
	self.visible = false
	$CollisionShape2D.disabled = true
	$StairsDown_AreaTrigger/CollisionShape2D.disabled = true
	
func show_and_enable():
	self.visible = true
	$CollisionShape2D.disabled = false
	$StairsDown_AreaTrigger/CollisionShape2D.disabled = false
