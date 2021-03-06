/*---------------------------------------------------
-----------------------------------------------------
Filename:	wa2visualizer.m
Version:	2.1

Type:		maki
Date:		07. Okt. 2007 - 19:56 , May 24th 2021 - 2:13am UTC+1
Author:		Martin Poehlmann aka Deimos, Eris Lund (0x5066), mirzi
E-Mail:		martin@skinconsortium.com
Internet:	www.skinconsortium.com
			www.martin.deimos.de.vu

Note:		Ripped from Winamp Modern, removed the VU Meter section
			this also includes the option to set the Spectrum 
			Analyzer coloring.
			Now resides in skin.xml to hook into the Main Window and
			Playlist Editor.
-----------------------------------------------------
---------------------------------------------------*/

#include "..\..\..\lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);
//Function LegacyOptions(int legacy);
Function setVisModeLBD();
Function setVisModeRBD();
//Function setWA265Mode(int wa_mode);
//Function setFont(int font);

//Global GuiObject PlayIndicator, Songticker, Infoticker;

Global Group MainWindow, MainClassicVis/*, Clutterbar*/;
//Global Group MainShadeWindow, Vvis;
//Global Group VWindow;

Global Vis MainVisualizer/*, MainShadeVisualizer, Vvisualizer*/;
//Global AnimatedLayer MainShadeVULeft, MainShadeVURight;
//Global timer VU;
//Global float level1, level2, peak1, peak2, pgrav1, pgrav2, vu_falloffspeed;

//Global Button CLBV1, CLBV2, CLBV3;

Global PopUpMenu visMenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu anasettings;
Global PopUpMenu oscsettings;
Global PopUpMenu stylemenu;
Global PopUpMenu fpsmenu;
//Global PopUpMenu vumenu;

Global Int currentMode, a_falloffspeed, p_falloffspeed, osc_render, ana_render, v_fps/*, smoothvu*/;
Global Boolean show_peaks/*, isShade, compatibility, playLED, WA265MODE, WA5MODE, SKINNEDFONT*/;
Global layer MainTrigger, MainShadeTrigger, VTrigger;

//Global Layout WinampMainWindow;

System.onScriptLoaded()
{
	//WinampMainWindow = getContainer("Main").getLayout("Normal");

	MainWindow = getContainer("Main").getLayout("Normal");
	//PlayIndicator = MainWindow.findObject("playbackstatus");
	//Songticker = MainWindow.findObject("Songticker");
	//Infoticker = MainWindow.findObject("Infoticker");
	//Clutterbar = MainWindow.findObject("mainwindow");
	//CLBV1 = Clutterbar.getObject("CLB.V1");
	//CLBV2 = Clutterbar.getObject("CLB.V2");
	//CLBV3 = Clutterbar.getObject("CLB.V3");
	MainClassicVis = MainWindow.findObject("mainwindow");
	MainVisualizer = MainClassicVis.getObject("wa.vis");
	MainTrigger = MainClassicVis.getObject("main.vis.trigger");

	//MainShadeWindow = getContainer("Main").getLayout("shade");
	//MainShadeVisualizer = MainShadeWindow.findObject("wa.vis");
	//MainShadeVULeft = MainShadeWindow.findObject("wa.shade.vu.left");
	//MainShadeVURight = MainShadeWindow.findObject("wa.shade.vu.right");
	//MainShadeTrigger = MainShadeWindow.findObject("main.vis.trigger");

	//pgrav1 = 0;
	//pgrav2 = 0;

	//VU = new Timer;
	//VU.setdelay(16);
    //VU.start();
    //VU.onTimer();

	//vu_falloffspeed = (2/100)+0.02;

	//VWindow = getContainer("video").getLayout("normal");
	//Vvis = VWindow.findObject("video.visualization");
	//Vvisualizer = Vvis.getObject("wa.vis");
	//VTrigger = Vvis.getObject("main.vis.trigger");

	MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	/*MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainShadeVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainShadeVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	Vvisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	Vvisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	Vvisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	Vvisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	Vvisualizer.setXmlParam("bandwidth", integerToString(ana_render));*/
	refreshVisSettings();
}

