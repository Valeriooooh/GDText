extends Control

var app_name = "GDText"

var currentOS = OS.get_name()

var current_file = "Untitled"

var lang = 'Simple Text'

var editor = TextEdit.new()

func _ready() -> void:
	update_window_title()

#File Menu
	$FileMenu.get_popup().add_item("New File")
	_shortcut($FileMenu, 0, KEY_N, false)
	$FileMenu.get_popup().add_item("Open File")
	_shortcut($FileMenu, 1, KEY_O, false)
	$FileMenu.get_popup().add_item("Save")
	_shortcut($FileMenu, 2, KEY_S, false)
	$FileMenu.get_popup().add_item("Save as ...")
	_shortcut($FileMenu, 3, KEY_S, true)
	$FileMenu.get_popup().add_item('Run File')
	_shortcut($FileMenu, 4, KEY_R, false)
	$FileMenu.get_popup().add_item("Quit")
	_shortcut($FileMenu, 5, KEY_Q, false)

	$FileMenu.get_popup().connect("id_pressed", self, "_on_Item_pressed")
#---------------------------------------------------------------------------------
#ToolsMenu
	$ToolsMenu.get_popup().add_item("Zoom+")
	_shortcut($ToolsMenu, 0, KEY_PLUS, false)
	$ToolsMenu.get_popup().add_item("Zoom-")
	_shortcut($ToolsMenu, 1, KEY_MINUS, false)

	#help menu
	$HelpMenu.get_popup().add_item("About")
	$HelpMenu.get_popup().connect("id_pressed", self, "_on_Item_help_pressed")
	
	#teste
	if lang != 'Simple Text':
		$TextEdit.set_syntax_coloring(false)
		if lang == 'HTML':
			editor.syntax_highlighting = true
			_html_syntax()
	

func update_window_title():#updates the window title adding the file name after
	OS.set_window_title(app_name + ' - ' + current_file + ' (' + lang + ')')

func _on_Item_pressed(id):#Checks the options
	var file_item_name = $FileMenu.get_popup().get_item_text(id)
	
	print(file_item_name + ' pressed')
	if file_item_name == 'Open File':
		$OpenDialog.popup()
	elif file_item_name == 'Save':
		 save_file()
	elif file_item_name == 'Save as ...':
		$SaveDialog.popup()
	elif file_item_name == 'Quit':
		get_tree().quit()
	elif file_item_name == 'New File':
		new_file()
	elif file_item_name == 'Run File':
		_runFile(current_file)

func _on_Item_help_pressed(id):
	var help_item_name = $HelpMenu.get_popup().get_item_text(id)
	if help_item_name == 'About':
		$AboutDialog.popup()

func _on_Item_tools_pressed(id):
	var tools_item_name = $ToolsMenu.get_popup().get_item_text(id)
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://BarlowCondensed-Bold.ttf")
	print(tools_item_name + ' pressed')
	if tools_item_name == 'Zoom+':
		$TextEdit.dynamic_font.size += 5
	elif tools_item_name == 'Zoom-':
		$TextEdit.dynamic_font.size += 5
	
func new_file():#sets the file to blank and untitled
	current_file = "Untitled"
	update_window_title()
	$TextEdit.text = ''

func save_file():#saves the file
	if current_file == "Untitled":
		$SaveDialog.popup()
		lang = getlang(current_file)
	else:
		var f = File.new()
		f.open(current_file, 2)
		f.store_string($TextEdit.text)
		f.close()
		lang = getlang(current_file)
		update_window_title()

func _on_OpenDialog_file_selected(path: String) -> void: #opens the file to read
	## print(path)#debug
	var f = File.new()
	f.open(path, 1)	
	$TextEdit.text = f.get_as_text()
	f.close()
	current_file = path
	lang = getlang(current_file)
	update_window_title()

func _on_SaveDialog_file_selected(path: String) -> void: #saves the file 
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()
	current_file = path
	lang = getlang(current_file)
	update_window_title()

func _shortcut(var typeofmenu,var MenuNum, var _key, var shift):#creates the shortcuts for the menu
	var shortcut = ShortCut.new()
	var inputeventkey = InputEventKey.new()
	inputeventkey.set_scancode(_key)
	inputeventkey.control = true
	if shift == true:
		inputeventkey.shift = true
	shortcut.set_shortcut(inputeventkey) 
	
	typeofmenu.get_popup().set_item_shortcut(MenuNum, shortcut, true)

func getlang(file):#gets the language of the current program
	if file.ends_with(".html") or file.ends_with(".htm"): 
		lang = "HTML"
	elif file.ends_with(".py"):
		lang = "Python"
	return lang

func _runFile(file):#self explanatory :)
	if lang == 'HTML':
		OS.shell_open(file)
	elif lang == 'Python':
		print(currentOS)
		if currentOS == "X11":
			var rawargs = ["python", current_file]
			var args = PoolStringArray(rawargs)
			OS.execute("/usr/share/applications/org.kde.konsole.desktop", args, false) 

func _on_LinkButton_pressed() -> void:
	OS.shell_open("https://github.com/Valerioooo/GDText")


func _html_syntax():
	#
	for i in 1:
		editor.add_keyword_color("Godot", Color(0.6,1.0, 0.6, 1.0))


