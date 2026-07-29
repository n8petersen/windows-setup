menu(type="taskbar" vis=key.shift() or key.lbutton() pos=0 title=app.name image=\uE249)
{
	item(title="config" image=\uE10A cmd='"@app.cfg"')
	item(title="manager" image=\uE0F3 admin cmd='"@app.exe"')
	item(title="directory" image=\uE0E8 cmd='"@app.dir"')
	item(title="version\t"+@app.ver vis=label col=1)
	item(title="docs" image=\uE1C4 cmd='https://nilesoft.org/docs')
	item(title="donate" image=\uE1A7 cmd='https://nilesoft.org/donate')
}
menu(where=@(this.count == 0) type='taskbar' image=icon.settings expanded=true)
{
	menu(title="Apps" image=\uE254)
	{
		item(title='Paint' image=\uE116 cmd='mspaint')
		item(title='Edge' image cmd='@sys.prog32\Microsoft\Edge\Application\msedge.exe')
		item(title='Calculator' image=\ue1e7 cmd='calc.exe')
		item(title=str.res('regedit.exe,-16') image cmd='regedit.exe')
	}
	menu(title="Window" image=\uE1FB)
	{
		item(title="Cascade Windows" cmd=command.cascade_windows)
		item(title="Show Windows Stacked" cmd=command.Show_windows_stacked)
		item(title="Show Windows Side By Side" cmd=command.Show_windows_side_by_side)
		sep
		item(title="Minimize All Windows" cmd=command.minimize_all_windows)
		item(title="Restore All Windows" cmd=command.restore_all_windows)
	}
	item(title=title.desktop image=icon.desktop cmd=command.toggle_desktop)
	item(title=title.settings image=icon.settings(auto, image.color1) cmd='ms-settings:')
	item(title="Task Manager" sep=both image=icon.task_manager cmd='taskmgr.exe')
	item(title="Taskbar Settings" sep=both image=inherit cmd='ms-settings:taskbar')
	item(vis=key.shift() title="Restart Explorer" image=\uE29A cmd=command.restart_explorer)
}