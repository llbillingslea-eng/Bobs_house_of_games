extends CharacterBody2D

enum State { PATROL, CHASE, FRIGHTENED }

@export var patrol_speed: float = 140.0
@export var chase_speed: float = 220.0
@export var sight_range: float = 260.0
@export var give_up_range: float = 360.0
@export var flee_speed: float = 260.0
@export var frightened_time: float = 3.0

var state: State = State.PATROL
var patrol_points: Array[Vector2] = [
	Vector2(200, 150), Vector2(950, 150), Vector2(950, 500), Vector2(200, 500),
]
var patrol_index: int = 0
var frightened_left: float = 0.0

@onready var player: Node2D = get_node("../Bob")
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_change_state(State.PATROL)

func _physics_process(delta: float) -> void:
	var to_player := player.global_position - global_position

	match state:
		State.PATROL:
			var target := patrol_points[patrol_index]
			if global_position.distance_to(target) < 12.0:
				patrol_index = (patrol_index + 1) % patrol_points.size()
				target = patrol_points[patrol_index]
			velocity = (target - global_position).normalized() * patrol_speed
			if to_player.length() < sight_range:
				_change_state(State.CHASE)

		State.CHASE:
			velocity = to_player.normalized() * chase_speed
			if to_player.length() > give_up_range:
				_change_state(State.PATROL)

		State.FRIGHTENED:
			frightened_left -= delta
			velocity = -to_player.normalized() * flee_speed
			if frightened_left <= 0.0:
				_change_state(State.PATROL)
	if velocity.x < 0.0:
		sprite.flip_h = true
	elif velocity.x > 0.0:
		sprite.flip_h = false

	move_and_slide()

func _change_state(new_state: State) -> void:
	state = new_state
	print("golem: ", State.keys()[new_state])
	match new_state:
		State.PATROL:
			sprite.texture = load("res://golem_idle.png")
		State.CHASE:
			sprite.texture = load("res://golem_chase.png")
		State.FRIGHTENED:
			sprite.texture = load("res://golem_frighten.png")

func frighten() -> void:
	frightened_left = frightened_time
	_change_state(State.FRIGHTENED)

func calm() -> void:
	frightened_left = 0.0
	patrol_index = 0
	_change_state(State.PATROL)
func _on_hit_box_area_entered(area: Area2D) -> void:
	# Check if the incoming area is your bonearang
	if "bonearang" in area.name.to_lower():
		frighten()
		area.queue_free() 
