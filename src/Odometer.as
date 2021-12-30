class Odometer {
    Odometer() {
    }

    GUI gui = GUI();
    double distance = 0;

    void Tick(float dt) {
        // dt is ms since last frame
        gui.distance = distance;

        auto app = GetApp();
        auto isEditor = app.Editor !is null;
        auto isOnline = app.PlaygroundScript is null;
        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);

        gui.guiHidden = playground is null || 
            playground.Interface is null || 
            Dev::GetOffsetUint32(playground.Interface, 0x1C) == 0;

        gui.visible = false;
        if(playground is null
            || playground.Arena is null
            || playground.Map is null
            || playground.GameTerminals.Length <= 0)
                return;

        auto player = GetViewingPlayer(playground);
        if(player is null) return;
        if(player.ScriptAPI is null) return;

        if(isOnline) {
            if(player.ScriptAPI.CurrentRaceTime < 0)
                distance = 0;
            auto vis = GetVehicleVis(app, playground);
            if(vis is null) return;

            auto velocity = vis.AsyncState.WorldVel;
            // Meters per second:
            auto velLength = velocity.Length();
            auto tickMovedMeters = velLength / (1000 / dt);
            distance += tickMovedMeters;
        } else {
            distance = player.ScriptAPI.Distance;
        }

        gui.visible = true;
    }

	CSmPlayer@ GetViewingPlayer(CSmArenaClient@ playground) {
		if (playground is null || playground.GameTerminals.Length != 1) {
			return null;
		}
		return cast<CSmPlayer>(playground.GameTerminals[0].GUIPlayer);
	}

    CSceneVehicleVis@ GetVehicleVis(CGameCtnApp@ app, CSmArenaClient@ playground) {
		auto sceneVis = app.GameScene;
		if (sceneVis is null)
			return null;
		CSceneVehicleVis@ vis = null;

        auto player = GetViewingPlayer(playground);
        if (player !is null) {
            @vis = Vehicle::GetVis(sceneVis, player);
        } else {
            @vis = Vehicle::GetSingularVis(sceneVis);
        }

        if (vis is null) 
            return null;
        return vis;
    }

    void Render(){
        gui.Render();
    }
};