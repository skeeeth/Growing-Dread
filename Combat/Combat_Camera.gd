extends Camera2D
class_name CRT_Cam

@export var tracked_object:Node2D
@onready var screen_space = $ScreenSpace
@onready var crt_overlay = $ScreenSpace/CRT_Filter
@onready var day = $ScreenSpace/Day
@onready var meltfilter = $ScreenSpace/Meltfilter

func _ready():
	crt_overlay.size = get_viewport_rect().size / scale
	meltfilter.size = get_viewport_rect().size / scale
	screen_space.position = -(get_viewport_rect().size / scale)/2.0
	day.size = get_viewport_rect().size / scale


func _process(_delta):
	global_position = ((tracked_object.global_position * 3.0) + get_global_mouse_position())/4.0;
	screen_space.global_position = get_screen_center_position() - get_viewport_rect().size/2.0
	pass
