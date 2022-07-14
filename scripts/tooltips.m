#include "..\..\..\lib/std.mi"

Global Group tipGroup;
Global Text tipText;
Global GuiObject tipBorder, tipBG;
Global Double layoutscale;

Global Container containerMain;
Global Layout layoutMainNormal;

System.onScriptLoaded() {

  containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");

  tipGroup = getScriptGroup();
  tipText = tipGroup.getObject("tooltip.text");
  tipBorder = tipGroup.getObject("tooltip.grid");
  tipBG = tipGroup.getObject("tooltip.grid.frame");

}

// When text is changed, resize the group accordingly and make sure it's fully visible

tipText.onTextChanged(String newtext) {

  tipText.setXmlParam("fontsize", "14");
  tipText.setXmlParam("x", "1");
  tipText.setXmlParam("y", "1");
  tipBorder.setXmlParam("h", "11");
  tipBG.setXmlParam("h", "9");

  int w = getTextWidth();
  int h = tipGroup.getHeight();

  int x = getMousePosX();
  int y = getMousePosY() - h+6; //follows behavior from windows

  int vpleft = getViewportLeftFromPoint(x, y);
  int vptop = getViewportTopFromPoint(x, y);
  int vpright = vpleft+getViewportWidthFromPoint(x, y);
  int vpbottom = vptop+getViewportHeightFromPoint(x, y);

  if (x + w > vpright) x = vpright - w;
  if (x < vpleft) x = vpleft;
  if (x + w > vpright) { w = vpright-vpleft-64; x = 32; }
  if (y + h > vpbottom) y = vpbottom - h;
  if (y < vptop) y = vptop + 32; // avoid mouse
  if (y + h > vpbottom) { h = vpbottom-vptop-64; y = 32; }

  tipGroup.resize(x, y, w, h-6);

}
