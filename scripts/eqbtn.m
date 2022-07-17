#include "..\..\..\lib/std.mi"

Global Group aplayer, eqg;
Global GuiObject eqbtn, ceqbtn, eqlabel, mwblocker;

Global Layout MainWindow;

Global int state;

Function animateWallpaper(int state);

System.onScriptLoaded() {

    MainWindow = getContainer("Main").getLayout("Normal");
    aplayer = MainWindow.findObject("mainwindow");
    //aeq = MainWindow.findObject("mainwindow");

    mwblocker = MainWindow.findObject("mwblocker");

    eqg = MainWindow.findObject("equalizer");
    eqbtn = aplayer.findObject("eq");
    eqlabel = MainWindow.findObject("eql");
    ceqbtn = eqg.findObject("ceq");

    state = 0;

    eqg.setTargetSpeed(0.5);
    eqlabel.setTargetSpeed(0.5);
    aplayer.setTargetSpeed(0.5);
    eqg.hide();
    eqlabel.hide();
}

eqbtn.onLeftButtonDown(int x, int y) {
    state = 1;
    eqg.show();
    eqlabel.show();

    eqg.setXmlParam("x", "-20");
    eqg.setTargetA(255);
    eqg.setTargetX(0);
    eqg.gotoTarget();

    eqlabel.setTargetA(255);
    eqlabel.gotoTarget();

    aplayer.setTargetX(20);
    aplayer.setTargetA(0);
    aplayer.gotoTarget();

    mwblocker.setXmlParam("ghost", "0");

    animateWallpaper(0);
}

ceqbtn.onLeftButtonDown(int x, int y) {
    state = 0;
    aplayer.show();

    aplayer.setXmlParam("x", "-20");

    eqg.setTargetX(20);
    eqg.setTargetA(0);
    eqg.gotoTarget();

    eqlabel.setTargetA(0);
    eqlabel.gotoTarget();

    aplayer.setTargetX(0);
    aplayer.setTargetA(255);
    aplayer.gotoTarget();
    aplayer.show();

    mwblocker.setXmlParam("ghost", "0");

    animateWallpaper(1);
}

aplayer.onTargetReached(){
    aplayer.hide();
    eqg.hide();
    eqlabel.hide();

    mwblocker.setXmlParam("ghost", "1");

    if (state == 0){
        aplayer.show();
    }else if (state == 1){
        eqg.show();
        eqlabel.show();
    }
}

animateWallpaper(int state){
    int layerCount = 3;

    for(int i = 0; i <= layerCount; i++){
        Layer stripe = MainWindow.findObject("wallpaper"+integertostring(i));

        if(i%2 == 1){
            stripe.setXmlParam("y", "-232");
            stripe.setTargetY(20);
        }else{
            stripe.setXmlParam("y", "20");
            stripe.setTargetY(-232);
        }
        
        // stripe.setTargetA(13 * state);            // nimate alpha as well
        stripe.setTargetSpeed(0.75 + (i*0.25));
        // stripe.setTargetSpeed(0.5);               // for a more consistent speed
        stripe.gotoTarget();
    }
}