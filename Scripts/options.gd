extends CanvasLayer

@onready var master: HSlider = $Control/Panel/Master
@onready var music: HSlider = $Control/Panel/Music
@onready var sfx: HSlider = $Control/Panel/SFX

func _ready() -> void:
	# Initialize slider values from Globals
	master.value = Globals.master_volume
	music.value = Globals.music_volume
	sfx.value = Globals.sfx_volume

func _process(delta: float) -> void:
	# Get current bus indices
	var master_index = AudioServer.get_bus_index("Master")
	var music_index = AudioServer.get_bus_index("Music")
	var sfx_index = AudioServer.get_bus_index("SFX")

	# Get current volume levels
	var master_volume_db = AudioServer.get_bus_volume_db(master_index)
	var music_volume_db = AudioServer.get_bus_volume_db(music_index)
	var sfx_volume_db = AudioServer.get_bus_volume_db(sfx_index)
	
	# Update audio levels only if slider values have changed
	if abs(master.value - db_to_linear(master_volume_db)) > 0.001:
		Globals.master_volume = master.value
		AudioServer.set_bus_volume_db(master_index, linear_to_db(master.value))

	if abs(music.value - db_to_linear(music_volume_db)) > 0.001:
		Globals.music_volume = music.value
		AudioServer.set_bus_volume_db(music_index, linear_to_db(music.value))

	if abs(sfx.value - db_to_linear(sfx_volume_db)) > 0.001:
		Globals.sfx_volume = sfx.value
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx.value))

func _on_button_pressed() -> void:
	var parent = get_parent()
	parent.in_options = false
	queue_free()
