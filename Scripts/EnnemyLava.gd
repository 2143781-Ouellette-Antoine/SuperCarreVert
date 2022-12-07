extends Area2D

func _on_Lava_body_entered(body):
	#si player entre dans l'ennemy
	if body.name == "Player":
		body.emit_signal("game_over")
	#si l'epee entre dans l'ennemy
	elif body.name == "Attack":
		self.emit_signal("hit")#?
		queue_free()#meurt.
