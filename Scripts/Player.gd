extends KinematicBody2D

signal game_over
signal hurt

var speed = 600
var jump_speed = 1500
var gravity = 4500

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.x = 0
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	velocity.y += gravity*delta
	
	move_and_slide(velocity)

func _input(event):
	if event.is_action_pressed("ui_up"):
		velocity.y = -jump_speed
