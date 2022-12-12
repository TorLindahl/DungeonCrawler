extends KinematicBody2D
class_name Player

var velocity = Vector2.ZERO
var direction = Vector2(1,0)
export(int) var maxSpeed = 3000

onready var anim: = $AnimationPlayer

func _ready():
	anim.play("IdleDown")

func _physics_process(deltaTime):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left","ui_right")
	input.y = Input.get_axis("ui_up","ui_down")
	
	if input != Vector2.ZERO:
		direction = input.normalized()
		velocity = direction * maxSpeed * deltaTime
	else:
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
	if velocity == Vector2.ZERO:
		if direction.y > 0:
			anim.play("IdleDown")
		elif direction.y < 0:
			anim.play("IdleUp")
		else:
			if direction.x >= 0:
				anim.play("IdleRight")
			else:
				anim.play("IdleLeft")
	else:
		if direction.y > 0:
			anim.play("RunDown")
		elif direction.y < 0:
			anim.play("RunUp")
		else:
			if direction.x >= 0:
				anim.play("RunRight")
			else:
				anim.play("RunLeft")
	
func _on_Area2D_body_entered(body):
	if body is Enemy:
		body.player_hit(100)
	
	
	pass
	
