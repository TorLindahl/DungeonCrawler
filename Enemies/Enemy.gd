extends KinematicBody2D
class_name Enemy

enum {
	IDLE,
	CRAWL,
	ATTACK,
	DIE,
}

var state = IDLE

var health = 10

func player_hit( damage ):
	if health <= 0:
		return
	health -= damage
	if health <= 0:
		set_state( DIE )

func set_state( new_state ):
	state = new_state

func get_hurt_level():
	if state == DIE:
		return 0
	return 10
