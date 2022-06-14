enum Font {
    Classic,
    Oswald
}

enum Unit {
    Imperial,
    Metric
}

[Setting name="Distance unit" category="General"]
Unit distanceUnit = Unit::Metric;

[Setting name="Font" category="General"]
Font fontFace = Font::Oswald;

[Setting name="Font size" min=8 max=60 category="General"]
int fontSize = 28;

[Setting name="UI Width" min=0.01 max=.3 category="General"]
float scaleX = .050;

[Setting name="UI Height" min=0.01 max=.3 category="General"]
float scaleY = .033;

[Setting name="Anchor X position" min=0 max=1 category="General"]
float anchorX = .969;

[Setting name="Anchor Y position" min=0 max=1 category="General"]
float anchorY = .971;

[Setting name="Show when GUI is hidden" category="General"]
bool showWhenGuiHidden = false;

[Setting color name="Box colour" category="General"]
vec4 boxColour = vec4(0, 0, 0, .6);

const float inchInMeter = 39.3700787;
const float feetInMeter = 3.2808399;
const float yardInMeter = 1.0936133;
const float mileInMeter = 0.000621371192;

nvg::Font fontOswald;
nvg::Font fontDigib;
nvg::Font font;

int shadowX = 1;
int shadowY = 1;

class GUI {
    double distance = 0;
    bool pluginEnabled = true;
    bool visible = true;
    bool guiHidden = false;

    GUI(){
	    fontOswald = nvg::LoadFont("Oswald-Regular.ttf");
	    fontDigib = nvg::LoadFont("DS-DIGIB.ttf");
    }

    void Render(){
        if(!pluginEnabled) return;

        font = fontFace == Font::Classic ? fontDigib : fontOswald;
        if((guiHidden && !showWhenGuiHidden) || !visible)
            return;
        nvg::FontFace(font);
        nvg::FontSize(fontSize);

        float screenScaleX = float(Draw::GetWidth()) / 2560;
        float screenScaleY = float(Draw::GetHeight()) / 1440;

        nvg::Save();
        nvg::Scale(screenScaleX, screenScaleY);
        RenderDefaultUI();
        nvg::Restore();
    }

    void RenderDefaultUI(){
        uint boxWidth = uint(scaleX * 2560);
        uint boxHeight = uint(scaleY * 1440);
        uint x = uint(anchorX * 2560 - boxWidth / 2);
        uint y = uint(anchorY * 1440 - boxHeight / 2);
        nvg::FontFace(font);

        nvg::BeginPath();
        nvg::RoundedRect(x, y, boxWidth, boxHeight, 10);
        nvg::FillColor(boxColour);
        nvg::Fill();
        nvg::ClosePath();

        string text;
        if(distanceUnit == Unit::Metric){
            if(distance < .994) {
                text = Text::Format("%.0f cm", distance * 100);
            } else if(distance > 1000) {
                text = Text::Format("%.1f km", distance / 1000);
            } else {
                text = Text::Format("%.0f m", distance);
            }
        }else{
            auto inches = distance * inchInMeter;
            auto feet = distance * feetInMeter;
            auto yards = distance * yardInMeter;
            auto miles = distance * mileInMeter;
            if(feet < 1) {
                text = Text::Format("%.0f\"", inches);
            } else if (yards < 1){
                text = Text::Format("%.0f'", feet);
            } else if (miles < 1){
                text = Text::Format("%.0f yd", yards);
            } else {
                text = Text::Format("%.1f mi", miles);
            }
        }
        nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);

        int textX = x;
        int textY = y + boxHeight / 2 + 2;
        
        // Shadow
        nvg::FillColor(vec4(0, 0, 0, 1));
        nvg::TextBox(textX + 1, textY + 1, boxWidth, text);

        // Text
        nvg::FillColor(vec4(1, 1, 1, 1));
        nvg::TextBox(textX, textY, boxWidth, text);
    }
}