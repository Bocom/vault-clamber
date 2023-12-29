extends Node2D

@export var cell_scene: PackedScene
@export var set_seed = true
@export var randomizer_seed = 12345

var rng = RandomNumberGenerator.new()
var map_generated := false
var player_room_idx = Vector2i(0, 0)
var player_position = Vector2i(Constants.ROOM_SIZE_X / 2, Constants.ROOM_SIZE_Y / 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	if set_seed:
		$FloorRandomizer.setup(randomizer_seed)
	else:
		var random_seed = rng.randi()
		print("Using seed ", random_seed)
		$FloorRandomizer.setup(random_seed)

	generate_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var room_movement = Vector2i.ZERO

	if Input.is_physical_key_pressed(KEY_LEFT):
		room_movement = Utils.WEST
	elif Input.is_physical_key_pressed(KEY_RIGHT):
		room_movement = Utils.EAST
	elif Input.is_physical_key_pressed(KEY_UP):
		room_movement = Utils.NORTH
	elif Input.is_physical_key_pressed(KEY_DOWN):
		room_movement = Utils.SOUTH

	var player_movement = Vector2i.ZERO
	if Input.is_action_pressed("player_move_left"):
		player_movement += Utils.WEST
	elif Input.is_action_pressed("player_move_right"):
		player_movement += Utils.EAST

	if Input.is_action_pressed("player_move_up"):
		player_movement += Utils.NORTH
	elif Input.is_action_pressed("player_move_down"):
		player_movement += Utils.SOUTH

	if player_movement != Vector2i.ZERO:
		$Player.position += player_movement * delta * 300

	print(get_position_in_room())

	if room_movement != Vector2i.ZERO:
		var new_pos = player_room_idx + room_movement
		if new_pos in $FloorRandomizer.cells:
			var current_cell: CellData = $FloorRandomizer.cells[player_room_idx]
			if current_cell.passages[room_movement] == Utils.PassageType.NORMAL:
				player_room_idx = new_pos

		#$Player.position = player_room_idx * Constants.ROOM_SIZE
		update_camera()

	pass


func update_camera():
	$Camera2D.position = player_room_idx * Constants.ROOM_SIZE


func get_position_in_room():
	var room_coords = player_room_idx * Constants.ROOM_SIZE
	
	return room_coords


func generate_map():
	print("Generating level layout")

	map_generated = false

	$map.free()
	var m = Node2D.new()
	m.name = "map"
	add_child(m, true)

	$FloorRandomizer.plan_floor()

	map_generated = true


func _on_floor_randomizer_floor_planned():
	print("Level generated")

	await get_tree().process_frame

	for i in $FloorRandomizer.cells:
		var cell = cell_scene.instantiate()

		cell.setup($FloorRandomizer.cells[i])

		$map.add_child(cell, true)

		await get_tree().create_timer(0.025).timeout
