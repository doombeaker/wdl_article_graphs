import general_config;
size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


real rsize = 0.7;
real shiftUnit = 3;
pen fillblockpen = RGB(173,215,255);
pen notexistpen = dashed;

void fillBlock(picture boxPic, pen p=fillblockpen)
{
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = point(boxPic, SE);
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = point(boxPic, NE);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

picture getCircle(string s, pair pos, pen p = white)
{
    picture pic;
    path pt_circle = circle(pos, rsize);
    filldraw(pic, pt_circle, p);
    label(pic, s, pos, fontsize(8pt));
    return pic;
}

picture getRect(string s="", pair z=(0,0), real w=1.2, real h = 1.2,pen pfill = white, pen pdraw=black) {
  picture pic;
  pair d=(w,h);
  path mybox = box(-d/2,d/2);
  fill(pic, mybox, pfill);
  draw(pic, mybox, pdraw);
  label(pic,s,(0,0));
  return shift(z)*pic;
}

picture getSplit0Pic()
{
    picture pic;
    real xshift = 1.3;
    real yshift = -1.3;
    picture logical1 = getRect("$1$");
    picture logical2 = getRect("$2$", (xshift, 0));
    picture logical3 = getRect("$3$", (0, yshift));
    picture logical4 = getRect("$4$", (xshift, yshift));
    picture logicalSubpic;
    add(logicalSubpic, logical1);
    add(logicalSubpic, logical2);
    add(logicalSubpic, logical3);
    add(logicalSubpic, logical4);
    add(pic, logicalSubpic);
    label("logical tensor", point(logicalSubpic, S), S);


    transform shiftRight = shift(5xshift, 0);
    picture phy_up_1 = shiftRight*getRect("$1$", fillblockpen);
    picture phy_up_2 = shiftRight*getRect("$2$", (xshift, 0), fillblockpen);
    picture phy_up_3 = shiftRight*getRect("", (0, yshift), white, notexistpen);
    picture phy_up_4 = shiftRight*getRect("", (xshift, yshift), white, notexistpen);
    picture phySubPic0;
    add(phySubPic0, phy_up_1);
    add(phySubPic0, phy_up_2);
    add(phySubPic0, phy_up_3);
    add(phySubPic0, phy_up_4);
    add(pic, phySubPic0);
    label("physhical tensor", point(phySubPic0, S), S);
    label("device 0", point(phySubPic0, N), 2N);

    transform shiftRight = shift(8xshift, 0);
    picture phy_down_1 = shiftRight*getRect("", white, notexistpen);
    picture phy_down_2 = shiftRight*getRect("", (xshift, 0), white, notexistpen);
    picture phy_down_3 = shiftRight*getRect("$3$", (0, yshift), fillblockpen);
    picture phy_down_4 = shiftRight*getRect("$4$", (xshift, yshift), fillblockpen);
    picture phySubPic1;
    add(phySubPic1, phy_down_1);
    add(phySubPic1, phy_down_2);
    add(phySubPic1, phy_down_3);
    add(phySubPic1, phy_down_4);
    add(pic, phySubPic1);
    label("physhical tensor", point(phySubPic1, S), S);
    label("device 1", point(phySubPic1, N), 2N);

    label("$split(axis=0)$", point(logicalSubpic, NW), 2N);
    return pic;
}

picture getSplit1Pic()
{
    picture pic;
    real xshift = 1.3;
    real yshift = -1.3;
    picture logical1 = getRect("$1$");
    picture logical2 = getRect("$2$", (xshift, 0));
    picture logical3 = getRect("$3$", (0, yshift));
    picture logical4 = getRect("$4$", (xshift, yshift));
    picture logicalSubpic;
    add(logicalSubpic, logical1);
    add(logicalSubpic, logical2);
    add(logicalSubpic, logical3);
    add(logicalSubpic, logical4);
    add(pic, logicalSubpic);
    label(pic, "logical tensor", point(logicalSubpic, S), S);


    transform shiftRight = shift(5xshift, 0);
    picture phy_up_1 = shiftRight*getRect("$1$", fillblockpen);
    picture phy_up_2 = shiftRight*getRect("", (xshift, 0), white, notexistpen);
    picture phy_up_3 = shiftRight*getRect("3", (0, yshift), fillblockpen);
    picture phy_up_4 = shiftRight*getRect("", (xshift, yshift), white, notexistpen);
    picture phySubPic0;
    add( phySubPic0, phy_up_1);
    add(phySubPic0, phy_up_2);
    add(phySubPic0, phy_up_3);
    add(phySubPic0, phy_up_4);
    add(pic, phySubPic0);
    label(pic, "physhical tensor", point(phySubPic0, S), S);
    label(pic, "device 0", point(phySubPic0, N), 2N);

    transform shiftRight = shift(8xshift, 0);
    picture phy_down_1 = shiftRight*getRect("", white, notexistpen);
    picture phy_down_2 = shiftRight*getRect("$2$", (xshift, 0), fillblockpen);
    picture phy_down_3 = shiftRight*getRect("", (0, yshift), white, notexistpen);
    picture phy_down_4 = shiftRight*getRect("$4$", (xshift, yshift), fillblockpen);
    picture phySubPic1;
    add(phySubPic1, phy_down_1);
    add(phySubPic1, phy_down_2);
    add(phySubPic1, phy_down_3);
    add(phySubPic1, phy_down_4);
    add(pic, phySubPic1);
    label(pic, "physhical tensor", point(phySubPic1, S), S);
    label(pic, "device 1", point(phySubPic1, N), 2N);

    label(pic, "$split(axis=1)$", point(logicalSubpic, NW), 2N);
    return pic;
}

picture getBroadcastPic()
{
    picture pic;
    real xshift = 1.3;
    real yshift = -1.3;
    picture logical1 = getRect("$1$");
    picture logical2 = getRect("$2$", (xshift, 0));
    picture logical3 = getRect("$3$", (0, yshift));
    picture logical4 = getRect("$4$", (xshift, yshift));
    picture logicalSubpic;
    add(logicalSubpic, logical1);
    add(logicalSubpic, logical2);
    add(logicalSubpic, logical3);
    add(logicalSubpic, logical4);
    add(pic, logicalSubpic);
    label(pic, "logical tensor", point(logicalSubpic, S), S);


    transform shiftRight = shift(5xshift, 0);
    picture phy_up_1 = shiftRight*getRect("$1$", fillblockpen);
    picture phy_up_2 = shiftRight*getRect("$2$", (xshift, 0), fillblockpen);
    picture phy_up_3 = shiftRight*getRect("$3$", (0, yshift), fillblockpen);
    picture phy_up_4 = shiftRight*getRect("$4$", (xshift, yshift), fillblockpen);
    picture phySubPic0;
    add(phySubPic0, phy_up_1);
    add(phySubPic0, phy_up_2);
    add(phySubPic0, phy_up_3);
    add(phySubPic0, phy_up_4);
    add(pic, phySubPic0);
    label(pic, "physhical tensor", point(phySubPic0, S), S);
    label(pic, "device 0", point(phySubPic0, N), 2N);

    transform shiftRight = shift(8xshift, 0);
    picture phy_down_1 = shiftRight*getRect("$1$", fillblockpen);
    picture phy_down_2 = shiftRight*getRect("$2$", (xshift, 0), fillblockpen);
    picture phy_down_3 = shiftRight*getRect("$3$", (0, yshift), fillblockpen);
    picture phy_down_4 = shiftRight*getRect("$4$", (xshift, yshift), fillblockpen);
    picture phySubPic1;
    add(phySubPic1, phy_down_1);
    add(phySubPic1, phy_down_2);
    add(phySubPic1, phy_down_3);
    add(phySubPic1, phy_down_4);
    add(pic, phySubPic1);
    label(pic, "physhical tensor", point(phySubPic1, S), S);
    label(pic, "device 1", point(phySubPic1, N), 2N);

    label(pic, "$broadcast$", point(logicalSubpic, NW), 2N);
    return pic;
}

picture getPartialSumPic()
{
    picture pic;
    real xshift = 1.3;
    real yshift = -1.3;
    picture logical1 = getRect("$1$");
    picture logical2 = getRect("$2$", (xshift, 0));
    picture logical3 = getRect("$3$", (0, yshift));
    picture logical4 = getRect("$4$", (xshift, yshift));
    picture logicalSubpic;
    add(logicalSubpic, logical1);
    add(logicalSubpic, logical2);
    add(logicalSubpic, logical3);
    add(logicalSubpic, logical4);
    add(pic, logicalSubpic);
    label(pic, "logical tensor", point(logicalSubpic, S), S);


    transform shiftRight = shift(5xshift, 0);
    picture phy_up_1 = shiftRight*getRect("$1$", fillblockpen);
    picture phy_up_2 = shiftRight*getRect("$1$", (xshift, 0), fillblockpen);
    picture phy_up_3 = shiftRight*getRect("$1$", (0, yshift), fillblockpen);
    picture phy_up_4 = shiftRight*getRect("$0$", (xshift, yshift), fillblockpen);
    picture phySubPic0;
    add(phySubPic0, phy_up_1);
    add(phySubPic0, phy_up_2);
    add(phySubPic0, phy_up_3);
    add(phySubPic0, phy_up_4);
    add(pic, phySubPic0);
    label(pic, "physhical tensor", point(phySubPic0, S), S);
    label(pic, "device 0", point(phySubPic0, N), 2N);

    transform shiftRight = shift(8xshift, 0);
    picture phy_down_1 = shiftRight*getRect("$0$", fillblockpen);
    picture phy_down_2 = shiftRight*getRect("$1$", (xshift, 0), fillblockpen);
    picture phy_down_3 = shiftRight*getRect("$2$", (0, yshift), fillblockpen);
    picture phy_down_4 = shiftRight*getRect("$4$", (xshift, yshift), fillblockpen);
    picture phySubPic1;
    add(phySubPic1, phy_down_1);
    add(phySubPic1, phy_down_2);
    add(phySubPic1, phy_down_3);
    add(phySubPic1, phy_down_4);
    add(pic, phySubPic1);
    label(pic, "physhical tensor", point(phySubPic1, S), S);
    label(pic, "device 1", point(phySubPic1, N), 2N);

    label(pic, "$partial~sum$", point(logicalSubpic, NW), 2N);
    return pic;
}

picture s0Pic = getSplit0Pic();
add(s0Pic);

pair leftBottom = min(s0Pic, true);
pair rightUp = max(s0Pic, true);
real padding = 0.1;
pair boxLeftBottm = (leftBottom.x - padding, leftBottom.y - padding);
pair boxRightBottm = (rightUp.x + padding, leftBottom.y - padding);
pair boxRightUp = (rightUp.x + padding, rightUp.y + padding);
pair boxLeftUp = (leftBottom.x - padding, rightUp.y + padding);

path outBox0 = xscale(0.8)*yscale(0.35)*shift(1.8, -0.6)*(boxLeftBottm--boxRightBottm--boxRightUp--boxLeftUp--cycle);
real yshift = -4.5;
transform shiftToDown = shift(0, yshift);
path outBox1 = shiftToDown*outBox0;
path outBox2 = shiftToDown*outBox1;
path outBox3 = shiftToDown*outBox2;

draw(outBox0);
draw(outBox1);
draw(outBox2);
draw(outBox3);



picture s1Pic = shiftToDown*getSplit1Pic();
add(s1Pic);

picture broadcastPic = shiftToDown*shiftToDown*getBroadcastPic();
add(broadcastPic);

picture partialSumPic = shiftToDown*shiftToDown*shiftToDown*getPartialSumPic();
add(partialSumPic);