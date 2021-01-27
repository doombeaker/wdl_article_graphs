pen PEN_VARIABLE = rgb("#32c1f1");
pen PEN_CAST_OP = rgb("f1c232");
pen PEN_COMPUTE_OP = rgb("f13262");
pen PEN_TENSOR_LINE = black;
pen PEN_WITH_DATA = rgb("#f1c232");
pen PEN_BLANK_DATA = palegray;
pen PEN_BLUE_DATA = rgb("#32c1f1");

real R_OP = 1;
real WIDTH_VARIABLE = 5;
real HEIGHT_VARIABLE = 1;
real VERTICAL_PADDINNG = 6;
real SPARSEIDS_WIDTH = 2;
real SPARSEIDS_SLICE_HEIGHT=0.5;
real SPARSEIDS_GPU_Y_SPACE = 4;
real SPARSEIDS_GPU_X_SPACE = 0.5;
real WIDE_EMBEDDING_TABLE_W = 1;
real WIDE_EMBEDDING_TABLE_SLICE_H = 1.7;
real TINY_PADDING = 0.1;

struct CSparseIDs{
    pair pos_;
    pen pdraw_;
    pen[] pfill_;

    void operator init(pair pos=(0,0), pen pdraw=defaultpen,
    pen pfill0=PEN_BLANK_DATA, 
    pen pfill1=PEN_BLANK_DATA, 
    pen pfill2=PEN_BLANK_DATA, 
    pen pfill3=PEN_BLANK_DATA){
        this.pos_ = pos;
        this.pdraw_ = pdraw;
        pfill_.push(pfill0);
        pfill_.push(pfill1);
        pfill_.push(pfill2);
        pfill_.push(pfill3);
    }
};

picture getRect(string s = "", pair ptCenter=(0,0), 
                real w = WIDTH_VARIABLE, real h = HEIGHT_VARIABLE, 
                pen pdraw = defaultpen,
                pen pfill = defaultpen){
  picture pic;
  pair d=(w,h);
  path box_path = box(-d/2,d/2);
  draw(pic, box_path, pdraw);
  fill(pic, box_path, pfill);
  label(pic,s,(0,0));
  return shift(ptCenter)*pic;
}

picture getSparseIDs(CSparseIDs sparseIds,
  real w = SPARSEIDS_WIDTH,
  real slice_h = SPARSEIDS_SLICE_HEIGHT){
    picture pic;
    for(int i = 0; i < 4; ++i){
        pair center = (0, -i*(0.1 + slice_h));
        picture sparseSlice = getRect("", center, 
        w,
        slice_h,
        pdraw= sparseIds.pdraw_,
        pfill= sparseIds.pfill_[i]
        );
        add(pic, sparseSlice);
    }
    return shift(sparseIds.pos_)*pic;
}

picture getCircle(string s="", pair pos=(0,0), real r = R_OP, pen pdraw = defaultpen, pen pfill=PEN_COMPUTE_OP)
{
    picture pic;
    path pt_circle = circle(pos, r);
    draw(pic, pt_circle, pdraw);
    fill(pic, pt_circle, pfill);
    label(pic, s, pos, pdraw);
    return pic;
}