extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 100.0

var last_dir := "front"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("back", "front")
	).normalized()
	if direction.x > 0:
		last_dir = "right"
	elif direction.x < 0:
		last_dir = "left"
	elif direction.y > 0:
		last_dir = "front"
	elif direction.y < 0:
		last_dir = "back"
	
	if direction:
		velocity = direction * SPEED
		animation_player.play("move_" + last_dir)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation_player.play("idle_" + last_dir)
	move_and_slide()
