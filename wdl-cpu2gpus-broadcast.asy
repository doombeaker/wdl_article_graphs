import general_config;

size(15cm, 0);

picture getMainPic(){
    picture pic;
    picture sparseIDsCpu = getSparseIDs(CSparseIDs((0,0), 
                            pdraw = invisible,
                            pfill0 = PEN_WITH_DATA,
                            pfill1 = PEN_WITH_DATA,
                            pfill2 = PEN_WITH_DATA,
                            pfill3 = PEN_WITH_DATA));
    add(pic, sparseIDsCpu);

    pair pt1 = (-0.5SPARSEIDS_WIDTH-SPARSEIDS_GPU_X_SPACE, SPARSEIDS_GPU_Y_SPACE);
    pair pt2 = (0.5SPARSEIDS_WIDTH+SPARSEIDS_GPU_X_SPACE, SPARSEIDS_GPU_Y_SPACE);
    pair pt0 = shift(-SPARSEIDS_WIDTH-SPARSEIDS_GPU_X_SPACE, 0)*pt1;
    pair pt3 = shift(SPARSEIDS_WIDTH+SPARSEIDS_GPU_X_SPACE,0)*pt2;
    picture sparseIDsGpu1 = getSparseIDs(CSparseIDs(pt1, pdraw=invisible, pfill0 = PEN_WITH_DATA, pfill1 = PEN_WITH_DATA, pfill2 = PEN_WITH_DATA, pfill3 = PEN_WITH_DATA));
    picture sparseIDsGpu2 = getSparseIDs(CSparseIDs(pt2, pdraw=invisible, pfill0 = PEN_WITH_DATA, pfill1 = PEN_WITH_DATA, pfill2 = PEN_WITH_DATA, pfill3 = PEN_WITH_DATA));
    picture sparseIDsGpu0 = getSparseIDs(CSparseIDs(pt0, pdraw=invisible, pfill0 = PEN_WITH_DATA, pfill1 = PEN_WITH_DATA, pfill2 = PEN_WITH_DATA, pfill3 = PEN_WITH_DATA));
    picture sparseIDsGpu3 = getSparseIDs(CSparseIDs(pt3, pdraw=invisible, pfill0 = PEN_WITH_DATA, pfill1 = PEN_WITH_DATA, pfill2 = PEN_WITH_DATA, pfill3 = PEN_WITH_DATA));

    picture[] sparseIDsGpuAry;
    sparseIDsGpuAry.push(sparseIDsGpu0);
    sparseIDsGpuAry.push(sparseIDsGpu1);
    sparseIDsGpuAry.push(sparseIDsGpu2);
    sparseIDsGpuAry.push(sparseIDsGpu3);
    for(int i = 0; i<sparseIDsGpuAry.length;++i){
        add(pic, sparseIDsGpuAry[i]);
    }

    pair[] ptAry;
    real broadYPadding = 2SPARSEIDS_GPU_Y_SPACE;
    pt0 = shift(0, broadYPadding)*point(sparseIDsGpu0, (0,0));
    pt1 = shift(0, broadYPadding)*point(sparseIDsGpu1, (0,0));
    pt2 = shift(0, broadYPadding)*point(sparseIDsGpu2, (0,0));
    pt3 = shift(0, broadYPadding)*point(sparseIDsGpu3, (0,0));
    ptAry.push(pt0);
    ptAry.push(pt1);
    ptAry.push(pt2);
    ptAry.push(pt3);

    for(int i = 0; i < 4; ++i){
        draw(pic, point(shift(0, SPARSEIDS_SLICE_HEIGHT)*sparseIDsCpu, N)--point(sparseIDsGpuAry[i], S), Arrow);
    }
    label(pic, "$CPU$", point(sparseIDsCpu, N), N);
    label(pic, "$GPU0$", point(sparseIDsGpuAry[0], N), N);
    label(pic, "$GPU1$", point(sparseIDsGpuAry[1], N), N);
    label(pic, "$GPU2$", point(sparseIDsGpuAry[2], N), N);
    label(pic, "$GPU3$", point(sparseIDsGpuAry[3], N), N);

    label(pic, "$sparse~ids$", 
                point(sparseIDsCpu, W), W);
    return pic;
}

add(getMainPic());