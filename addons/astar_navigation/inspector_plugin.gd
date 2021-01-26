extends EditorInspectorPlugin


const path_property_script := preload("path_property.gd")


func can_handle(object):
	return object is LinkedNode


func parse_property(object, type, path, hint, hint_text, usage):
	if path == "link_paths" and type == TYPE_ARRAY:
		add_property_editor("link_paths", path_property_script.new())
		return true
	
	else:
		return false
