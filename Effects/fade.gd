class_name Fade
extends Tween


func _init(fade_time: float, transition_type:=0, ease_type:=2, delay:=0):
	yield(self, "ready")
	interpolate_property(get_parent(), "modulate:a", get_parent().modulate.a, 0, fade_time, transition_type, ease_type, delay)
	start()
