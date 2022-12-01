extends KinematicBody2D

signal game_over
signal hurt
signal hit

var speed = 600
var jump_speed = 1500
var gravity = 4500
var direction = 0

var velocity = Vector2.ZERO

var sprite_x
var sprite_y
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	sprite_x = $Sprite.texture.get_width()/2
	sprite_y = $Sprite.texture.get_height()/2
	$Attack/HitAttack/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("stand")

func _physics_process(delta):
	velocity.x = 0
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		if direction != -1:
			direction = -1
			$Attack.position.x = $Attack.position.x * direction
			$Attack.flip_h = true
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("run")
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		if direction != 1:
			$Attack.position.x = $Attack.position.x * direction
			direction = 1
			$Attack.flip_h = false
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("run")
			
	velocity.y += gravity*delta
	
	move_and_slide(velocity)
	
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)

func _input(event):
	if event.is_action_pressed("ui_up"):
		velocity.y = -jump_speed
	if event.is_action_pressed(("ui_accept")):
		$Attack/AttackTimer.start()
		$Attack/HitAttack/CollisionShapeAttack.disabled = false
		$Attack.play("attack")
		$Attack.frame = 0

func _on_Timer_timeout():
	$Attack/HitAttack/CollisionShapeAttack.disabled = true
