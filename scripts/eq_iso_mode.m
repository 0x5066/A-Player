#include "..\..\..\lib/std.mi"
#include "..\..\..\lib/winampconfig.mi"

Global Group frameGroup;
Global GuiObject EQMODE;
Global WinampConfigGroup eqwcg;

#define ISOBANDS "31.5 Hz,63 Hz,125 Hz,250 Hz,500 Hz,1 KHz,2 KHz,4 KHz,8 KHz,16 KHz"
#define WINAMPBANDS "70 Hz,180 Hz,320 Hz,600 Hz,1 KHz,3 KHz,6 KHz,12 KHz,14 KHz,16 KHz"

System.onScriptLoaded() {
    eqwcg = WinampConfig.getGroup("{72409F84-BAF1-4448-8211-D84A30A1591A}");
    int freqmode = eqwcg.getInt("frequencies"); // returns 0 for classical winamp levels, 1 for ISO levels

    frameGroup = getScriptGroup();
    EQMODE = frameGroup.findObject("eq.mode");

    system.onEqFreqChanged(freqmode);
}

System.onEqFreqChanged(boolean isoonoff)
{
    if (isoonoff == 1)
    {
    EQMODE.setXmlParam("image", "eqlabel.iso");
    //messageBox("Equalizer mode is "+integerToString(isoonoff), "Equalizer mode", 1, "");
    }
    else
    {
    EQMODE.setXmlParam("image", "eqlabel.wa");
    //messageBox("Equalizer mode is "+integerToString(isoonoff), "Equalizer mode", 1, "");
    }
}