//
//  ViewController.m
//  HoreShow
//
//  Created by MichaelLi on 2016/10/21.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "ViewController.h"
#import "HoreModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak)NSArray *dataArray;
@end

@implementation ViewController

#pragma mark
#pragma mark -  遍历
-(NSArray *)dataArray
{
    if (_dataArray == nil) {
        //读取文件
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"heros.plist" ofType:nil];
        //读取文件到临时数组
        NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];

        //可变数组
        NSMutableArray *mutb = [NSMutableArray array];
        //遍历---字典转模型---
        for (NSDictionary *dict in temp) {
            HoreModel *horeModel = [HoreModel horeModelWithDict:dict];
            [mutb addObject:horeModel];
        }
        _dataArray = mutb;
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //编辑模式下可以多选
    self.tableView.allowsSelectionDuringEditing =YES;
    //允许多选
    self.tableView.allowsMultipleSelection = YES;
}

#pragma mark
#pragma mark -  组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark
#pragma mark -  行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark
#pragma mark -  行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    //下面这一句是错误的,因为没有section
//    HoreModel *horeModel = self.dataArray[indexPath.section];
    HoreModel *horeModel = self.dataArray[indexPath.row];
    cell.imageView.image  = [UIImage imageNamed:horeModel.icon];
    cell.textLabel.text = horeModel.name;
    cell.detailTextLabel.text = horeModel.intro;
    //福建类型---箭头模式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //自定义选中颜色
    UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView = view;
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    return cell;

}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}


//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
