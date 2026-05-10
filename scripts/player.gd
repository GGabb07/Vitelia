extends CharacterBody2D

# Gameplay stuffs
enum Attack {Base, Caricato}
enum Element {Elettro, Erba, Fuoco, Acqua, Freddo, Metallo, Terra, Lotta, Psico, Suono, Aria, Veleno}
@export var element: Element
const PROIETTILE_BASE_FREDDO := preload("uid://sjae4y2rqcd2") as PackedScene

# Movement stuffs
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
enum MovementState {Idle, Turning, Walking, Running}
enum MovementDirection {Front, Left, Right, Back}
@export var hold_treshold: float = 0.1
@export var dir := MovementDirection.Front
@export var movement_state := MovementState.Idle
const dir_to_anim := {
	MovementDirection.Front: "front",
	MovementDirection.Left: "left",
	MovementDirection.Right: "right",
	MovementDirection.Back: "back"
}
const state_to_anim := {
	MovementState.Idle: "idle",
	MovementState.Turning: "idle",
	MovementState.Walking: "walk",
	MovementState.Running: "run"
}
var time := 0.0
const GRID_SIZE := 16

func _physics_process(delta: float) -> void:
	move(delta)
	animated_sprite.play(state_to_anim[movement_state] + "_" + dir_to_anim[dir])
	move_and_slide()

func move(dt: float) -> void:
	var move = Vector2(Input.get_axis(dir_to_anim[MovementDirection.Left], dir_to_anim[MovementDirection.Right]),Input.get_axis(dir_to_anim[MovementDirection.Back],dir_to_anim[MovementDirection.Front]))
	match movement_state:
		MovementState.Idle:
			if move:
				update_dir(move)
				movement_state = MovementState.Turning
			else:
				velocity.x = move_toward(velocity.x, 0., 300.)
				velocity.y = move_toward(velocity.y, 0., 300.)
		MovementState.Turning:
			if time >= hold_treshold:
				if move:
					if Input.is_action_pressed("run"):
						movement_state = MovementState.Running
					else:
						movement_state = MovementState.Walking
				else:
					movement_state = MovementState.Idle
			time += dt
		MovementState.Walking:
			if !move:
				movement_state = MovementState.Idle
				return
			update_dir(move)
			velocity = move * 300.
		MovementState.Running:
			if !move:
				movement_state = MovementState.Idle
				return
			update_dir(move)
			velocity = move * 450.

func update_dir(move: Vector2) -> void:
	if move.y > 0:
		dir = MovementDirection.Front
	elif move.y < 0:
		dir = MovementDirection.Back
	elif move.x > 0:
		dir = MovementDirection.Right
	elif move.x < 0:
		dir = MovementDirection.Left

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_base"):
		var instance = PROIETTILE_BASE_FREDDO.instantiate() as ProiettileBaseFreddo
		instance.dir = (get_global_mouse_position() - $CollisionShape2D.global_position).normalized()
		instance.position = $CollisionShape2D.global_position
		instance.z_index = 7
		get_parent().add_child(instance)
