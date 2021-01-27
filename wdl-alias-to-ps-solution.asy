import general_config;

size(30cm, 0);

picture getEmbedingTable(CSparseIDs sparseIds,
  real w = WIDE_EMBEDDING_TABLE_W,
  real slice_h = WIDE_EMBEDDING_TABLE_SLICE_H){
    return getSparseIDs(sparseIds, w, slice_h);
}

picture getLegend(){
    picture pic;
    real padding = 0.5;
    path linePath = (0,0)--(1.5,0);
    path linePath2 = shift(0, padding)*linePath;
    path linePath3 = shift(0, padding)*linePath2;
    draw(pic, linePath, PEN_SPARSE_IDS);
    draw(pic, linePath2, PEN_PULL_MODEL);
    draw(pic, linePath3, PEN_PUSH_GRAD);
    label(pic, "$Sparse~Ids$", midpoint(linePath), 5E);
    label(pic, "$Pull~Model$",midpoint(linePath2), 5E);
    label(pic, "$Push~Model$",midpoint(linePath3), 5E);
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
        shift(0, 1.2PS_Y_SPACE)*midpoint(point(SparseIDsAry[0], W)--point(EmbeddingTablesAry[3], E)),
        4*2*SPARSEIDS_WIDTH,
        SPARSEIDS_SLICE_HEIGHT,
        invisible,
        PEN_UNIQUE_OP
        );
    add(pic, uniquePic);

    CSparseIDs[] SplitEmbedObjsAry;
    picture[] SplitEmbedingAry;
    for(int i =0;i< EmbeddingTablesAry.length; ++i){
        SplitEmbedObjsAry.push(CSparseIDs(
            shift(-0.5paddingSparse2Embeding, 1.5*PS_Y_SPACE)*point(EmbeddingTablesAry[i], N),
            pdraw=invisible
        ));
    }   
    SplitEmbedObjsAry[0].pfill_[0]=PEN_BLUE_DATA;
    SplitEmbedObjsAry[1].pfill_[1]=PEN_BLUE_DATA;
    SplitEmbedObjsAry[2].pfill_[2]=PEN_BLUE_DATA;
    SplitEmbedObjsAry[3].pfill_[3]=PEN_BLUE_DATA;

    for(int i = 0; i < SplitEmbedObjsAry.length; ++i){
        picture item = getSparseIDs(SplitEmbedObjsAry[i]);
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
    real uniqueDownPaddingRation = 0.04;
    real leftRationBegin = 0.3;
    for(int i=0; i < EmbeddingTablesAry.length; ++i){
        draw(pic, 
        point(SparseIDsAry[i],N)--relpoint(uniqeDownLine, leftRationBegin+i*uniqueDownPaddingRation), PEN_ID2UNIQUE, Arrow);
        
        draw(pic, 
        relpoint(uniqeDownLine, 0.7+i*uniqueDownPaddingRation)--point(EmbeddingTablesAry[i],N), PEN_UPDATE_MODEL, Arrow);        
        

        // center line up to down
        pair ptCenterUp = point(SplitEmbedingAry[i], N);
        pair ptCenterDown = point(SplitEmbedingAry[i], S);
        path centerLine = ptCenterUp--ptCenterDown;
        sparseIDsPathAry.push(relpoint(uniqeUpLine, leftRationBegin+uniqueDownPaddingRation*i)--shift(-0.45SPARSEIDS_WIDTH, 0)*relpoint(centerLine, (i+1)*0.25));
        pullModelAry.push(relpoint(centerLine, (i+1)*0.25)--relpoint(uniqeUpLine, leftRationBegin+uniqueDownPaddingRation*i));
        pushGradAry.push(relpoint(uniqeUpLine, leftRationBegin+uniqueDownPaddingRation*i)--shift(0.45SPARSEIDS_WIDTH, 0)*relpoint(centerLine, (i+1)*0.25));
    }

    for(int i = 0; i < SplitEmbedingAry.length; ++i){
        draw(pic, sparseIDsPathAry[i], PEN_SPARSE_IDS, Arrow);
        draw(pic, pullModelAry[i], PEN_PULL_MODEL, Arrow);
        draw(pic, pushGradAry[i], PEN_PUSH_GRAD, Arrow);
    }

    picture legendPic = shift(-8, 0)*shift(point(uniquePic, W))*getLegend();
    add(pic, legendPic);
    return pic;
}

add(getMainPic());