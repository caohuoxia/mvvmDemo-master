//
//  NetworkService.m
//  MyWeibo
//
//  Created by JohnJack on 16/1/27.
//  Copyright (c) 2016年 zjh. All rights reserved.
//

#import "NetworkService.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
//#import "AFHTTPSessionManager.h"

@implementation NetworkService

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  params:(NSDictionary *)params
                                 success:(SuccessBlock)sBlock
                                 failure:(FailureBlock)fBlock{
    //1.拼接完整字符串
    url = [NSString stringWithFormat:@"%@%@",@"https://api.douban.com",url];
    
    //2.设置完整的参数
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:params];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableLeaves];
    
 
//    NSURLSessionDataTask *dataTask = [manager POST:url parameters:mDic progress:^(NSProgress * _Nonnull uploadProgress) {
//         
//     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         sBlock(responseObject);
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         fBlock(error);
//     }];

    NSURLSessionDataTask *dataTask = [manager POST:url parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        sBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fBlock(error);
    }];
    
    return dataTask;
}

@end
