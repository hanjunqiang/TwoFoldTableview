//
//  JQFoldHeaderFooterView.h
//  QQ列表折叠效果
//
//  Created by 韩军强 on 2017/11/9.
//  Copyright © 2017年 韩军强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldModel.h"

@interface JQFoldHeaderFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *jq_head_label;
@property (weak, nonatomic) IBOutlet UIImageView *jq_arrow;

@property (nonatomic, strong) FoldModel *model;

@end
