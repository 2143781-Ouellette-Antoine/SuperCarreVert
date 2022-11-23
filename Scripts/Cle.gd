extends Area2D

func _on_Cle_body_entered(body):
	if body.name != "Player":
		return
	queue_free()
