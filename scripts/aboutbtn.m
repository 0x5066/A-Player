#include "..\..\..\lib/std.mi"

Global Group aplayer;
Global GuiObject earth, about;

System.onScriptLoaded() {

    aplayer = getScriptGroup();

    earth = aplayer.findObject("earth");
    about = aplayer.findObject("aboutaplayer");
}

about.onEnterArea(){
    //messagebox("Entered", "", 0, "");
    earth.setTargetA(255);
    earth.setTargetSpeed(0.75);
    earth.gotoTarget();
}

about.onLeaveArea(){
    //messagebox("Left", "", 0, "");
    earth.setTargetA(0);
    earth.setTargetSpeed(0.75);
    earth.gotoTarget();
}
