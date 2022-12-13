extends Node2D
class_name Elevator

enum {
	OPEN,
	CLOSED
}

onready var anim: = $AnimationPlayer

var state = CLOSED

func _ready():
	anim.play("CloseDoor")
	anim.seek(0)

func set_state( newstate ):
	if newstate == state:
		return
	state = newstate
	
	if state == OPEN:
		anim.play("OpenDoor")
		anim.seek(0)
	elif state == CLOSED:
		anim.play("CloseDoor")
		anim.seek(0)


