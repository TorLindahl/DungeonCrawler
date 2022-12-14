extends Node

onready var startElevator: = $StartElevator
onready var endElevator: = $EndElevator
onready var healthSprite: = $Camera2D/CanvasLayer/Health
onready var camera: = $Camera2D
onready var player: = $Characters/Player
onready var anim: = $AnimationPlayer

export(int) var nextLevel = 0

func _ready():
	anim.play("FadeIn")
	anim.seek(0)
	startElevator.set_state( Elevator.OPEN )
	endElevator.set_state( Elevator.CLOSED )

func _physics_process(_delta):
	var h = int(GlobalVars.playerHealth/10)
	healthSprite.region_rect = Rect2( 1, 97, 19 + h*4, 6 )
	camera.transform = player.transform

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
	anim.play("FadeOut")
	anim.seek(0)

func switch_level():
	# go to next level
	if nextLevel != 0:
		var _val = get_tree().change_scene("res://World/Levels/Level" + str(nextLevel) + ".tscn" )
	else:
		print("end of game")
		# end of game

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		switch_level()
	elif anim_name == "FadeIn":
		player.set_state(Player.RUN)
