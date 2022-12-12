extends Enemy

onready var sprite: = $Sprite
onready var anim: = $AnimationPlayer
onready var eye: = $Eyesight
onready var slime: = $Particles
onready var shadow: = $Shadow

var rng = RandomNumberGenerator.new()

var lookForPlayer = null
var lookForPlayerCountdown = 1
var lookForPlayerPosition = Vector2.ZERO

func _ready():
	rng.randomize()
	anim.current_animation = "Idle"
	anim.seek( rng.randf_range(0, anim.current_animation_length) )
	sprite.offset = Vector2.ZERO

func set_state( new_state ):
	state = new_state
	if state == DIE:
		anim.current_animation = "Die"
		anim.seek(0.0)
		slime.emitting = true

func _physics_process(deltaTime):
	if state == IDLE:
		run_idle()
	elif state == CRAWL:
		run_crawl(deltaTime)
	elif state == ATTACK:
		run_attack(deltaTime)
	elif state == DIE:
		run_die(deltaTime)
		
func run_idle():
	pass
	
func run_crawl(deltaTime):

	lookForPlayerCountdown -= deltaTime
	if lookForPlayerCountdown < 0:
		lookForPlayerPosition = lookForPlayer.position
		var delta = lookForPlayerPosition - position

		if delta.length() > 75.0:
			state = IDLE
			anim.current_animation = "Idle"
			anim.seek(0.0)
			eye.monitoring = true
			return

		var velocity = delta.normalized() * 45.0 * deltaTime * 60.0
		velocity = move_and_slide( velocity )
		lookForPlayerCountdown = 1

		if rng.randf_range(0, 1) < 0.2:
			state = ATTACK
			lookForPlayerCountdown = 0.6
			anim.current_animation = "Jump"
			anim.seek(0.0)
		
	
func run_attack(deltaTime):
	var delta = lookForPlayerPosition - position
	
	lookForPlayerCountdown -= deltaTime
	if lookForPlayerCountdown < 0:
		state = CRAWL
		lookForPlayerCountdown = 1
	else:
		var velocity = delta.normalized() * 40.0 * deltaTime * 60.0
		velocity = move_and_slide( velocity )

func run_die(deltaTime):
	pass
	
func _on_Eyesight_body_entered(body):
	if state == IDLE:
		if body is Player:
			lookForPlayer = body
			state = CRAWL
			anim.current_animation = "Jump"
			anim.seek(0.0)
			eye.monitoring = false
	#print("Entered" + str(body.position) )

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Jump":
		anim.current_animation = "Idle"
		anim.seek(0.0)
	elif anim_name == "Die":
		sprite.hide()
		shadow.hide()
		slime.emitting = false
		queue_free()


