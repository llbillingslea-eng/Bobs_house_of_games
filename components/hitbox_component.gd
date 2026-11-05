class_name HitboxComponent
extends Area2D
## One job: deal damage to any HurtboxComponent it touches.

signal landed

@export var damage: int = 1

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.take_hit(damage)
		landed.emit()
