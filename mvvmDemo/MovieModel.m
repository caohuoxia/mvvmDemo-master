//
//  MovieModel.m
//  mvvmDemo
//
//  Created by 张家欢 on 16/7/18.
//  Copyright © 2016年 zhangjiahuan. All rights reserved.
//

#import "MovieModel.h"

@implementation ImageModel

@end

@implementation MovieItemModel

@end

@implementation MovieModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"subjects":@"MovieItemModel"
             };
}
@end
