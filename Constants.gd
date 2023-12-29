class_name Constants
extends Node
## Keeps all of the constants relevant to gameplay in one place

const TILE_SIZE = 32

#const ROOM_SIZE_X = 96
const ROOM_SIZE_X = 24 * TILE_SIZE # 24 * 32 = 768
#const ROOM_SIZE_Y = 64
const ROOM_SIZE_Y = 16 * TILE_SIZE # 16 * 32 = 512

const ROOM_SIZE = Vector2i(ROOM_SIZE_X, ROOM_SIZE_Y)
