//
//  FoldModel.h
//  QQ列表折叠效果
//
//  Created by 韩军强 on 2017/11/9.
//  Copyright © 2017年 韩军强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoldModel : NSObject

@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, strong) NSString *jq_title;
@property (nonatomic, strong) NSMutableArray *modelsArray;

@end
