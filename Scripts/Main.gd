extends Node

# Allows to link Scenes.tscn files
export(PackedScene) var menuPrincipal_tscn
export(PackedScene) var level1_tscn
export(PackedScene) var level2_tscn
export(PackedScene) var menuFin_tscn
# Variables
var nbrViesPlayer
var current_level
var nbrDeNiveaux = 2
var array_niveaux = [level1_tscn, level2_tscn]

func _ready():
	### Listen ################################################
	var ButtonNewGame = get_node("MenuPrincipal/ButtonNewGame")
	# Listen to ButtonNewGame.pressed()
	ButtonNewGame.connect("pressed", self, "_new_game")
	### Initial Setup #########################################
	$UI.hide()

# _new_game() triggered by boutton presse.
func _new_game():
	print("le boutton a ete presse")
	# reset nbrViesPlayer
	nbrViesPlayer = 3
	# reset au level 1
	current_level = 1
	# Delete a node from Main: MenuPrincipal node
	remove_child($MenuPrincipal)
	# Delete a node from Main: MenuFin node
	remove_child($MenuFin)
	# Add a node to Main: the level1_tscn's instance
	var Level1 = level1_tscn.instance() #Save in a variable a new instance of Level1.tscn
	add_child(Level1)
	# Make UI visible
	$UI.show()
	# Set initial UI
	# update le ProgressBar des vies
	var ProgressBarVies = get_node("UI/ContainerBarreVies/ProgressBarVies")
	ProgressBarVies.value = nbrViesPlayer
	_update_ui_cles(0)
	### Listen ################################################
	var Player = get_node("Level1/Player")
	# Listen to Player.game_over()
	#Player.connect("game_over", self, "_game_over")
	# Listen to Player.died()
	Player.connect("died", self, "_player_died")
	# Listen to Level1.finished_level()
	Level1.connect("finished_level", self, "_change_level")
	# Listen to Level1.cle_collected(nbr_cles_collected)
	Level1.connect("cle_collected", self, "_update_ui_cles")#returns nbr_cles_collected

func _game_over():
	# Make UI invisible
	$UI.hide()
	# Delete a node from Main: Level{1} node
	remove_child(get_node("Level"+str(current_level))) #ex. "Level1"
	# Add a node to Main: the menuFin_tscn's instance
	var MenuFin = menuFin_tscn.instance() #Save in a variable a new instance of MenuFin.tscn
	add_child(MenuFin)
	get_node("MenuFin/TitreFin").text = "Vous êtes mort!"
	var ButtonRecommencer = get_node("MenuFin/ButtonRecommencer")
	# Listen to ButtonNewGame.pressed()
	ButtonRecommencer.connect("pressed", self, "_new_game")

func _player_died():
	if nbrViesPlayer-1 > 0:
		nbrViesPlayer -= 1
		# update le ProgressBar des vies
		var ProgressBarVies = get_node("UI/ContainerBarreVies/ProgressBarVies")
		ProgressBarVies.value = nbrViesPlayer
		print("vie--")
	else:
		_game_over()

# Instanciates next level when Player.finished_level()
func _change_level():
	# Delete a node from Main: Level{1} node
	remove_child(get_node("Level"+str(current_level))) #ex. "Level1"
	# if (tous les niveaux completes): MenuFin.
	# else: spawn current_level+1
	if current_level+1 > nbrDeNiveaux:
		# Make UI invisible
		$UI.hide()
		# Add a node to Main: the menuFin's instance
		var MenuFin = menuFin_tscn.instance() #Save in a variable a new instance of MenuFin.tscn
		add_child(MenuFin)
		get_node("MenuFin/TitreFin").text = "Victoire!"
		var ButtonRecommencer = get_node("MenuFin/ButtonRecommencer")
		# Listen to ButtonNewGame.pressed()
		ButtonRecommencer.connect("pressed", self, "_new_game")
	else:
		# Add a node to Main: the level2_tscn's instance
		#var nom_next_level = "level" + str(current_level+1) + "_tscn"
		var NextLevel = level2_tscn.instance() #Save in a variable a new instance of Level{2}.tscn
		current_level += 1
		add_child(NextLevel)
		# Listen to Level{2}.finished_level()
		NextLevel.connect("finished_level", self, "_change_level")
		# Listen to Level{2}.cle_collected(nbr_cles_collected)
		NextLevel.connect("cle_collected", self, "_update_ui_cles")#returns nbr_cles_collected

# Update le UI quand le Player touche une cle
func _update_ui_cles(nbrClesCollected):
	# update le label cle du UI
	var LabelNbrClesCollected = get_node("UI/ContainerBarreCles/LabelNbrClesCollected")
	LabelNbrClesCollected.text = str(nbrClesCollected)
	print("cle++")
