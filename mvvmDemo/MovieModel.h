//
//  MovieModel.h
//  mvvmDemo
//
//  Created by 张家欢 on 16/7/18.
//  Copyright © 2016年 zhangjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ImageModel : NSObject
@property (copy, nonatomic) NSString *small;
@property (copy, nonatomic) NSString *large;
@property (copy, nonatomic) NSString *medium;
@end

@interface MovieItemModel : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *year;
@property (strong, nonatomic)ImageModel *images;
@property (copy, nonatomic) NSString *alt;
@end

@interface MovieModel : BaseModel
@property(nonatomic,strong) NSArray *subjects;
@end
