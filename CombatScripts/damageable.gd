class_name Damageable
extends Node


signal death
signal damaged(value)

export var health := 3.0


func damage(value: float) -> void:
	health -= value
	emit_signal("damaged", value)
	
	if health <= 0:
		emit_signal("death")
