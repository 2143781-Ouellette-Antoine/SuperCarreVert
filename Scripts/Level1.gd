extends Node2D

signal cle_collected(nbr_cles_collected)

var nbr_cles_collected

func _ready():
	nbr_cles_collected = 0
	# Listen to Cle.body_entered(body)
	var array_cles = get_tree().get_nodes_in_group("groupe_cles")
	for cle in array_cles:
		cle.connect("body_entered", self, "_on_Cle_body_entered")#returns the body

func _on_Cle_body_entered(body):
	if body.name != "Player":
		return
	nbr_cles_collected += 1
	emit_signal("cle_collected", nbr_cles_collected)
