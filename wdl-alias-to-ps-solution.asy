import general_config;

size(30cm, 0);

picture getEmbedingTable(CSparseIDs sparseIds,
  real w = WIDE_EMBEDDING_TABLE_W,
  real slice_h = WIDE_EMBEDDING_TABLE_SLICE_H){
    return getSparseIDs(sparseIds, w, slice_h);
}

picture getLegend(){
    picture pic;
    real padding = -0.5;
    path linePath = (0,0)--(1.5,0);
    path[] lines;
    lines.push(shift(0, padding)*linePath);
    for(int i = 0; i < 2; ++i){
        lines.push(shift(0, padding)*lines[lines.length-1]);
    }

    draw(pic, lines[0], PEN_SPARSE_IDS);
    draw(pic, lines[1], PEN_PULL_MODEL);
    draw(pic, lines[2], PEN_PUSH_GRAD);

    label(pic, "$distribute\_gather$", midpoint(lines[0]), 5E);
    label(pic, "$Pull~Model$",midpoint(lines[1]), 5E);
    label(pic, "$Push~Grad$", midpoint(lines[2]), 5E);
    return pic;
}

picture getMainPic(){
    picture pic;
    picture[] EmbeddingTablesAry;
    picture[] SparseIDsAry;

    real shiftUnitX = 10;

    CSparseIDs[] CEmbedObjsAry;
    for(int i = 0; i < 4; ++i){
        CEmbedObjsAry.push(CSparseIDs(
            (shiftUnitX*i, 0),
            pdraw = invisible
        ));
    }
    CEmbedObjsAry[0].pfill_[0] = PEN_BLUE_DATA;
    CEmbedObjsAry[1].pfill_[1] = PEN_BLUE_DATA;
    CEmbedObjsAry[2].pfill_[2] = PEN_BLUE_DATA;
    CEmbedObjsAry[3].pfill_[3] = PEN_BLUE_DATA;

    for(int i = 0; i < CEmbedObjsAry.length; ++i){
        picture item = getEmbedingTable(CEmbedObjsAry[i]);
        add(pic, item);
        EmbeddingTablesAry.push(item);
    }


    real paddingSparse2Embeding = 5;
    CSparseIDs[] sparseIDObjsAry;
    for(int i = 0; i < EmbeddingTablesAry.length; ++i){
        pair ptCenter = shift(0, 1)*shift(-paddingSparse2Embeding, 0)*point(EmbeddingTablesAry[i], W);
        sparseIDObjsAry.push(CSparseIDs(
            ptCenter,
            pdraw=invisible
        ));
    }
    sparseIDObjsAry[0].pfill_[0] = PEN_WITH_DATA;
    sparseIDObjsAry[1].pfill_[1] = PEN_WITH_DATA;
    sparseIDObjsAry[2].pfill_[2] = PEN_WITH_DATA;
    sparseIDObjsAry[3].pfill_[3] = PEN_WITH_DATA;

    for(int i = 0; i < sparseIDObjsAry.length; ++i){
        picture item = getSparseIDs(sparseIDObjsAry[i]);
        SparseIDsAry.push(item);
        add(pic, item);
    }

    picture uniquePic = getRect("$Unique$", 
        shift(0, 0.5PS_Y_SPACE)*point(SparseIDsAry[0], N),
        SPARSEIDS_WIDTH,
        SPARSEIDS_SLICE_HEIGHT,
        invisible,
        PEN_WITH_DATA
        );
    label(pic, "$Unique$", point(uniquePic, 0));
    add(pic, uniquePic);

    CSparseIDs[] SplitEmbedObjsAry;
    picture[] SplitEmbedingAry;
    for(int i =0;i< EmbeddingTablesAry.length; ++i){
        SplitEmbedObjsAry.push(CSparseIDs(
            shift(-0.5paddingSparse2Embeding, 1.5PS_Y_SPACE)*point(EmbeddingTablesAry[i], N),
            pdraw=invisible
        ));
    }   
    SplitEmbedObjsAry[0].pfill_[0]=PEN_BLUE_DATA;
    SplitEmbedObjsAry[1].pfill_[1]=PEN_BLUE_DATA;
    SplitEmbedObjsAry[2].pfill_[2]=PEN_BLUE_DATA;
    SplitEmbedObjsAry[3].pfill_[3]=PEN_BLUE_DATA;

    for(int i = 0; i < SplitEmbedObjsAry.length; ++i){
        picture item = getEmbedingTable(SplitEmbedObjsAry[i]);
        add(pic, item);
        SplitEmbedingAry.push(item);
    }

    picture[] boxAry;
    real box_a = 8;
    for(int i=0; i < EmbeddingTablesAry.length; ++i){
        pair ptCenter = midpoint(point(SparseIDsAry[i], 0)--point(EmbeddingTablesAry[i], 0));
        picture item = getRect("", ptCenter,
        box_a, box_a, gray, invisible);
        add(pic, item);
        boxAry.push(item);
    }

    path uniqeDownLine = point(uniquePic, SW)--point(uniquePic, SE);
    path uniqeUpLine = point(uniquePic, NW)--point(uniquePic, NE);
    path[] sparseIDsPathAry;
    path[] pullModelAry;
    path[] pushGradAry;
    path[] updateModelAry;
    real uniqueDownPaddingRation = 0.04;
    real leftRationBegin = 0.3;

    for(int i=0; i < EmbeddingTablesAry.length; ++i){
        pair ptCenterUp = point(SplitEmbedingAry[i], N);
        pair ptCenterDown = point(SplitEmbedingAry[i], S);
        path centerLine = ptCenterUp--ptCenterDown;
        sparseIDsPathAry.push(point(uniquePic, N)--shift(-0.2SPARSEIDS_WIDTH, 0)*relpoint(centerLine, (i+1)*0.25));
        pullModelAry.push(relpoint(centerLine, (i+1)*0.25)--shift(1.3SPARSEIDS_WIDTH,0)*point(boxAry[0], N));
        pushGradAry.push(point(boxAry[0], N)--relpoint(centerLine, (i+1)*0.25));
    }

    for(int i = 0; i < SplitEmbedingAry.length; ++i){
        draw(pic, sparseIDsPathAry[i], PEN_SPARSE_IDS, Arrow);
        draw(pic, pullModelAry[i], PEN_PULL_MODEL, Arrow);
        draw(pic, pushGradAry[i], PEN_PUSH_GRAD, Arrow);
        label(pic, "$GPU"+string(i)+"$", point(boxAry[i], N), S);
        label(pic, "$GPU"+string(i)+"$", point(SplitEmbedingAry[i], N), N);
        label(pic, "$sparse\_ids$", point(SparseIDsAry[i], S), S);
        label(pic, "$embedding\_table$", point(EmbeddingTablesAry[i], SW), NW);
        label(pic, "$embedding\_table$", point(SplitEmbedingAry[i], NW), W);
    }

    path sparse2Uniqe = point(SparseIDsAry[0],N)--point(uniquePic,S);
    draw(pic, sparse2Uniqe, PEN_ID2UNIQUE, Arrow);

    label(pic, "1.", midpoint(sparse2Uniqe), W);
    label(pic, "2.", midpoint(sparseIDsPathAry[0]), W);
    label(pic, "3.", midpoint(pullModelAry[0]), W);
    label(pic, "4.", midpoint(pushGradAry[0]), W);

    picture legendPic = shift(0, -1)*shift(point(SplitEmbedingAry[3], S))*getLegend();
    add(pic, legendPic);
    return pic;
}

add(getMainPic());