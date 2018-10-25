########################################
# File: Player.gd
# Author: John Thummel
########################################
extends Node2D

#==VARIABLES============================
export var HP = 10
onready var tween = $Tween


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=INIT-=
func _ready():
	pass

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=LOOP-=
func _process(delta):
	die()
	get_tree().get_root().get_node("/root/DemoArea/HP").text = "HP: " + str(HP)

func die():
	if HP <= 0:
		get_tree().get_root().get_node("/root/DemoArea/Player/PlayerSheet").anim(7,8,7)
		get_tree().quit()