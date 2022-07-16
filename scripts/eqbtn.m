#include "..\..\..\lib/std.mi"

Global Group aplayer, eqg;
Global GuiObject eqbtn, ceqbtn, eqlabel, mwblocker;

Global Layout MainWindow;

Global int imain, ieq;

System.onScriptLoaded() {

    MainWindow = getContainer("Main").getLayout("Normal");
    aplayer = MainWindow.findObject("mainwindow");
    //aeq = MainWindow.findObject("mainwindow");

    mwblocker = MainWindow.findObject("mwblocker");

    eqg = MainWindow.findObject("equalizer");
    eqbtn = aplayer.findObject("eq");
    eqlabel = MainWindow.findObject("eql");
    ceqbtn = eqg.findObject("ceq");

    imain == 0; //0 means main window is visible, 1 is invisible
    ieq == 0; //0 means eq is invisible, 1 is visible

    eqg.setTargetSpeed(0.5);
    eqlabel.setTargetSpeed(0.5);
    aplayer.setTargetSpeed(0.5);
    eqg.hide();
    eqlabel.hide();
}

eqbtn.onLeftButtonDown(int x, int y) {
    eqg.setTargetA(255);
    eqg.gotoTarget();

    eqlabel.setTargetA(255);
    eqlabel.gotoTarget();

    aplayer.setTargetA(0);
    aplayer.gotoTarget();

    //mwblocker.setXmlParam("ghost", "0");
    aplayer.hide();
    eqg.show();
    eqlabel.show();
}

ceqbtn.onLeftButtonDown(int x, int y) {
    eqg.setTargetA(0);
    eqg.gotoTarget();

    eqlabel.setTargetA(0);
    eqlabel.gotoTarget();

    aplayer.setTargetA(255);
    aplayer.gotoTarget();
    aplayer.show();
    eqg.hide();
    eqlabel.hide();
}
/*
aplayer.onTargetReached(){
    imain++;
    if(imain == 1){
        aplayer.hide();
    }if(imain >= 2){
        aplayer.show();
        imain == 0;
    }
    messagebox(integertostring(imain), "A-Player status", 0, "");
}*/