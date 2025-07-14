extends Node2D

@export var SPAWN_GUNS:bool = true
@export var SPAWN_MAGS:bool = true

func pickRandomItem():
	var itemCatogories = []
	
	var gunList = Game.guns
	var magList = Game.mags
	
	if (SPAWN_GUNS):
		itemCatogories.append(gunList)
	if (SPAWN_MAGS):
		itemCatogories.append(magList)
	
	# Pick random item catorgory and shuffle items in that catogory
	var randomItemCatogory = itemCatogories.pick_random()
	var randomItems:Array = randomItemCatogory.keys()
	randomItems.shuffle()

	# Pick first item in shuffled list
	# TODO THIS ISNT GREAT FOR CHANCE INSTEAD WE MIGHT HAVE TO ADD ITEMS TO AN ARRAY X AMOUNT OF TIMES THEN PICK_RANDOM EX |AK|AK|COLT|AK|COLT|AK|
	var randomItem = randomItems[0]
	var randomItemData = randomItemCatogory[randomItem]
	
	# Pick random number
	var rng = RandomNumberGenerator.new()
	var rngItemPickedNumber = rng.randi_range(0,100)
	
	print(randomItem)
	print(rngItemPickedNumber)
	
	# Item Spawns
	if (rngItemPickedNumber < randomItemData["SPAWN_RATE"]):
		var object = load(randomItemData["SCENE_PATH"])
		var instance = object.instantiate()
		add_child(instance)

func _ready() -> void:
	pickRandomItem()
