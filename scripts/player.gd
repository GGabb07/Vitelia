extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 80.0

var last_dir := "front"

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()

func move():
	var input := Input.get_axis("back", "front")
	if input > 0:
		velocity = Vector2.DOWN * SPEED
		last_dir = "front"
	elif input < 0:
		velocity = Vector2.UP * SPEED
		last_dir = "back"
	else:
		input = Input.get_axis("left", "right")
		if input > 0:
			velocity = Vector2.RIGHT * SPEED
			last_dir = "right"
		elif input < 0:
			velocity = Vector2.LEFT * SPEED
			last_dir = "left"
		else:
			animation_player.play("idle_" + last_dir)
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			return
	animation_player.play("move_" + last_dir)
