import general_config;
import three;

size(30cm, 0);

picture getEmbedingTable(CSparseIDs sparseIds,
  real w = WIDE_EMBEDDING_TABLE_W,
  real slice_h = WIDE_EMBEDDING_TABLE_SLICE_H){
    return getSparseIDs(sparseIds, w, slice_h);
}

picture _getOneCube(pen pfill=PEN_BLANK_DATA){
    picture pic;
    picture fwFace = getRect("", (0,0), 
    CUBE_WIDTH,
    CUBE_HEIGHT,
    defaultpen,
    pfill);

    // up face
    pair ptLefDown = point(fwFace, NW);
    pair ptRightDown = point(fwFace, NE);
    transform t = shift(1/8*CUBE_WIDTH, 1/8*CUBE_WIDTH);
    pair ptLeftUp = t*ptLefDown;
    pair ptRightUp = t*ptRightDown;
    
    path upFace = ptLefDown--ptLeftUp--ptRightUp--ptRightDown--cycle;
    
    pair ptLeftDown = point(fwFace, SE);
    pair ptLeftUp = point(fwFace, NE);
    pair ptRightUp = t*ptLeftUp;
    pair ptRightDown = t*ptLeftDown;
    path rightFace = ptLeftDown--ptLeftUp--ptRightUp--ptRightDown--cycle;
    
    add(pic, fwFace);
    draw(pic, upFace);
    fill(pic, upFace, pfill+0.2white);
    draw(pic, rightFace);
    fill(pic, rightFace, pfill);
    return pic;    
}
picture get3DCube(int colored){
    picture pic;
    picture[] cubes;
    for(int i = 0; i < 4; ++i){
        pen p = PEN_BLANK_DATA;
        if(3-i == colored){
            p = PEN_BLUE_DATA;
        }
        transform t = shift(-i*1/4*CUBE_WIDTH, i*(-TINY_PADDING-1/2CUBE_WIDTH));
        picture item = t*_getOneCube(p);
        add(pic, item);
    }
    return pic;
}

picture getMainPic(){
    picture pic;
    picture[] cubesAry;
    real shiftXUnit = 6;
    for(int i = 0; i < 4; ++i){
        picture item = shift(i*shiftXUnit, 0)*get3DCube(i);
        cubesAry.push(item);
        add(pic, item);
    }

    CSparseIDs[] SplitEmbeddingObjsAry;
    real shiftYUnit = 4;
    for(int i = 0; i < cubesAry.length; ++i){
        pair pt = shift(0, shiftYUnit)*point(cubesAry[i], N);
        SplitEmbeddingObjsAry.push(CSparseIDs(
            pt,
        pdraw= invisible)
        );
    }
    SplitEmbeddingObjsAry[0].pfill_[0] = PEN_BLUE_DATA;
    SplitEmbeddingObjsAry[1].pfill_[1] = PEN_BLUE_DATA;
    SplitEmbeddingObjsAry[2].pfill_[2] = PEN_BLUE_DATA;
    SplitEmbeddingObjsAry[3].pfill_[3] = PEN_BLUE_DATA;    
    
    picture[] SplitEmbedingAry;
    for(int i=0; i < SplitEmbeddingObjsAry.length;++i){
        picture item = getSparseIDs(SplitEmbeddingObjsAry[i],
        w=2,
        slice_h=0.5);
        add(pic, item);
        SplitEmbedingAry.push(item);
    }

    picture[] SparsIDs;
    for(int i = 0; i < cubesAry.length; ++i){
        pair ptCenter = shift(-0.3shiftXUnit, -shiftYUnit)*point(cubesAry[i], S);
        picture item = getRect("", ptCenter, 
        SPARSEIDS_WIDTH/2,
        SPARSEIDS_WIDTH/2,
        invisible,
        PEN_WITH_DATA);
        SparsIDs.push(item);
        add(pic, item);
    }

    CSparseIDs[] embeddingObjsAry;
    for(int i = 0; i < cubesAry.length; ++i){
        pair pt = shift(0.1shiftXUnit, -shiftYUnit)*point(cubesAry[i], S);
        embeddingObjsAry.push(CSparseIDs(
            pt,
            pdraw=invisible
        ));
    }

    embeddingObjsAry[0].pfill_[0]=PEN_BLUE_DATA;
    embeddingObjsAry[1].pfill_[1]=PEN_BLUE_DATA;
    embeddingObjsAry[2].pfill_[2]=PEN_BLUE_DATA;
    embeddingObjsAry[3].pfill_[3]=PEN_BLUE_DATA;

    picture[] EmbeddingTablesAry;
    for(int i=0; i<embeddingObjsAry.length;++i){
        picture item = getS1SparseIDs(embeddingObjsAry[i]);
        add(pic, item);
        EmbeddingTablesAry.push(item);
    }

    for(int i = 0; i<EmbeddingTablesAry.length; ++i){
        label(pic, "$deep\_sparse\_fields$", point(SparsIDs[i], S), S);
        label(pic, "$deep\_embedding\_table$", point(EmbeddingTablesAry[i], S), S);
        label(pic, "$deep\_embedding$", point(cubesAry[i], S), S);
        label(pic, "$GPU"+string(i)+"$", point(SplitEmbedingAry[i], N), N);
        label(pic, "$GPU"+string(i)+"$", shift(0, -2.3*shiftYUnit)*point(SplitEmbedingAry[i], N), N);
    }

    pair ptLeft = shift(-3,0)*midpoint(point(SplitEmbedingAry[0], S)--point(cubesAry[0], N));
    pair ptRight = shift(3,0)*midpoint(point(SplitEmbedingAry[3], S)--point(cubesAry[3], N));
    path splitter = ptLeft--ptRight;
    draw(pic, splitter, dashed+linewidth(1pt));
    label(pic, "$Data~Parallel$", relpoint(splitter, 0), 2N, fontsize(16pt));
    label(pic, "$Model~Parallel$", relpoint(splitter, 0), 2S, fontsize(16pt));

    label(pic, "$Split(0)$", relpoint(splitter, 0.5), 4N);
    label(pic, "$All2All~D*\frac{(P-1)}{P}$", relpoint(splitter, 0.5), 4S);
    label(pic, "$Split(2)$", relpoint(splitter, 0.5), 8S);

    pair ptMiddle = relpoint(splitter, 0.5);
    draw(pic, shift(0, -0.6)*ptMiddle--shift(0, 0.6)*ptMiddle, Arrow);

    return pic;
}

add(getMainPic());