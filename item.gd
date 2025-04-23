extends HBoxContainer

var my_path: Dictionary

@onready var path_label: RichTextLabel = %PathLabel
@onready var distance_label: Label = %DistanceLabel
@onready var icon_texture: TextureRect = %IconTexture

func setup(new_path: Dictionary) -> void:
	my_path = new_path

	path_label.text = my_path.path.get_file()
	distance_label.text = str(my_path.score)

	var type = Eater.taste(my_path.path)
	icon_texture.texture = load("res://icons/%s.svg" % Eater.FLAVOUR.keys()[type])
