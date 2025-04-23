extends HBoxContainer

@onready var files_label: RichTextLabel = $FilesLabel
@onready var vi_label: Label = $ViLabel

func _ready() -> void:
	Ass.on_files_updated.connect(_files_update)
	Ass.on_path_changed.connect(_path_changed)

func _path_changed(_new_path: String) -> void:
	pass

func _files_update(_new_files: Array[String]) -> void:
	var l = len(Ass.files)

	files_label.text = "Filtered: %s Total: %s" % [str(0), str(l)]
