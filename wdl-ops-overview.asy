import general_config;

size(20cm, 0);

void _labelSBP(picture pic, picture item, string s0="", string s1=""){
    label(pic, s0, point(item, N), 2E+N);
    label(pic, s1,  point(item, S), 2E+S);
}

void labelSBPs(picture dst, picture[] items, 
             string[] s0, string[] s1, int cnt){
    for(int i = 0; i < cnt; ++i){
        _labelSBP(dst, items[i], s0[i], s1[i]);
    }
}


struct tagOp{
    string name_;
    pen fillp_;

    void operator init(string name = "", pen fillp = defaultpen){
        this.name_ = name;
        this.fillp_ = fillp;
    }
}

picture getMainPic(){
    picture pic;
    string[] wide_variables = {
        "$wide\_sparse\_fields$",
        "$wide\_embedding$",
        "$wide\_embedding$",
        "$wide\_scores$",
        "$scores$", 
        "$loss$"           
        };
    picture[] vars_wide_pic_ary;
    real wide_x_pos = -3;
    for(int i = 0; i < wide_variables.length; ++i){
        picture pic_item;
        write(wide_variables[i]);
        pic_item = getRect(wide_variables[i], (wide_x_pos, -i*VERTICAL_PADDINNG),
        pdraw=white,
        pfill=PEN_VARIABLE);
        vars_wide_pic_ary.push(pic_item);
        add(pic, pic_item);
    }

    string[] deep_variables = {
        "$deep\_sparse\_fields$",
        "$deep\_embedding$",
        "$deep\_embedding$",
        "$deep\_features$",
        "$deep\_scores$"        
        };
    picture[] vars_deep_pic_ary;
    real deep_x_pos = 3;
    for(int i = 0; i < deep_variables.length; ++i){
        picture pic_item;
        write(deep_variables[i]);
        pic_item = getRect(deep_variables[i], (deep_x_pos, -i*VERTICAL_PADDINNG),
        pdraw=white,
        pfill=PEN_VARIABLE);
        vars_deep_pic_ary.push(pic_item);
        add(pic, pic_item);
    }

    picture[] vars_wideops_pic_ary;
    tagOp[] wide_ops = {
        tagOp("$gather$", PEN_COMPUTE_OP),
        tagOp("$reshape$", PEN_COMPUTE_OP),
        tagOp("$reduce\_sum$", PEN_COMPUTE_OP),
        tagOp("$+$", PEN_COMPUTE_OP),
        tagOp("$sigmoid\_cross\_entropy\_with\_logits$", PEN_COMPUTE_OP)
    };

    for(int i = 0; i < wide_ops.length; ++i){
        picture pic_item;
        pair ptCenter = midpoint(point(vars_wide_pic_ary[i], S)--point(vars_wide_pic_ary[i+1], N));
        pic_item = getCircle(wide_ops[i].name_, ptCenter, pfill=wide_ops[i].fillp_);
        vars_wideops_pic_ary.push(pic_item);
    }

    for(int i = 0; i < vars_wideops_pic_ary.length-1; ++i){
        add(pic, vars_wideops_pic_ary[i]);
    }
    label(pic, "$sigmoid\_cross\_entropy\_with\_logits$", point(vars_wideops_pic_ary[vars_wideops_pic_ary.length-1], 0));

    tagOp[] deep_ops = {
        tagOp("$gather$", PEN_COMPUTE_OP),
        tagOp("$reshape$", PEN_COMPUTE_OP),
        tagOp("$concat$", PEN_COMPUTE_OP),
        tagOp("$FCs$", PEN_COMPUTE_OP)
    };
    picture[] vars_deepops_pic_ary;
    for(int i = 0; i < deep_ops.length; ++i){
        picture pic_item;
        pair ptCenter = midpoint(point(vars_deep_pic_ary[i], S)--point(vars_deep_pic_ary[i+1], N));
        pic_item = getCircle(deep_ops[i].name_, ptCenter, pfill=deep_ops[i].fillp_);
        add(pic, pic_item);
        vars_deepops_pic_ary.push(pic_item);
    }

    picture wide_embedding_table = \
        getRect("$wide\_embedding\_table$", 
        point(vars_wideops_pic_ary[0], W)+(-3-WIDTH_VARIABLE/2, 0),
        pdraw=white,
        pfill=PEN_VARIABLE);
    add(pic, wide_embedding_table);
    draw(pic, point(wide_embedding_table, E)--point(vars_wideops_pic_ary[0], W), Arrow);

    picture deep_embedding_table = \
        getRect("$deep\_embedding\_table$", 
        point(vars_deepops_pic_ary[0], E)+(3+WIDTH_VARIABLE/2, 0),
        pdraw=white,
        pfill=PEN_VARIABLE);
    add(pic, deep_embedding_table);
    draw(pic, point(deep_embedding_table, W)--point(vars_deepops_pic_ary[0], E), Arrow);

    picture dense_fields = \
        getRect("$dense\_fields$", 
        point(vars_deepops_pic_ary[2], E)+(3+WIDTH_VARIABLE/2, 0),
        pdraw=white,
        pfill=PEN_VARIABLE);
    add(pic, dense_fields);
    draw(pic, point(dense_fields, W)--point(vars_deepops_pic_ary[2], E), Arrow);

    for(int i=0; i < vars_wide_pic_ary.length-1; ++i){
        pair line1_pt_begin = point(vars_wide_pic_ary[i], S);
        pair line1_pt_end = point(vars_wideops_pic_ary[i], N);
        draw(pic, line1_pt_begin--line1_pt_end, Arrow);

        pair line2_pt_begin = point(vars_wideops_pic_ary[i], S);
        pair line2_pt_end = point(vars_wide_pic_ary[i+1], N);
        draw(pic, line2_pt_begin--line2_pt_end, Arrow);
    }

    for(int i=0; i < vars_deep_pic_ary.length-1; ++i){
        pair line1_pt_begin = point(vars_deep_pic_ary[i], S);
        pair line1_pt_end = point(vars_deepops_pic_ary[i], N);
        draw(pic, line1_pt_begin--line1_pt_end, Arrow);

        pair line2_pt_begin = point(vars_deepops_pic_ary[i], S);
        pair line2_pt_end = point(vars_deep_pic_ary[i+1], N);
        draw(pic, line2_pt_begin--line2_pt_end, Arrow);
    }

    draw(pic, point(vars_deep_pic_ary[4],W){left}..{left}point(vars_wideops_pic_ary[3], E), Arrow);   
    return pic;
}

add(getMainPic());