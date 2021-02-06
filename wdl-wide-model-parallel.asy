import general_config;

size(30cm, 0);

picture getEmbedingTable(CSparseIDs sparseIds,
  real w = WIDE_EMBEDDING_TABLE_W,
  real slice_h = WIDE_EMBEDDING_TABLE_SLICE_H){
    return getSparseIDs(sparseIds, w, slice_h);
}

picture drawVecLinesAtRel(picture dst ... real[] rations){
    picture pic;
    pair ptLeftUp = point(dst, NW);
    pair ptLeftDown = point(dst, SW);
    pair ptRightUp = point(dst, NE);
    pair ptRightDown = point(dst, SE);

    path lineLeft = ptLeftUp--ptLeftDown;
    path lineRight = ptRightUp--ptRightDown;
    for(int i = 0; i < rations.length; ++i){
        real ration = rations[i];
        draw(pic, relpoint(lineLeft, ration)--relpoint(lineRight, ration), PEN_BLUE_DATA);
    }
    return pic;
}

picture getMainPic(){
    picture pic;
    picture[] EmbeddingTablesAry;
    picture[] SparseIDsAry;

    real shiftUnitX = 10;

    picture item = getEmbedingTable(CSparseIDs((0,0), 
                            pdraw = invisible,
                            pfill0 = PEN_BLUE_DATA));
    EmbeddingTablesAry.push(item);

    item = getEmbedingTable(CSparseIDs((shiftUnitX,0), 
                            pdraw = invisible,
                            pfill1 = PEN_BLUE_DATA));
    EmbeddingTablesAry.push(item);

    item = getEmbedingTable(CSparseIDs((2shiftUnitX,0), 
                            pdraw = invisible,
                            pfill2 = PEN_BLUE_DATA));
    EmbeddingTablesAry.push(item);    

    item = getEmbedingTable(CSparseIDs((3shiftUnitX,0), 
                            pdraw = invisible,
                            pfill3 = PEN_BLUE_DATA));
    EmbeddingTablesAry.push(item); 

    for(int i = 0; i < EmbeddingTablesAry.length; ++i){
        add(pic, EmbeddingTablesAry[i]);
    }

    real paddingSparse2Embeding = 5;
    for(int i = 0; i < EmbeddingTablesAry.length; ++i){
        pair ptCenter = shift(-paddingSparse2Embeding, 0)*point(EmbeddingTablesAry[i], 0);
        picture item = getRect("", ptCenter, 
        SPARSEIDS_WIDTH,
        SPARSEIDS_WIDTH,
        invisible,
        PEN_WITH_DATA);
        SparseIDsAry.push(item);
    }

    for(int i = 0; i < SparseIDsAry.length; ++i){
        add(pic, SparseIDsAry[i]);
    }

    picture[] GPUBoxAry;
    for(int i=0; i < SparseIDsAry.length; ++i){
        pair ptCenter = midpoint(point(SparseIDsAry[i], 0)--point(EmbeddingTablesAry[i], 0));
        real box_w = 9;
        picture box = getRect("", ptCenter, box_w, box_w, dashed, invisible);
        add(pic, box);
        GPUBoxAry.push(box);
    }

    for(int i = 0; i < GPUBoxAry.length; ++i){
        label(pic, "GPU"+string(i), point(GPUBoxAry[i], N), S);
        label(pic, "$wide\_sparse\_fields$", point(SparseIDsAry[i], N), N+0.2E);
        label(pic, "$wide\_embedding\_table$", point(EmbeddingTablesAry[i], S), NW+3W);
    }

    picture[] wideEmbeddingAry;
    for(int i = 0; i < GPUBoxAry.length; ++i){
        pair ptCenter = shift(0, 10)*point(GPUBoxAry[i], N);
        picture item = getEmbedingTable(CSparseIDs(ptCenter, 
                            pdraw = invisible));
        wideEmbeddingAry.push(item);
        add(pic, item);
    }

    picture[] dataParallelEmbedingAry;
    CSparseIDs[] DPAryObjs;
    pair[] DPPositionsAry;
    for(int i = 0; i < wideEmbeddingAry.length; ++i){
        DPPositionsAry.push(shift(0, 8)*point(wideEmbeddingAry[i], N));
        DPAryObjs.push(CSparseIDs(DPPositionsAry[i], 
                    pdraw = invisible));
    }
    DPAryObjs[0].pfill_[0] = PEN_BLUE_DATA;
    DPAryObjs[1].pfill_[1] = PEN_BLUE_DATA;
    DPAryObjs[2].pfill_[2] = PEN_BLUE_DATA;
    DPAryObjs[3].pfill_[3] = PEN_BLUE_DATA;
    for(int i = 0; i < wideEmbeddingAry.length; ++i){
        picture item = getSparseIDs(DPAryObjs[i], w=WIDE_EMBEDDING_TABLE_W, slice_h=0.5WIDE_EMBEDDING_TABLE_SLICE_H);
        dataParallelEmbedingAry.push(item);
        add(pic, item);
    }

    path bszSparseidBrace = brace(point(SparseIDsAry[0], NE), point(SparseIDsAry[0], SE));
    path vocSizeBrace = brace(point(EmbeddingTablesAry[1], SW), point(EmbeddingTablesAry[1], NW));
    path modelParallelSizeBrace = brace(point(wideEmbeddingAry[0], SW), point(wideEmbeddingAry[0], NW));
    path dataParallelSizeBrace = brace(point(dataParallelEmbedingAry[0], SW), point(dataParallelEmbedingAry[0], NW));
    
    draw(pic, bszSparseidBrace);
    draw(pic, modelParallelSizeBrace);
    draw(pic, vocSizeBrace);
    draw(pic, dataParallelSizeBrace);
    label(pic, "$batch~size$", midpoint(bszSparseidBrace), E);
    label(pic, "$wide\_vocab\_size$", midpoint(vocSizeBrace), 0.5W);
    label(pic, "$batch~size$", midpoint(modelParallelSizeBrace), W);
    label(pic, "$batch~size$", midpoint(dataParallelSizeBrace), W);

    path DPUpBrace = brace(point(dataParallelEmbedingAry[0], NW), point(dataParallelEmbedingAry[0], NE));
    draw(pic, DPUpBrace);
    label(pic, "$1$", midpoint(DPUpBrace), N);

    path MPUpBrace = brace(point(wideEmbeddingAry[0], NW), point(wideEmbeddingAry[0], NE));
    draw(pic, MPUpBrace);
    label(pic, "$1$", midpoint(MPUpBrace), N);

    path EmbedUpBrace = brace(point(EmbeddingTablesAry[0], NW), point(EmbeddingTablesAry[0], NE));
    draw(pic, EmbedUpBrace);
    label(pic, "$1$", midpoint(EmbedUpBrace), N);

    //splitter line
    pair ptLeft = shift(-3,0)*midpoint(point(dataParallelEmbedingAry[0], S)--point(wideEmbeddingAry[0], N));
    pair ptRight = shift(3,0)*midpoint(point(dataParallelEmbedingAry[3], S)--point(wideEmbeddingAry[3], N));
    path splitter = ptLeft--ptRight;
    draw(pic, splitter, dashed+linewidth(1pt));
    label(pic, "$Data~Parallel$", relpoint(splitter, 0), 2N, fontsize(16pt));
    label(pic, "$Model~Parallel$", relpoint(splitter, 0), 2S, fontsize(16pt));

    label(pic, "$Split(0)$", relpoint(splitter, 0.5), 4N);
    label(pic, "$ReduceScatter~D*(P-1)$", relpoint(splitter, 0.5), 4S);
    label(pic, "$PartialSum$", relpoint(splitter, 0.5), 8S);
    
    pair ptMiddle = relpoint(splitter, 0.5);
    draw(pic, shift(0, -0.6)*ptMiddle--shift(0, 0.6)*ptMiddle, Arrow);
    
    add(pic, drawVecLinesAtRel(wideEmbeddingAry[0], 1/4*0.1, 1/4*0.5, 1/4*0.45, 1/4*0.7));
    add(pic, drawVecLinesAtRel(wideEmbeddingAry[1], 0.27, 0.3, 0.32, 0.44, 0.4, 0.33, 0.47));
    add(pic, drawVecLinesAtRel(wideEmbeddingAry[2], 0.51, 0.55, 0.56, 0.6, 0.73));
    add(pic, drawVecLinesAtRel(wideEmbeddingAry[3], 0.8, 0.9, 0.85, 0.97));
    
    for(int i = 0; i < EmbeddingTablesAry.length; ++i){
        draw(pic, point(GPUBoxAry[i], N)--point(wideEmbeddingAry[i], S), Arrow);
    }
    
    return pic;
}

add(getMainPic());