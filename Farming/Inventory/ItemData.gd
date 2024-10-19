extends Resource
class_name ItemData

@export_group("Money")
@export var sellable:bool
@export var money_value:int
@export var buy_cost:int

@export_group("")
@export_enum("Till", "Plant", "Water", "Harvest","Burn", "Eat", "Empty") var interation_type:int
@export var inventory_image:Texture2D
@export var crop_name:String
