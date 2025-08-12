extends Panel
@onready var ammo_type_label: Label = $ColorRect/List/AmmoTypeLabel
@onready var firerate_mode_label: Label = $ColorRect/List/FirerateModeLabel
@onready var current_ammo_label: Label = $ColorRect/List/CurrentAmmoLabel

func update(gun:Gun):
	ammo_type_label.text = gun.AMMO_TYPE
	firerate_mode_label.text = str(gun.isAutoFireMode)
	if (gun.loadedMag):
		current_ammo_label.text = str(gun.loadedMag.currentAmmo)+"/"+str(gun.loadedMag.AMMO_CAPACITY)
	else:
		current_ammo_label.text = "0"+"/"+"0"

func showHide(isVisible):
	if (visible!=isVisible):
		visible = isVisible
