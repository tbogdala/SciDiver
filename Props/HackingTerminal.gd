extends StaticBody2D
class_name HackingTerminal

onready var animated_sprite = $AnimatedSprite


# runs the animation for the terminal
func turn_on():
	animated_sprite.animation = "Running"
	animated_sprite.frame = 0
	animated_sprite.playing = true

func turn_off():
	animated_sprite.animation = "Off"
	animated_sprite.frame = 0
	animated_sprite.playing = false
