extends KinematicBody2D


signal game_over
signal hurt

var speed = 600
var jump_speed = 1500
var gravity = 4500
var direction = 0

var velocity = Vector2.ZERO

var screen_size
var isAttack = false #AntiDev, Godot Engine Tutorials & Analysis - https://www.youtube.com/watch?v=q0WHhsmifkQ&t=1s
var isHurt = false
var isDead = false
var isJump = false

var vie = 3

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play("stand")

func _physics_process(delta):
	velocity.x = 0
	
	if Input.is_action_pressed("ui_left") && isAttack == false && isHurt == false && isDead == false:
		velocity.x = -speed
		if direction != -1:
			direction = -1
			#$Attack.flip_h = true
			$AreaAttack/CollisionAttack.position.x = -53.75
			$AnimatedSprite.flip_h = true
		if !isJump:
			$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_right") && isAttack == false && isHurt == false && isDead == false:
		velocity.x = speed
		if direction != 1:
			direction = 1
			#$Attack.flip_h = false
			$AreaAttack/CollisionAttack.position.x = 53.75
			$AnimatedSprite.flip_h = false
		if !isJump:
			$AnimatedSprite.play("run")
	else:
		velocity.x = 0
		if !isAttack && !isHurt && !isDead && !isJump:
			$AnimatedSprite.play("stand")
	
	if Input.is_action_pressed("ui_accept") && !isDead:
		$AnimatedSprite.play("hit")
		isAttack = true
		
			
	velocity.y += gravity*delta
	
	move_and_slide(velocity)
	
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)

func _input(event):
	if event.is_action_pressed("ui_up") && !isDead:
		$AnimatedSprite.play("jump")
		isJump = true
		velocity.y = -jump_speed

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		isAttack = false
	elif $AnimatedSprite.animation == "ouch":
		isHurt = false
	elif $AnimatedSprite.animation == "jump":
		isJump = false


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "hit":
		if $AnimatedSprite.frame == 3:
			$AreaAttack/CollisionAttack.disabled = false
		elif $AnimatedSprite.frame == 4:
			$AreaAttack/CollisionAttack.disabled = true



func _on_Player_hurt():
	vie -= 1
	if vie == 0:
		$AnimatedSprite.play("dead")
		if direction == 1:
			position.x -= 50
		elif direction == 1:
			position.x += 50
		isDead = true
	else:
		print("ouch")
		$AnimatedSprite.play("ouch")
		if direction == 1:
			position.x -= 30
		elif direction == -1:
			position.x += 30
		isHurt = true
		hide()
		yield(get_tree().create_timer(0.02), "timeout")
		show()
