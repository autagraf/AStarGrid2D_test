@tool
extends Node2D

@onready var view = get_node_or_null("/root/main/View")
@onready var astar = get_node("astar_map")
@export var step:int = 16
var lines = []

signal change_rect

@export var rect:Vector4:
	set(val):
		var mod = [fmod(val.x,step), fmod(val.y,step), fmod(val.z,step), fmod(val.w,step)]
		var c = 0
		for i in mod:
			if i == 0.:
				rect[c] = val[c]
			else:
				rect[c] = val[c] - i
			c+=1
		change_rect.emit()
		queue_redraw()

func _draw():
	var arr = PackedVector2Array()
	for x in range(rect.x, rect.z, step):
		arr.append(Vector2(x, rect.y))
		arr.append(Vector2(x, rect.w))
	for y in range(rect.y, rect.w, step):
		arr.append(Vector2(rect.x, y))
		arr.append(Vector2(rect.z, y))
	draw_multiline(arr, Color(0,0,0,0.1), 1.0)
	pass

var start_rect

func _ready():
	if view != null:
		start_rect = rect
		#print(start_rect)
		view.view_change.connect(view_change)
	pass 

func view_change(zoom_t, offset_t):
	var size_x = start_rect.z-start_rect.x
	var size_y = start_rect.w-start_rect.y
	var dx = size_x*(1. - 1./zoom_t)/2
	var dy = size_y*(1. - 1./zoom_t)/2
	var n_size = Vector4(
		start_rect.x+dx+offset_t.x,
		start_rect.y+dy+offset_t.y,
		start_rect.z-dx+offset_t.x,
		start_rect.w-dy+offset_t.y)
	rect = n_size
	pass

var mous_pos 

func _input(event):
	mous_pos = get_local_mouse_position()
	pass
