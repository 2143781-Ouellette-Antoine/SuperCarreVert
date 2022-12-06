extends Area2D

func _on_Barnacle_area_entered(area: Node):
	
	emit_signal("hit")
	#queue_free()
	$Sprite.hide()
	$BarnaDead.show()
	$CollisionShape2D.disabled = true
	hide()
	yield(get_tree().create_timer(0.2), "timeout")
	show()
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.2), "timeout")
	hide()
	yield(get_tree().create_timer(0.2), "timeout")
	show()
	$CollisionShape2D.disabled = true
	
