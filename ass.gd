extends Node

var path: String = "/home/wetrustinprize"
var files: Array[String] = []

var timer: float = 0.0
var update_on_seconds: float = 0.1

signal on_path_changed(new_path: String)
signal on_files_updated(added_files: Array[String])
signal on_error(error: String)

func _process(delta: float) -> void:
	timer += delta

	if timer >= update_on_seconds:
		update_files()

func update_files() -> void:
	timer -= update_on_seconds

	var diff = max(0, len(Seeker.find_cache) - len(files))

	if diff > 0:
		print("Diff of %s item(s). (Current %s)" % [str(diff), str(len(files))])
		var to_add = Seeker.find_cache.duplicate().slice(max(0, len(files) - 1))
		files.append_array(to_add)
		on_files_updated.emit(to_add)

func change_path(new_path: String):
	path = new_path
	on_path_changed.emit(path)
