extends Node2D

@export var dataPath = "";
@export var profile_pictures = {}

@onready var dialogue_text = $DialogueText
@onready var speaker_label = $SpeakerLabel
@onready var person_picture = $PersonPicture

var textData
var currentNodeIdx = 0

var currentTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open(dataPath, FileAccess.READ);
	var fileText = file.get_as_text();
	
	textData = JSON.parse_string(fileText)
	
	currentNodeIdx = -1
	iterate_conversation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	dialogue_text.text = textData[currentNodeIdx].text
	speaker_label.text = textData[currentNodeIdx].name
	if currentTexture:
		person_picture.texture = currentTexture
	
	
func iterate_conversation():
	currentNodeIdx += 1	
	if currentNodeIdx >= textData.size():
		end_dialogue()
	
	var image_name = textData[currentNodeIdx].image
	var texture_name = profile_pictures[image_name]
	currentTexture = load(texture_name)
		
func end_dialogue():
	currentNodeIdx = 0
	
func _input(event):
	if event is InputEventKey and event.pressed:
		iterate_conversation()
