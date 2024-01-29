@tool
extends Node
class MyAStar:
	extends AStarGrid2D
	
	var weight = -0.001
	
	func _compute_cost(u, v):
		var pos_u = get_point_position(u)
		var pos_v = get_point_position(v)
		return abs(pos_u.y - pos_v.y) + (1+weight*pos_v.y)*abs(pos_u.x - pos_v.x)

	func _estimate_cost(u, v):
		var pos_u = get_point_position(u)
		var pos_v = get_point_position(v)
		return sqrt(((1+weight*pos_v.y)*(pos_u.x - pos_v.x))**2+(pos_u.y - pos_v.y)**2)

var map = MyAStar.new()
@onready var grid = get_node("/root/main/grid")
@onready var view = get_node("/root/main/View")

func make_astar(zoom_t=1, a_offset=Vector2(0,0), rect=grid.rect):
	map.region = Rect2i(rect.x, rect.y, rect.z-rect.x, rect.w-rect.y)
	map.cell_size = Vector2(grid.step, grid.step)
	if map.is_dirty():
		map.update()
	print("map astar: ",map.region,)
	pass

func _ready():
	map.diagonal_mode = map.DIAGONAL_MODE_NEVER
	make_astar()
	if view!=null:
		view.view_change_compl.connect(make_astar)
	pass

func _process(delta):
	pass
	
