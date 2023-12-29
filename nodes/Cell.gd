extends Node2D

## Used as representation of passages
signal setup_finished

@export var size_x: int = Constants.ROOM_SIZE_X
@export var size_y: int = Constants.ROOM_SIZE_Y

var data: CellData = CellData.new()

func setup(d: CellData) -> void:
	data.passages = d.passages
	data.map_pos = d.map_pos
	data.cell_type = d.cell_type
	position = Vector2(data.map_pos.x * size_x, data.map_pos.y * size_y)
	if d.map_pos == Vector2i.ZERO:
		$Start.visible = true
	configure_walls()
	setup_finished.emit()
	

func _ready() -> void:
	set_process(false)
	# Replace with function body.


## Sets up the display of the cell's walls
func configure_walls() -> void:	
	match data.passages[Utils.NORTH]:
		Utils.PassageType.NONE:
			$Passages/North/Wall.visible = true
		Utils.PassageType.NORMAL:
			$Passages/North/Wall.visible = false
		_:
			$Passages/North.rotation += 1
			$Passages/North/Wall.visible = true

	match(data.passages[Utils.EAST]):
		Utils.PassageType.NONE:
			$Passages/East/Wall.visible = true
		Utils.PassageType.NORMAL:
			$Passages/East/Wall.visible = false
		_:
			$Passages/East.rotation += 1
			$Passages/East/Wall.visible = true

	match(data.passages[Utils.SOUTH]):
		Utils.PassageType.NONE:
			$Passages/South/Wall.visible = true
		Utils.PassageType.NORMAL:
			$Passages/South/Wall.visible = false
		_:
			$Passages/South.rotation += 1
			$Passages/South/Wall.visible = true

	match(data.passages[Utils.WEST]):
		Utils.PassageType.NONE:
			$Passages/West/Wall.visible = true
		Utils.PassageType.NORMAL:
			$Passages/West/Wall.visible = false
		_:
			$Passages/West.rotation += 1
			$Passages/West/Wall.visible = true
