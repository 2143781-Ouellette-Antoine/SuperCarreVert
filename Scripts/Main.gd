extends Node

# Variables
var nbr_vies_player
var current_level
var array_niveaux = [preload("res://Scenes/Levels/Level1.tscn"), preload("res://Scenes/Levels/Level2.tscn")]
var nbr_de_niveaux = array_niveaux.size()

func _ready():
	### Listen ################################################
	var ButtonNewGame = get_node("MenuPrincipalCanvas/MenuPrincipal/ButtonNewGame")
	# Listen to ButtonNewGame.pressed()
	ButtonNewGame.connect("pressed", self, "_new_game")
	# Listen to ButtonRecommencer.pressed()
	var ButtonRecommencer = get_node("MenuFinCanvas/MenuFin/ButtonRecommencer")
	ButtonRecommencer.connect("pressed", self, "_new_game")
	### Initial Setup #########################################
	# Hide a node from Main: UICanvas node
	$UICanvas.hide()
	$MenuFinCanvas.hide()
	$BackgroundCanvas.show()
	$MenuPrincipalCanvas.show()

# _new_game() triggered by boutton presse.
func _new_game():
	print("le boutton a ete presse")
	# reset nbrViesPlayer
	nbr_vies_player = 3
	# reset au level 1
	current_level = 1
	# Hide a node from Main: MenuPrincipalCanvas node
	$MenuPrincipalCanvas.hide()
	# Hide a node from Main: MenuFinCanvas node
	$MenuFinCanvas.hide()
	# Add a node to Main: the Level1.tscn's instance
	var Level1 = array_niveaux[1-1].instance() #Save in a variable a new instance of Level1.tscn
	add_child(Level1)
	print(Level1)
	# Make UI visible
	$UICanvas.show()
	# Set initial UI,
	# update le ProgressBar des vies
	var ProgressBarVies = get_node("UICanvas/UI/ContainerBarreVies/ProgressBarVies")
	ProgressBarVies.value = nbr_vies_player
	_update_ui_cles(0)
	### Listen ################################################
	var Player = get_node("Level1/Player")
	#Player.connect("game_over", self, "_game_over")
	# Listen to Player.hurt()
	Player.connect("hurt", self, "_player_hurt")
	# Listen to Level1.finished_level()
	Level1.connect("finished_level", self, "_change_level")
	# Listen to Level1.cle_collected(nbr_cles_collected)
	Level1.connect("cle_collected", self, "_update_ui_cles")#returns nbr_cles_collected

func _game_over():
	# Make UI invisible
	$UICanvas.hide()
	# Delete a node from Main: Level{1} node
	remove_child(get_node("Level"+str(current_level))) #ex. "Level1"
	# Show a node to Main: the menuFin_tscn's instance
	$MenuFinCanvas.show()
	# Change text of Title
	get_node("MenuFinCanvas/MenuFin/TitreFin").text = "Vous êtes mort!"
	#x Listen to ButtonRecommencer.pressed()

func _player_hurt():
	if nbr_vies_player-1 > 0:
		nbr_vies_player -= 1
		# update le ProgressBar des vies
		var ProgressBarVies = get_node("UICanvas/UI/ContainerBarreVies/ProgressBarVies")
		ProgressBarVies.value = nbr_vies_player
		print("vie--")
	else:
		_game_over()

# Instanciates Next_Level when Player.finished_level()
func _change_level():
	##CLEAN OLD LEVEL##
	# Delete a node from Main: Level{1} node
	remove_child(get_node("Level"+str(current_level))) #ex. "Level1"
	_update_ui_cles(0)
	
	# if (tous les niveaux completes): MenuFin.
	# else: spawn current_level+1
	if current_level+1 > nbr_de_niveaux:
		# Make UI invisible
		$UICanvas.hide()
		# Show a node to Main: the MenuFin.tscn's instance
		$MenuFinCanvas.show()
		# Change text of Title
		get_node("MenuFinCanvas/MenuFin/TitreFin").text = "Victoire!"
		# Listen to ButtonRecommencer.pressed()
		var ButtonRecommencer = get_node("MenuFinCanvas/MenuFin/ButtonRecommencer")
		ButtonRecommencer.connect("pressed", self, "_new_game")
	else:
		current_level += 1
		print("Niveau "+str(current_level))
		# Add a node to Main: the Level2.tscn's instance
		var NextLevel = array_niveaux[current_level-1].instance() #Save in a variable a new instance of Level{2}.tscn
		add_child(NextLevel)
		# Listen to Player.hurt()
		var Player = get_node("Level"+str(current_level)+"/Player")
		Player.connect("hurt", self, "_player_hurt")
		# Listen to Level{2}.finished_level()
		NextLevel.connect("finished_level", self, "_change_level")
		# Listen to Level{2}.cle_collected(nbr_cles_collected)
		NextLevel.connect("cle_collected", self, "_update_ui_cles")#returns nbr_cles_collected

# Update le UI quand le Player touche une cle
func _update_ui_cles(nbrClesCollected):
	# update le label cle du UI
	var LabelNbrClesCollected = get_node("UICanvas/UI/ContainerBarreCles/LabelNbrClesCollected")
	LabelNbrClesCollected.text = str(nbrClesCollected)
	print("cle++")
