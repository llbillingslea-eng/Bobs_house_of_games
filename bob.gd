extends CharacterBody2D

enum State { MOVE, ATTACK, THROW }

const BULLET_SCENE = preload("res://bonearang.tscn")

@export var speed: float = 600.0
@export var action_duration: float = 2.0

var state: State = State.MOVE
var action_timer: float = 0.0
var facing_direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")
	_change_state(State.MOVE)

func _physics_process(delta: float) -> void:
	match state:
		State.MOVE:
			var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			velocity = direction * speed

			if direction != Vector2.ZERO:
				facing_direction = direction

			if direction.x < 0.0:
				sprite.flip_h = true
			elif direction.x > 0.0:
				sprite.flip_h = false

			if Input.is_action_just_pressed("attack"):
				_change_state(State.ATTACK)
				var golem = get_parent().get_node_or_null("Golem")
				if golem:
					var dist = global_position.distance_to(golem.global_position)
					print("ACTUAL DISTANCE: ", dist)
					if dist < 100.0:
						golem.frighten()
			elif Input.is_action_just_pressed("bonerang"):
				_change_state(State.THROW)
				var golem = get_parent().get_node_or_null("Golem")
				if golem and global_position.distance_to(golem.global_position) < 80.0:
					golem.frighten()
			elif Input.is_action_just_pressed("bonerang"):
				_change_state(State.THROW)

		State.ATTACK, State.THROW:
			velocity = Vector2.ZERO
			action_timer -= delta
			
			if action_timer <= 0.0:
				_change_state(State.MOVE)

	move_and_slide()

func _change_state(new_state: State) -> void:
	state = new_state
	print("Bob State: ", State.keys()[new_state])

	match new_state:
		State.MOVE:
			sprite.texture = load("res://idle.png")

		State.ATTACK:
			action_timer = action_duration
			sprite.texture = load("res://kick.png")

		State.THROW:
			action_timer = action_duration
			sprite.texture = load("res:///throw.png")
			_spawn_bullet()

func _spawn_bullet() -> void:
	if BULLET_SCENE:
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = global_position
		bullet.direction = facing_direction
		get_parent().add_child(bullet)
