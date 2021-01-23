# When added as a child to a node (through code), will cause sthe parent to fade away
class_name Fade
extends Tween


func _init(fade_time: float, transition_type:=0, ease_type:=2, delay:=0):
	# warning-ignore-all:return_value_discarded
	yield(self, "ready")
	interpolate_property(get_parent(), "modulate:a", get_parent().modulate.a, 0, fade_time, transition_type, ease_type, delay)
	start()
