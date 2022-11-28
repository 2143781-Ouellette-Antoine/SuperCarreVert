extends Node2D

signal cle_collected(nbr_cles_collected)
signal finished_level

var nbr_cles_collected

func _ready():
	nbr_cles_collected = 0
	# Listen to Porte.body_entered(body)
	var Porte = get_node("Porte")
	Porte.connect("body_entered", self, "_on_Porte_body_entered")#returns the body
	# Listen to Cle.body_entered(body)
	var array_cles = get_tree().get_nodes_in_group("groupe_cles")
	for cle in array_cles:
		cle.connect("body_entered", self, "_on_Cle_body_entered")#returns the body
	# Listen to Ennemy.body_entered(body)
	var array_ennemies = get_tree().get_nodes_in_group("groupe_ennemies")
	for ennemy in array_ennemies:
		ennemy.connect("body_entered", self, "_on_Ennemy_body_entered")#returns the body

func _on_Cle_body_entered(body):
	if body.name != "Player":
		return
	nbr_cles_collected += 1
	emit_signal("cle_collected", nbr_cles_collected)

func _on_Ennemy_body_entered(body):
	if body.name != "Player":
		return
	get_node("Player").emit_signal("hurt")

func _on_Porte_body_entered(body):
	if body.name != "Player":
		return
	emit_signal("finished_level")
