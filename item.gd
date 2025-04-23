extends HBoxContainer
class_name Item

var path: String
var type: TYPE

@onready var path_label: RichTextLabel = %PathLabel

enum TYPE {
	UNKNOWN,
	IMAGE,
}

func setup(new_path: String) -> void:
	path = new_path
	path_label.text = path
