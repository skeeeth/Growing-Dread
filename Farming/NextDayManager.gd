extends Node

@onready var next_day_card = $NextDayCard

var timer = 0.0

const SHOW_CARD_DURATION = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Farming.day_progressed.connect(next_day)


func next_day():
	next_day_card.visible = true
	timer = SHOW_CARD_DURATION

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer > 0):
		timer -= delta
		if(timer <= 0):
			timer = 0
			next_day_card.visible = false
