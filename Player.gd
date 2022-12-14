extends KinematicBody2D
class_name Player

enum {
	START,
	RUN,
	ATTACK,
	HIT,
	DIE
}

var velocity = Vector2.ZERO
var direction = Vector2(1,0)
export(int) var maxSpeed = 3000
var state = RUN

var hitTime = 0.0
var knockBackTime = 0.0

onready var sprite: = $Sprite
onready var anim: = $AnimationPlayer
onready var blood: = $Particles2D

func _ready():
	restart()

func restart():
	position = Vector2.ZERO
	anim.play("IdleRight")
	GlobalVars.playerHealth = 30
	set_state(START)
	blood.emitting = false
	sprite.visible = true		
	knockBackTime = 0.0
	hitTime = 0.0
	direction = Vector2(1,0)
	velocity = Vector2.ZERO

func _physics_process(deltaTime):
	if state == RUN:
		run_state(deltaTime)
	elif state == ATTACK:
		attack_state(deltaTime)
	elif state == HIT:
		hit_state(deltaTime)
	elif state == START:
		start_state(deltaTime)

func set_state(newstate):
	if newstate == ATTACK:
		sprite.visible = true
		anim.play("Attack" + get_direction_string() )
		anim.seek(0)
	elif newstate == HIT:
		anim.play("Idle" + get_direction_string() )
		anim.seek(0)
		hitTime = 2.0
		blood.emitting = true
	elif newstate == RUN:
		sprite.visible = true
	elif newstate == DIE:
		sprite.visible = true		
		anim.play("Die")
		anim.seek(0)
	elif newstate == START:
		sprite.visible = true
	state = newstate

func take_hit( hitvalue ):
	if state == HIT or state == DIE or hitTime > 0.0:
		return
	GlobalVars.deductPlayerHealth( hitvalue )
	if GlobalVars.playerHealth > 0:
		set_state(HIT)
	else:
		set_state(DIE)


func run_state(deltaTime):
	move(deltaTime)

	if velocity == Vector2.ZERO:
		anim.current_animation = ("Idle" + get_direction_string() )
	else:
		anim.current_animation = ("Run" + get_direction_string() )

	if Input.is_action_just_pressed("primary_attack"):
		set_state( ATTACK )
	
func start_state(_deltaTime):
	pass
	
func attack_state(_deltaTime):
	pass
	
func hit_state(deltaTime):

	move(deltaTime)

	if velocity == Vector2.ZERO:
		anim.current_animation = ("Idle" + get_direction_string() )
	else:
		anim.current_animation = ("Run" + get_direction_string() )

	# count down hit time. flash while in HIT state, and return to RUN after	
	hitTime -= deltaTime
	if hitTime <= 0.0:
		set_state( RUN )
	else:
		sprite.visible = (( int( hitTime*6 ) % 2) == 0)
		
func move(deltaTime):
	var input = Vector2.ZERO
	input.x = Input.get_axis("left","right")
	input.y = Input.get_axis("up","down")
	
	# only update direction when we 
	if input != Vector2.ZERO:
		direction = input.normalized()
		velocity = direction * maxSpeed * deltaTime
	else:
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
func get_direction_string():
	# prioritize up/down
	if direction.y > 0:
		return "Down"
	elif direction.y < 0:
		return "Up"
		
	# neither up or down, select left/right
	if direction.x >= 0:
		return "Right"
	else:
		return "Left"

# called if a body entered our attack area
func _on_AttackArea_body_entered(body):
	if body is Enemy:
		body.player_hit(10)

# called if body entered our hit box
func _on_HitArea_body_entered(body):
	if body is Enemy:
		if body.get_hurt_level() > 0:
			take_hit( body.get_hurt_level() )

			
func _on_AnimationPlayer_animation_finished(_anim_name):
	if state == ATTACK:
		set_state(RUN)
		return
	if state == DIE:
		restart()
		return

