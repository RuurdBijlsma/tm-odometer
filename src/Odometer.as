class Odometer {
    Odometer() {
    }

    GUI gui = GUI();
    double distance = 0;

    void Tick(float dt) {
        // dt is ms since last frame
        gui.distance = distance;
        gui.visible = false;

        auto app = GetApp();
        auto isOnline = app.PlaygroundScript is null;
        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);

        gui.guiHidden = playground is null || 
            playground.Interface is null || 
            Dev::GetOffsetUint32(playground.Interface, 0x1C) == 0;

        if(playground is null
            || playground.Arena is null
            || playground.Map is null
            || playground.GameTerminals.Length <= 0)
                return;

        auto player = GetPlayer();
        if(player is null) return;
        if(player.ScriptAPI is null) return;
        auto scriptPlayer = cast<CSmScriptPlayer@>(player.ScriptAPI);

        if(isOnline) {
            if(scriptPlayer.CurrentRaceTime < 0)
                distance = 0;
            auto vis = VehicleState::ViewingPlayerState();
            if(vis is null) return;

            // Meters per second:
            auto velLength = vis.WorldVel.Length();
            auto tickMovedMeters = velLength / (1000 / dt);
            distance += tickMovedMeters;
        } else {
            distance = scriptPlayer.Distance;
        }

        gui.visible = true;
    }

    void Render(){
        gui.Render();
    }

    CSmPlayer@ GetPlayer() {
        auto app = cast<CTrackMania@>(GetApp());
        if(app is null) return null;
        auto playground = cast<CSmArenaClient@>(app.CurrentPlayground);
        if(playground is null) return null;
        if(playground.GameTerminals.Length < 1) return null;
        auto terminal = playground.GameTerminals[0];
        if(terminal is null) return null;
        return cast<CSmPlayer@>(terminal.ControlledPlayer);
    }
};