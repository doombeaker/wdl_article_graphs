import general_config;

size(0, 15cm);

struct CSparseIDs{
    pair pos_;
    pen pdraw_;
    pen[] pfill_;

    void operator init(pair pos=(0,0), pen pdraw=defaultpen,
    pen pfill0=white, 
    pen pfill1=white, 
    pen pfill2=white, 
    pen pfill3=white){
        this.pos_ = pos;
        pfill_.push(pfill0);
        pfill_.push(pfill1);
        pfill_.push(pfill2);
        pfill_.push(pfill3);
    }
};

picture getSparseIDs(CSparseIDs sparseIds){
    picture pic;
    for(int i = 0; i < 4; ++i){
        pair center = (0, -i*(1.1SPARSEIDS_SLICE_HEIGHT));
        picture sparseSlice = getRect("", center, 
        SPARSEIDS_WIDTH,
        SPARSEIDS_SLICE_HEIGHT,
        pdraw= sparseIds.pdraw_,
        pfill= sparseIds.pfill_[i]
        );
        add(pic, sparseSlice);
    }
    return shift(sparseIds.pos_)*pic;
}

picture getMainPic(){
    picture pic;
    picture sparseIDsCpu = getSparseIDs(CSparseIDs((0,0), pfill0 = PEN_WITH_DATA,
                            pfill1 = PEN_WITH_DATA,
                            pfill2 = PEN_WITH_DATA,
                            pfill3 = PEN_WITH_DATA));
    add(pic, sparseIDsCpu);

    pair pt1 = (-0.5SPARSEIDS_WIDTH-SPARSEIDS_GPU_X_SPACE, SPARSEIDS_GPU_Y_SPACE);
    pair pt2 = (0.5SPARSEIDS_WIDTH+SPARSEIDS_GPU_X_SPACE, SPARSEIDS_GPU_Y_SPACE);
    pair pt0 = shift(-SPARSEIDS_WIDTH-SPARSEIDS_GPU_X_SPACE, 0)*pt1;
    pair pt3 = shift(SPARSEIDS_WIDTH+SPARSEIDS_GPU_X_SPACE,0)*pt2;
    picture sparseIDsGpu1 = getSparseIDs(CSparseIDs(pt1, pfill1 = PEN_WITH_DATA));
    picture sparseIDsGpu2 = getSparseIDs(CSparseIDs(pt2, pfill2 = PEN_WITH_DATA));
    picture sparseIDsGpu0 = getSparseIDs(CSparseIDs(pt0, pfill0 = PEN_WITH_DATA));
    picture sparseIDsGpu3 = getSparseIDs(CSparseIDs(pt3, pfill3 = PEN_WITH_DATA));

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

    picture[] BroadGPUsAry;
    for(int i = 0; i < ptAry.length; ++i){
        picture item;
        item = getSparseIDs(CSparseIDs(ptAry[i], 
                            pfill0 = PEN_WITH_DATA,
                            pfill1 = PEN_WITH_DATA,
                            pfill2 = PEN_WITH_DATA,
                            pfill3 = PEN_WITH_DATA));
        BroadGPUsAry.push(item);
        add(pic, item);
    }
    
    for(int i = 0; i < 4; ++i){
        draw(pic, point(sparseIDsCpu, N){up}..{up}point(sparseIDsGpuAry[i], S), Arrow);
    }

    pt0 = midpoint(point(BroadGPUsAry[1], E)--point(BroadGPUsAry[2], W));
    pt1 = midpoint(point(sparseIDsGpu1, E)--point(sparseIDsGpu2, W));
    pt2 = midpoint(pt0--pt1);
    
    picture allgatherOp = getCircle("$AllGather$", pt2, pfill=PEN_COMPUTE_OP);
    add(pic, allgatherOp);

    for(int i = 0; i < BroadGPUsAry.length; ++i){
        draw(pic, point(sparseIDsGpuAry[i], N){up}.. tension 2 ..{up}point(allgatherOp, S), Arrow);
        draw(pic, point(allgatherOp, N){up}.. tension 2 ..{up}point(BroadGPUsAry[i], S), Arrow);
    }

    label(pic, "$CPU$", point(sparseIDsCpu, N), N);
    label(pic, "$GPU0$", point(sparseIDsGpuAry[0], N), N);
    label(pic, "$GPU1$", point(sparseIDsGpuAry[1], N), N);
    label(pic, "$GPU2$", point(sparseIDsGpuAry[2], N), N);
    label(pic, "$GPU3$", point(sparseIDsGpuAry[3], N), N);

    label(pic, "$GPU0$", point(BroadGPUsAry[0], N), N);
    label(pic, "$GPU1$", point(BroadGPUsAry[1], N), N);
    label(pic, "$GPU2$", point(BroadGPUsAry[2], N), N);
    label(pic, "$GPU3$", point(BroadGPUsAry[3], N), N);

    label(pic, "$wide\_sparse\_fields$", 
                point(sparseIDsCpu, W), W);
    return pic;
}

add(getMainPic());