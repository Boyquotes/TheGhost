extends Label3D

var text_queue : Array[String] = [""]:
	set(value):
		text_queue = value
		print(text_queue)
		

var is_cleaning = false

var is_filling = false

func _process(delta):
	if (text_queue.size() >= 1) && !is_cleaning && !is_filling :
		clean_text()
		if (!is_cleaning):
			fill_text()

func update_text(new_text : String):
	text_queue.append(new_text)

func clean_text():
	is_cleaning = true
	while text.length() >= 1:
		text = text.left(-1)
		await get_tree().create_timer(0.03).timeout
	is_cleaning = false
	
func fill_text():
	is_filling = true
	var next_text = text_queue.pop_front()
	for c in next_text:
		text += c
		await get_tree().create_timer(0.09).timeout
	is_filling = false
