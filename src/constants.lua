VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 48

MAP_WIDTH = 9
MAP_HEIGHT = 5

MAP_RENDER_OFFSET_X = (VIRTUAL_WIDTH - (MAP_WIDTH * TILE_SIZE)) / 2
MAP_RENDER_OFFSET_Y = (VIRTUAL_HEIGHT - (MAP_HEIGHT * TILE_SIZE)) / 2

DEGREES_TO_RADIANS = 0.0174532925199432957
RADIANS_TO_DEGREES = 57.295779513082320876

PLAYER_WALK_SPEED = 60

TILE_FLOORS = {
    9, 16, 24, 32, 39
}

TILE_FLOOR_SYMBOLS = {
	17, 18, 25, 26, 33, 34, 35
}

TILE_EMPTY = 48

TILE_TOP_WALLS = {5} --{5,6,7}
TILE_BOTTOM_WALLS = {1} --no
TILE_LEFT_WALLS = {2}
TILE_RIGHT_WALLS = {3} --no

TILE_TOP_LEFT_CORNER = 4
TILE_TOP_RIGHT_CORNER =8
TILE_BOTTOM_LEFT_CORNER = 47
TILE_BOTTOM_RIGHT_CORNER = 41