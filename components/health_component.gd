class_name HealthComponent
extends Node
## One job: track hit points. It announces what happened and decides nothing else.

signal changed(current: int)
signal died

@export var max_health: int = 3

var current: int

func _ready() -> void:
	current = max_health

## Lets the owner re-arm this part from a tuning sheet.
func setup(new_max: int) -> void:
	max_health = new_max
	current = new_max

func take_hit(amount: int = 1) -> void:
	if current <= 0:
		return
	current = clampi(current - amount, 0, max_health)
	changed.emit(current)
	if current == 0:
		died.emit()
