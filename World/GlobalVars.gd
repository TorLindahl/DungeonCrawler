extends Node

var playerHealth setget setPlayerHealth , getPlayerHealth

func deductPlayerHealth(val):
	playerHealth = max( playerHealth-val , 0 )

func setPlayerHealth(val):
	playerHealth = val

func getPlayerHealth():
	return playerHealth

