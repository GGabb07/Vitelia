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

@export var walk_speed = 1.0 # Velocità di camminata
@export var tile_size = 16   # Dimensione della cella

var is_moving = false
var target_position = Vector2.ZERO
var input_direction = Vector2.ZERO

func _ready():
	# Allinea il giocatore alla griglia all'inizio
	position = position.snapped(Vector2(tile_size, tile_size)) + Vector2(tile_size / 2, tile_size / 2)
	target_position = position

func _physics_process(delta):
	if is_moving:
		move_player(delta)
	else:
		get_input()

func get_input():
	input_direction = Vector2.ZERO
	
	# Priorità agli assi per evitare movimenti diagonali
	if Input.is_action_pressed("right"):
		input_direction = Vector2.RIGHT
		print("Check")
	elif Input.is_action_pressed("left"):
		input_direction = Vector2.LEFT
	elif Input.is_action_pressed("back"):
		input_direction = Vector2.UP
	elif Input.is_action_pressed("front"):
		input_direction = Vector2.DOWN
	
	$RayCast2D.target_position = input_direction * tile_size
	
	if input_direction != Vector2.ZERO and !$RayCast2D.is_colliding():
		target_position = position + input_direction * tile_size
		is_moving = true

func move_player(delta):
	# Muoviamo il personaggio verso la target_position
	position = position.move_toward(target_position, walk_speed)
	
	# Se siamo arrivati a destinazione, resettiamo
	if position == target_position:
		is_moving = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_base"):
		var instance = PROIETTILE_BASE_FREDDO.instantiate() as ProiettileBaseFreddo
		instance.dir = (get_global_mouse_position() - $CollisionShape2D.global_position).normalized()
		instance.position = $CollisionShape2D.global_position
		instance.z_index = 7
		get_parent().add_child(instance)
