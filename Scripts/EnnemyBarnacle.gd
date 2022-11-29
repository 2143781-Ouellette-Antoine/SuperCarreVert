extends Area2D

func _on_Barnacle_area_entered(area: Node):

	emit_signal("hit")

	queue_free()
