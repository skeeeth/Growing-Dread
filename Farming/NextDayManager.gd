extends Node

@onready var next_day_card = $NextDayCard
@onready var card_text = $NextDayCard/Label

@onready var moonlight = $"../Moonlight"
@onready var spawn_point = $"../SpawnPoint"
@onready var crt_filter = $"../Camera2D/ScreenSpace/CRT_Filter"
@onready var day_layer = $"../Camera2D/ScreenSpace/Day"
var timer = 0.0
const SHOW_CARD_DURATION = 3.0
@export var cam:CRT_Cam
@export var player:CharacterBody2D
var farm_character = preload("res://Farming/Character/Player/Player_F.tscn")
var night_character = preload("res://Combat/Player/Player_C.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Farming.day_progressed.connect(next_day)
	Farming.night_fallen.connect(go_to_night)
	#next_day_card.reparent(cam,false)
	#next_day_card.position = cam.crt_overlay.position
	

func next_day():
	card_text.text = "Day " + str(Farming.day)
	day_layer.visible = true
	var fade_out = create_tween()
	fade_out.set_parallel()
	
	fade_out.tween_property(crt_filter,"modulate:a",0.0,0.5) 
	#i guess alterering modulate for a screen_reading shader doesnt actually cause a fade
	#TODO: I'll have to change this to instead alter the uniforms to get the desired effect
	
	fade_out.tween_property(moonlight,"energy",0.0,2.0)
	_replace_player(farm_character)
	#_show_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer > 0):
		timer -= delta
		if(timer <= 0):
			timer = 0
			next_day_card.visible = false
			

func go_to_night():
	card_text.text = "Night " + str(Farming.day)
	day_layer.visible = false
	var fade_in = create_tween()
	fade_in.set_parallel()
	fade_in.tween_property(crt_filter,"modulate:a",1.0,0.5) #TODO: fix this (see next_day())
	fade_in.tween_property(moonlight,"energy",0.6,3.3)
	##TODO should probalby have some kinda sound here
	_replace_player(night_character)

	#_show_card()
	pass

func _show_card():
	next_day_card.visible = true
	timer = SHOW_CARD_DURATION
	
func _replace_player(new_character:PackedScene): #Swaps Player
	var previous_player = player
	var new_player:CharacterBody2D = new_character.instantiate()
	new_player.global_position = spawn_point.global_position
	player = new_player
	cam.tracked_object = player
	previous_player.queue_free() ##TODO: probably some kind of walk into house animation
	add_sibling(new_player) ##TODO: should also have a walk out of house animation
