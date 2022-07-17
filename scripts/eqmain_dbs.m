#include "..\..\..\lib/std.mi"
#include "..\..\..\lib/winampconfig.mi"

Global Group EQg;
Global Button btnm;
Global Boolean manual_set;
Global int freqmode;
Global WinampConfigGroup eqwcg;

Global Layout normal;

#define ISOBANDS "31.5 Hz,63 Hz,125 Hz,250 Hz,500 Hz,1 KHz,2 KHz,4 KHz,8 KHz,16 KHz"
#define WINAMPBANDS "70 Hz,180 Hz,320 Hz,600 Hz,1 KHz,3 KHz,6 KHz,12 KHz,14 KHz,16 KHz"

System.onScriptLoaded() {
	eqwcg = WinampConfig.getGroup("{72409F84-BAF1-4448-8211-D84A30A1591A}");
	freqmode = eqwcg.getInt("frequencies"); // returns 0 for classical winamp levels, 1 for ISO levels

	EQg = getScriptGroup();

	btnm = EQg.findObject("0db");
}

btnm.onLeftClick() {
	manual_set = 1;
	for(int i=0; i<10; i++) setEqBand(i, 1);
	manual_set = 0;
}

system.onEqBandChanged(int band, int value)
{
	if (manual_set) return;
	String t;
	Float f = value;
	f = f / 10.5;
	WinampConfigGroup eqwcg = WinampConfig.getGroup("{72409F84-BAF1-4448-8211-D84A30A1591A}");
	if (f >= 0) t = "EQ: " + translate(getToken(WINAMPBANDS,",",band)) + ": +" + floattostring(f, 1) + " "+ translate("dB");
	else t = "EQ: " + translate(getToken(WINAMPBANDS,",",band)) + ": " + floattostring(f, 1) + " "+ translate("dB");
}
