//
//  JQFoldHeaderFooterView.m
//  QQ列表折叠效果
//
//  Created by 韩军强 on 2017/11/9.
//  Copyright © 2017年 韩军强. All rights reserved.
//

#import "JQFoldHeaderFooterView.h"

@interface JQFoldHeaderFooterView()

@end

@implementation JQFoldHeaderFooterView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSLog(@"1111");
    
}


-(void)setModel:(FoldModel *)model
{
    _model = model;
    
    if (model.modelsArray.count) {
        self.jq_arrow.hidden = NO;
        if (model.isFold) {
            self.jq_arrow.transform = CGAffineTransformIdentity;
        }else{
            self.jq_arrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/180*90);
        }
    }else{
        self.jq_arrow.hidden = YES;
    }
    
    
    self.jq_head_label.text = model.jq_title;
}



@end
