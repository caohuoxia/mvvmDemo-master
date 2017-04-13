//
//  BaseModel.h
//  mvvmDemo
//
//  Created by admin on 2017/4/13.
//  Copyright © 2017年 zhangjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger start;
@property(nonatomic, assign) NSInteger total;
//类别title，即将上映的电影
@property(nonatomic, strong) NSString *title;
@end
