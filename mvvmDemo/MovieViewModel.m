//
//  MovieViewModel.m
//  mvvmDemo
//
//  Created by 张家欢 on 16/7/18.
//  Copyright © 2016年 zhangjiahuan. All rights reserved.
//

#import "MovieViewModel.h"

@implementation MovieViewModel

- (void)getMovieData{
    [NetworkService requestWithURL:@"/v2/movie/coming_soon" params:nil success:^(id result) {
        NSLog(@"%@",result);
        
        MovieModel *feed = [MovieModel mj_objectWithKeyValues:result];
        _returnBlock(feed.subjects);
        
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
        _errorBlock(error);
    }];
}

- (void)movieDetailWithPublicModel: (MovieItemModel *)movieItemModel WithViewController: (UIViewController *)superController{
    MovieViewController *movieVC = [[MovieViewController alloc] init];
    movieVC.url = movieItemModel.alt;
    [superController.navigationController pushViewController:movieVC animated:YES];
}
@end
