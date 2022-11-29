extends Area2D

signal finished_level

var door_is_unlocked = false

func _on_Porte_body_entered(body):
	if body.name != "Player":
		return
	elif door_is_unlocked == true:
		emit_signal("finished_level")

func _unlock_porte():
	door_is_unlocked = true
	$SpriteClosed.hide()
	$SpriteOpened.show()
