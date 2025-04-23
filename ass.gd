extends Node

var folder: String = "/home/wetrustinprize"
var filter: String = ""
var files: Array[String] = []
var filtered_files: Array[Dictionary] = []
var resources: Dictionary = {}

var timer: float = 0.0
var update_on_seconds: float = 0.1

signal on_folder_changed(new_path: String)
signal on_filter_changed(new_filter: String)
signal on_files_updated(added_files: Array[String])
signal on_files_filtered(filtered_files: Array[String])
signal on_error(error: String)

func _process(delta: float) -> void:
	timer += delta

	if timer >= update_on_seconds:
		update_files()

func reset() -> void:
	files = []
	filtered_files = []
	resources = {}

func _update_filtered_files(to_filter: Array[String]) -> void:
	var newly_filtered: Array[Dictionary] = []
	for file in to_filter:
		var name_sim = similarity(filter, file.get_file())
		var folder_sim = similarity(filter, file.get_base_dir().get_file())
		var score = name_sim * 0.7 + folder_sim * 0.3

		var filtered: Dictionary = {
			"score": score,
			"path": file,
		}

		filtered_files.append(filtered)
		newly_filtered.append(filtered)
	on_files_filtered.emit(newly_filtered)

func update_files() -> void:
	timer -= update_on_seconds

	var diff = max(0, len(Seeker.find_cache) - len(files))

	if diff > 0:
		print("Diff of %s item(s). (Current %s)" % [str(diff), str(len(files))])
		var to_add = Seeker.find_cache.duplicate().slice(max(0, len(files) - 1))
		files.append_array(to_add)
		on_files_updated.emit(to_add)
		_update_filtered_files(to_add);

func similarity(a: String, b: String) -> float:
	var dist = fuzzy(a.to_lower(), b.to_lower())
	var max_len = max(a.length(), b.length())
	if max_len == 0:
		return 1.0
	return 1.0 - float(dist) / max_len

func fuzzy(search: String, compare: String) -> int:
	if search.is_empty():
		return 0

	var m := search.length()
	var n := compare.length()
	var d := []

	# Initialize matrix
	for i in range(m + 1):
		d.append([])
		for j in range(n + 1):
			if i == 0:
				d[i].append(j)
			elif j == 0:
				d[i].append(i)
			else:
				d[i].append(0)

	# Fill matrix
	for i in range(1, m + 1):
		for j in range(1, n + 1):
			var cost := 0 if search[i - 1] == compare[j - 1] else 1
			d[i][j] = min(d[i - 1][j] + 1,      # deletion
						 d[i][j - 1] + 1,      # insertion
						 d[i - 1][j - 1] + cost) # substitution

	return d[m][n]

func set_filter(new_filter: String):
	filter = new_filter
	on_filter_changed.emit(filter)

	filtered_files = []
	_update_filtered_files(files)

	print("Updated filter to \"%s\"" % filter)

func change_folder(new_path: String):
	folder = new_path
	on_folder_changed.emit(folder)
