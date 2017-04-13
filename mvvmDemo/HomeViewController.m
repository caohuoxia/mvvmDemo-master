//
//  HomeViewController.m
//  mvvmDemo
//
//  Created by 张家欢 on 16/7/18.
//  Copyright © 2016年 zhangjiahuan. All rights reserved.
//

#import "HomeViewController.h"
#import "MovieViewModel.h"
#import "MovieCell.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *modelArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电影首页";
    self.view.backgroundColor = [UIColor redColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 80;
    [self.view addSubview:tableView];
    [tableView registerClass:[MovieCell class] forCellReuseIdentifier:@"MovieCell"];

    MovieViewModel *viewModel = [[MovieViewModel alloc] init];
    viewModel.returnBlock = ^(id returnValue){
        
        _modelArray = returnValue;
        [tableView reloadData];
    };
    viewModel.errorBlock = ^(id errorCode){
      
        NSLog(@"%@",errorCode);
    };
    
    [viewModel getMovieData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.model = _modelArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieViewModel *movieViewModel = [[MovieViewModel alloc] init];
    [movieViewModel movieDetailWithPublicModel:_modelArray[indexPath.row] WithViewController:self];
}

@end
