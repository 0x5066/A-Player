#include "..\..\..\lib/std.mi"
#include "..\..\..\lib\pldir.mi"

Global PlEdit PeListener;

Global text monoster, plpos;
Global timer getchanneltimer;
Global int c;

Function int getChannels();

System.onScriptLoaded(){
    PeListener = new PlEdit;
    
    Group player = getScriptGroup();

    monoster = player.findObject("monoster");
    plpos = player.findObject("plpos");

    getchanneltimer = new Timer;
	getchanneltimer.setDelay(250);

    c = getChannels();

    if(c == 2){
        monoster.setText("Stereo");
    }else if(c == 1){
        monoster.setText("Mono");
    }else if(c == -1){
        monoster.setText("");
    }
    plpos.setText("Track: "+integerToString(PeListener.getCurrentIndex()+1));
}

System.onResume()
{
	getchanneltimer.start();
}

System.onPlay()
{
	getchanneltimer.start();
    c = getChannels();
    if(c == 2){
        monoster.setText("Stereo");
    }else if(c == 1){
        monoster.setText("Mono");
    }else if(c == -1){
        monoster.setText("");
    }
    plpos.setText("Track: "+integerToString(PeListener.getCurrentIndex()+1));
}

System.onTitleChange(String newtitle)
{
	getchanneltimer.start();
    c = getChannels();
    if(c == 2){
        monoster.setText("Stereo");
    }else if(c == 1){
        monoster.setText("Mono");
    }else if(c == -1){
        monoster.setText("");
    }
    plpos.setText("Track: "+integerToString(PeListener.getCurrentIndex()+1));
}

System.onStop(){
    getchanneltimer.stop();
    monoster.setText("");
    plpos.setText("Track: "+integerToString(PeListener.getCurrentIndex()+1));
}

getchanneltimer.onTimer ()
{
    c = getChannels();
    if(c == 2){
        monoster.setText("Stereo");
    }else if(c == 1){
        monoster.setText("Mono");
    }else if(c == -1){
        monoster.setText("");
    }
    plpos.setText("Track: "+integerToString(PeListener.getCurrentIndex()+1));
}

Int getChannels()
{
	if (strsearch(getSongInfoText(), "tereo") != -1)
	{
		return 2;
        
	}
	else if (strsearch(getSongInfoText(), "ono") != -1)
	{
		return 1;
	}
	else if (strsearch(getSongInfoText(), "annels") != -1)
	{
		int pos = strsearch(getSongInfoText(), "annels");
		return stringToInteger(strmid(getSongInfoText(), pos - 4, 1));
	}
	else
	{
		return -1;
	}
}