class_name Damageable
extends Node


signal death
signal damaged

export var health := 2.0


func damage(value: float) -> void:
	health -= value
	
	if health <= 0:
		emit_signal("death")
		emit_signal("damaged")
	
	else:
		pass
