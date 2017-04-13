
原文链接，http://blog.cocoachina.com/article/34636

非常感谢上面网友的分享，以下都是来自他的阐述。只是download之后，为了熟悉代码，稍稍进行了如下两处改动：
* 使用MJExtension解析model
* 使用cocoapod管理第三方库


###朋友的鼓励是我继续分享的动力，动动小手点击右上角的✨Star✨，让我知道你来过。。。
                                                                                      
#开篇
MVC
Model-View-Controller是一个用来组织代码的权威范式。Apple甚至是这么说的。在MVC下，所有的对象被归类为一个model，一个view，或一个controller。Model持有数据，View显示与用户交互的界面，而View Controller调解Model和View之间的交互。
MVVM
MVVM的出现主要是为了解决在开发过程中Controller越来越庞大的问题，变得难以维护，所以MVVM把数据加工的任务从Controller中解放了出来，使得Controller只需要专注于数据调配的工作，ViewModel则去负责数据加工并通过通知机制让View响应ViewModel的改变。
#效果图
![Simulator Screen Shot 2016年7月18日 下午3.56.39.png](http://upload-images.jianshu.io/upload_images/1303032-5a790d35e0d08ee6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#源码分析
#####1.Model模块
首先是model层的代码，创建MovieModel类，继承自NSObject。设置几个属性movieName、year、imageUrl、detailUrl（用于跳转）
```
#import <Foundation/Foundation.h>

@interface MovieModel : NSObject
@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *detailUrl;
@end
```
#####ViewController模块
ViewController里面是用来从MovieViewModel中获取数据信息然后展示到UITableView的cell上面，和点击单元格的页面跳转
```
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

    //初始化MovieViewModel，设置成功（returnBlock）和失败的回调（errorBlock），getMovieData去请求数据，请求数据成功即回调上一步设置的returnBlock，请求失败则回调errorBlock
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

```
#####View模块
view这里跟MVC中子类化UITableViewCell一样，将model数据传进来，复写setModel方法给视图传递数据
```
#import "MovieModel.h"
@interface MovieCell : UITableViewCell
@property (nonatomic,strong) MovieModel *model;
@end

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
@interface MovieCell()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *yearLabel;
@property (nonatomic,strong) UIImageView *imgView;
@end
@implementation MovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 60)];
        [self.contentView addSubview:_imgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 20)];
        [self.contentView addSubview:_nameLabel];
        
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, 100, 20)];
        _yearLabel.textColor = [UIColor lightGrayColor];
        _yearLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_yearLabel];
    }
    return self;
}

- (void)setModel:(MovieModel *)model{
    _model = model;
    _nameLabel.text = _model.movieName;
    _yearLabel.text = _model.year;
    [_imgView setImageWithURL:_model.imageUrl];
}

@end
```

#####ViewModel模块
ViewModel是最重要的模块：
      1.这里面进行了数据的网络请求，并将数据转换成model放在一个数组中，调用_returnBlock将model数组传递给viewController进行数据源的处理
      2.将页面跳转的逻辑放在ViewModel中，点击单元格进行页面跳转的时候直接在- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath中调用MovieViewModel的该方法即可
```
#import <Foundation/Foundation.h>
#import "MovieModel.h"
#import <UIKit/UIKit.h>

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


#import "MovieViewModel.h"
#import "NetworkService.h"
#import "MovieModel.h"
#import "MovieViewController.h"

@implementation MovieViewModel

- (void)getMovieData{
    [NetworkService requestWithURL:@"/v2/movie/coming_soon" params:nil success:^(id result) {
        NSLog(@"%@",result);
        
        NSArray *subjects = result[@"subjects"];
        NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:subjects.count];
        for (NSDictionary *subject in subjects) {
            MovieModel *model = [[MovieModel alloc] init];
            model.movieName = subject[@"title"];
            model.year = subject[@"year"];
            NSString *urlStr = subject[@"images"][@"medium"];
            model.imageUrl = [NSURL URLWithString:urlStr];
            model.detailUrl = subject[@"alt"];
            [modelArr addObject:model];
        }
        _returnBlock(modelArr);
        
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
        _errorBlock(error);
    }];
}

- (void)movieDetailWithPublicModel: (MovieModel *)movieModel WithViewController: (UIViewController *)superController{
    MovieViewController *movieVC = [[MovieViewController alloc] init];
    movieVC.url = movieModel.detailUrl;
    [superController.navigationController pushViewController:movieVC animated:YES];
}
@end

```
