extends Node2D

@export var SPAWN_GUNS:bool = true
@export var SPAWN_MAGS:bool = true

func pick_weighted_item(rarity, item_catogory: Dictionary) -> String:
	var total_weight = 0
	
	if (rarity == "Nothing"):
		return ""
	for item in item_catogory[rarity]:
		var weight = item_catogory[rarity][item]["SPAWN_WEIGHT"]
		total_weight += weight

	if (item_catogory[rarity].size() > 0):
		var rand = randi() % total_weight
		var current = 0

		for item in item_catogory[rarity]:
			var weight = item_catogory[rarity][item]["SPAWN_WEIGHT"]
			current += weight
			if rand < current:
				return item

	return ""  # Fallback, should never hit
	
func pick_weighted_rariety(rarities: Dictionary) -> String:
	var total_weight = 0
	for rarity in rarities:
		var weight = rarities[rarity]["SPAWN_WEIGHT"]
		total_weight += weight
	
	var rand = randi() % total_weight
	var current = 0

	for rarity in rarities:
		var weight = rarities[rarity]["SPAWN_WEIGHT"]
		current += weight
		if rand < current:
			return rarity

	return ""  # Fallback, should never hit

func pickRandomItem():
	var itemCatogories = []
	
	var gunList = Game.guns
	var magList = Game.mags
	
	if (SPAWN_GUNS):
		itemCatogories.append(gunList)
	if (SPAWN_MAGS):
		itemCatogories.append(magList)
	
	if (itemCatogories.size() > 0):
		# TODO Make item catogories have custom weights per Item Spawner
		var randomItemCatogory = itemCatogories.pick_random()

		# Pick random item based on defiend weights
		var rarity = pick_weighted_rariety(Game.rarities)
		var randomItem = pick_weighted_item(rarity,randomItemCatogory)
		if (randomItem):
			var randomItemData = randomItemCatogory[rarity][randomItem]

			# Load item and spawn it
			var object = load(randomItemData["SCENE_PATH"])
			var instance = object.instantiate()
			add_child(instance)

func _ready() -> void:
	pickRandomItem()
