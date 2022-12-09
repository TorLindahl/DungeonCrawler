extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2(1,0)
export(int) var maxSpeed = 50

onready var anim: = $AnimationPlayer

func _ready():
	anim.play("IdleDown")

func _physics_process(_delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left","ui_right")
	input.y = Input.get_axis("ui_up","ui_down")
	
	if input != Vector2.ZERO:
		direction = input.normalized()
		velocity = direction * maxSpeed
	else:
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
	if direction.y > 0:
		anim.play("RunDown")
	elif direction.y < 0:
		anim.play("RunUp")
	else:
		if direction.x >= 0:
			anim.play("RunRight")
		else:
			anim.play("RunLeft")
	