setVisModeLBD(){
	currentMode++;

	if (currentMode == 3)
	{
		currentMode = 0;
	}

	setVis (currentMode);
	//setWA265Mode(WA265MODE);
	complete;
}

setVisModeRBD(){
	visMenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;
	anasettings = new PopUpMenu;
	oscsettings = new PopUpMenu;
	fpsmenu = new PopUpMenu;
	//vumenu = new PopUpMenu;

	visMenu.addCommand("Visualization mode:", 999, 0, 1);
	visMenu.addSeparator();
	visMenu.addCommand("Off", 100, currentMode == 0, 0);
	visMenu.addCommand("Spectrum analyzer", 1, currentMode == 1, 0);
	visMenu.addCommand("Oscilliscope", 2, currentMode == 2, 0);

	visMenu.addSeparator();
	//visMenu.addCommand("Main Window Settings", 998, 0, 1);
	//visMenu.addSeparator();

	visMenu.addSubmenu(fpsmenu, "Refresh rate");
	fpsmenu.addCommand("9fps", 800, v_fps == 0, 0);
	fpsmenu.addCommand("18fps", 802, v_fps == 2, 0);
	fpsmenu.addCommand("35fps", 803, v_fps == 3, 0);
	fpsmenu.addCommand("70fps", 804, v_fps == 4, 0);

	visMenu.addSubmenu(anasettings, "Spectrum analyzer options");

	anasettings.addCommand("Peaks", 101, show_peaks == 1, 0);
	anasettings.addSeparator();
	anasettings.addCommand("Thin bands", 701, ana_render == 1, 0);
	if(getDateDay(getDate()) == 1 && getDateMonth(getDate()) == 3){
		anasettings.addCommand("??????????????? ???????????????", 702, ana_render == 2, 0);
	}else{
		anasettings.addCommand("Thick bands", 702, ana_render == 2, 0);
	}
	anasettings.addSeparator();

	anasettings.addSubMenu(anamenu, "Analyzer falloff");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	anasettings.addSubMenu(pksmenu, "Peaks falloff");
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);

	visMenu.addSubmenu(oscsettings, "Oscilliscope Options");
	oscsettings.addCommand("Dot scope", 601, osc_render == 1, 0);
	oscsettings.addCommand("Line scope", 602, osc_render == 2, 0);
	oscsettings.addCommand("Solid scope", 603, osc_render == 3, 0);

	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;
	delete anasettings;
	delete oscsettings;
	delete fpsmenu;

	complete;	
}

refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	//compatibility = getPrivateInt(getSkinName(), "DeClassified Classic Visualizer behavior", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer Peaks falloff", 1);
	osc_render = getPrivateInt(getSkinName(), "Oscilloscope Settings", 3);
	ana_render = getPrivateInt(getSkinName(), "Spectrum Analyzer Settings", 1);
	v_fps = getPrivateInt(getSkinName(), "Visualizer Refresh rate", 3);

	MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	/*MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainShadeVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainShadeVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	Vvisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	Vvisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	Vvisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	Vvisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	Vvisualizer.setXmlParam("bandwidth", integerToString(ana_render));*/

	if (osc_render == 0)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			//Vvisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 1)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			//Vvisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 2)
		{
			MainVisualizer.setXmlParam("oscstyle", "Solid");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Solid");
			//Vvisualizer.setXmlParam("oscstyle", "Solid");
		}
		else if (osc_render == 3)
		{
			MainVisualizer.setXmlParam("oscstyle", "Lines");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Lines");
			//Vvisualizer.setXmlParam("oscstyle", "Lines");
		}
	setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
    
	if (ana_render == 0)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			//MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			//Vvisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 1)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			//MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			//Vvisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 2)
		{
			MainVisualizer.setXmlParam("bandwidth", "wide");
			//MainShadeVisualizer.setXmlParam("bandwidth", "wide");
			//Vvisualizer.setXmlParam("bandwidth", "wide");
		}
	setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);

	if (v_fps == 0)
		{
			MainVisualizer.setXmlParam("fps", "9");
			//MainShadeVisualizer.setXmlParam("fps", "9");
			//Vvisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 1)
		{
			MainVisualizer.setXmlParam("fps", "9");
			//MainShadeVisualizer.setXmlParam("fps", "9");
			//Vvisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 2)
		{
			MainVisualizer.setXmlParam("fps", "18");
			//MainShadeVisualizer.setXmlParam("fps", "18");
			//Vvisualizer.setXmlParam("fps", "18");
		}
		else if (v_fps == 3)
		{
			MainVisualizer.setXmlParam("fps", "35");
			//MainShadeVisualizer.setXmlParam("fps", "35");
			//Vvisualizer.setXmlParam("fps", "35");
		}
		else if (v_fps == 4)
		{
			MainVisualizer.setXmlParam("fps", "70");
			//MainShadeVisualizer.setXmlParam("fps", "70");
			//Vvisualizer.setXmlParam("fps", "70");
		}
	setPrivateInt(getSkinName(), "Visualizer Refresh rate", v_fps);

	setVis (currentMode);
}

MainTrigger.onLeftButtonDown (int x, int y)
{
	setVisModeLBD();
}

MainShadeTrigger.onLeftButtonDown (int x, int y)
{
	setVisModeLBD();
}

VTrigger.onLeftButtonDown (int x, int y)
{
	setVisModeLBD();
}

MainTrigger.onRightButtonUp (int x, int y)
{
	setVisModeRBD();
}

MainShadeTrigger.onRightButtonUp (int x, int y)
{
	setVisModeRBD();
}

VTrigger.onRightButtonUp (int x, int y)
{
	setVisModeRBD();
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		//MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		//Vvisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		//MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		//Vvisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer Peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		//MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		//Vvisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

else if (a >= 600 && a <= 603)
	{
		osc_render = a - 600;
		if (osc_render == 0)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			//Vvisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 1)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			//Vvisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 2)
		{
			MainVisualizer.setXmlParam("oscstyle", "Solid");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Solid");
			//Vvisualizer.setXmlParam("oscstyle", "Solid");
		}
		else if (osc_render == 3)
		{
			MainVisualizer.setXmlParam("oscstyle", "Lines");
			//MainShadeVisualizer.setXmlParam("oscstyle", "Lines");
			//Vvisualizer.setXmlParam("oscstyle", "Lines");
		}
	setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
	}

    else if (a >= 700 && a <= 702)
	{
		ana_render = a - 700;
		if (ana_render == 0)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			//MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			//Vvisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 1)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			//MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			//Vvisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 2)
		{
			MainVisualizer.setXmlParam("bandwidth", "wide");
			//MainShadeVisualizer.setXmlParam("bandwidth", "wide");
			//Vvisualizer.setXmlParam("bandwidth", "wide");
		}
	setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);
	}

	else if (a >= 800 && a <= 804)
	{
		v_fps = a - 800;
		if (v_fps == 0)
		{
			MainVisualizer.setXmlParam("fps", "9");
			//MainShadeVisualizer.setXmlParam("fps", "9");
			//Vvisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 1)
		{
			MainVisualizer.setXmlParam("fps", "9");
			//MainShadeVisualizer.setXmlParam("fps", "9");
			//Vvisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 2)
		{
			MainVisualizer.setXmlParam("fps", "18");
			//MainShadeVisualizer.setXmlParam("fps", "18");
			//Vvisualizer.setXmlParam("fps", "18");
		}
		else if (v_fps == 3)
		{
			MainVisualizer.setXmlParam("fps", "35");
			//MainShadeVisualizer.setXmlParam("fps", "35");
			//Vvisualizer.setXmlParam("fps", "35");
		}
		else if (v_fps == 4)
		{
			MainVisualizer.setXmlParam("fps", "70");
			//MainShadeVisualizer.setXmlParam("fps", "70");
			//Vvisualizer.setXmlParam("fps", "70");
		}
		setPrivateInt(getSkinName(), "Visualizer Refresh rate", v_fps);
	}
}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		MainVisualizer.setMode(0);
		//MainShadeVisualizer.setMode(0);
		//Vvisualizer.setMode(0);
	}
	else if (mode == 1)
	{
		MainVisualizer.setMode(1);
		//MainShadeVisualizer.setMode(1);
		//Vvisualizer.setMode(1);
	}
	else if (mode == 2)
	{
		MainVisualizer.setMode(2);
		//MainShadeVisualizer.setMode(2);
		//Vvisualizer.setMode(2);
	}
	currentMode = mode;
}