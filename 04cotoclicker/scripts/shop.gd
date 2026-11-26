extends Node

# Переменные для привязки в инспекторе (перетащи туда узлы из сцены Shop)
@export var coin_label: Label
@export var upgrade_container: VBoxContainer

func _ready() -> void:
	# При запуске магазина проверяем, что уже куплено, и обновляем баланс
	check_purchased_upgrades()
	update_ui()

func update_ui() -> void:
	# Обновляет текст с монетами на экране
	if coin_label:
		coin_label.text = str(Global.coins)

func close_button(button_path: NodePath) -> void:
	# Блокирует кнопку и сохраняет её путь в глобальный массив
	var button = get_node_or_null(button_path) as Button
	if button:
		button.disabled = true
		# Сохраняем путь к кнопке в виде строки, чтобы после перезапуска она осталась заблокированной
		var path_str = str(button_path)
		if not Global.purchased_upgrades.has(path_str):
			Global.purchased_upgrades.append(path_str)

func check_purchased_upgrades() -> void:
	# Проверяет при входе в магазин, какие кнопки уже куплены, и блокирует их
	for button_path in Global.purchased_upgrades:
		var button = get_node_or_null(button_path) as Button
		if button:
			button.disabled = true

# --- ФУНКЦИИ ДЛЯ КНОПОК УЛУЧШЕНИЙ ---

func _on_auto_level_coin_button_pressed(extra_arg_0: NodePath) -> void:
	# Покупка автоматического дохода (за 150 монет)
	if Global.can_afford(150):
		Global.spend_coins(150)
		Global.auto_coin = true
		close_button(extra_arg_0)
		update_ui()

func _on_level_coin_button_pressed(extra_arg_0: NodePath, extra_arg_1: int, extra_arg_2: int) -> void:
	# Покупка улучшения клика (2з/сек, 4з/сек, 6з/сек)
	if Global.can_afford(extra_arg_1):
		Global.spend_coins(extra_arg_1)
		Global.coins_per_click = extra_arg_2
		close_button(extra_arg_0)
		update_ui()

func _on_button_all_pressed(button_path: NodePath, price: int, mult: int) -> void:
	# Покупка улучшения клика (x10 за 650 монет)
	if Global.can_afford(price):
		Global.spend_coins(price)
		Global.coins_per_click = Global.coins_per_click * mult
		close_button(button_path)
		update_ui()

# --- СЛУЖЕБНЫЕ КНОПКИ ---

func _on_down_button_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/main.tscn')

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/main.tscn')
