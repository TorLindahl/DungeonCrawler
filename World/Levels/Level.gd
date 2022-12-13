extends Node

onready var startElevator: = $StartElevator
onready var endElevator: = $EndElevator

export(int) var nextLevel = 0

func _ready():
	startElevator.set_state( Elevator.OPEN )
	endElevator.set_state( Elevator.CLOSED )

func _on_DoorArea_body_entered(body):
	if body is Player:
		endElevator.set_state( Elevator.OPEN )

func _on_DoorArea_body_exited(body):
	if body is Player:
		endElevator.set_state( Elevator.CLOSED )

func _on_EndArea_body_entered(body):
	if body is Player:
		end_level()

func end_level():
	
	# go to next level
	if nextLevel != 0:
		var _val = get_tree().change_scene("res://World/Levels/Level" + str(nextLevel) + ".tscn" )
	else:
		print("end of game")
		# end of game
	
