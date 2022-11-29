extends PathFollow2D

onready var pathfollow = get_parent()
var direction = 1
var speed = 300

func _physics_process(delta):
	if direction == -1:
		if unit_offset == 0:
			direction = 1
		else:
			set_offset(get_offset() - speed * delta)
			rotation -= direction * PI * unit_offset * 3
	if direction == 1:
		if unit_offset == 1:
			direction = -1
		else:
			set_offset(get_offset() + speed * delta)
			rotation += direction * PI * unit_offset * 3
