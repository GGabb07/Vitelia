extends CharacterBody2D
class_name ProiettileBaseFreddo

const SPEED := 300.0
var dir: Vector2

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
