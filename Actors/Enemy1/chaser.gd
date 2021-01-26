extends AStarGoto


export var target_path: NodePath = "Player"


func _ready():
	if target_path == NodePath("Player"):
		if not is_instance_valid(GlobalData.player):
			yield(GlobalData, "player_changed")
		
		set_target(GlobalData.player)
	
	elif not target_path.is_empty():
		set_target(get_node(target_path))
