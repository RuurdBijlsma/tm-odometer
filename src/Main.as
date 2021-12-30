Odometer@ f = null;

void Main() {
    @f = Odometer();
}

void Update(float dt){
    f.Tick(dt);
}

void Render() {
    if(f !is null)
        f.Render();
}

void RenderMenu() {
	if (UI::MenuItem("\\$f70" + Icons::Registered + "\\$z Odometer", "", f.gui.pluginEnabled)) {
		f.gui.pluginEnabled = !f.gui.pluginEnabled;
	}
}