class_name HurtboxComponent
extends Area2D
## One job: be the place where its owner can be hit. It forwards every hit to a HealthComponent.

@export var health: HealthComponent

func take_hit(amount: int) -> void:
	if health != null:
		health.take_hit(amount)
