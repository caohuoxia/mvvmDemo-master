//
//  MovieViewModel.h
//  mvvmDemo
//
//  Created by 张家欢 on 16/7/18.
//  Copyright © 2016年 zhangjiahuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "NetworkService.h"
#import "MovieViewController.h"
#import "MJExtension.h"

typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);

@interface MovieViewModel : NSObject

@property (nonatomic,copy) ReturnValueBlock returnBlock;
@property (nonatomic,copy) ErrorCodeBlock errorBlock;

//获取电影数据
- (void)getMovieData;

//跳转到电影详情页
- (void)movieDetailWithPublicModel: (MovieModel *)movieModel WithViewController: (UIViewController *)superController;
@end
