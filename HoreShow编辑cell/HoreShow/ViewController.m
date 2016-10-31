//
//  ViewController.m
//  HoreShow
//
//  Created by MichaelLi on 2016/10/21.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "ViewController.h"
#import "HoreModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak)NSMutableArray *dataArray;
@end
static NSString *identifier = @"Cell";
@implementation ViewController

#pragma mark
#pragma mark -  遍历
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        //重新实例化
        _dataArray = [NSMutableArray array];
        //读取文件
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"heros.plist" ofType:nil];
        //读取文件到临时数组
        NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];

        //可变数组
//        NSMutableArray *mutb = [NSMutableArray array];
        //遍历---字典转模型---
        for (NSDictionary *dict in temp) {
            HoreModel *horeModel = [HoreModel horeModelWithDict:dict];
//            [mutb addObject:horeModel];
            [_dataArray addObject:horeModel];
        }

//        _dataArray = mutb;
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

    //这个方法:滑动cell时,会不断调用cell这个方法.比较麻烦
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //判断有没有这个Cell.有的话就直接调用,没有的话就重新初始化
    if (cell == nil) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
        NSLog(@"%p",cell);
    }

    return cell;

}

#pragma mark
#pragma mark -  编辑cell的name
/*
 1.点击cell时,编辑cell的name,要先确定选中的是哪一个cell
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HoreModel *horeModel = self.dataArray[indexPath.row];
//    NSLog(@"%ld",(long)indexPath.row);
    //2.点击cell时要跳出对话框
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定 ", nil];
    //显示文本框
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    //文本框里显示原来的文本---获取alertView的文本---为0 是第一个字段,为1是密码
    UITextField *textField = [alertView textFieldAtIndex:0];
    //显示文本框---原来默认的文本(model中)
    textField.text = horeModel.name;
    NSLog(@"%@",textField.text);

    //点击那个cell就把它对应的row赋值给tag
    alertView.tag = indexPath.row;
    [alertView show];
}

#pragma mark
#pragma mark -  确定点击的是确定还是取消
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);//点击确定是1,取消是0
    //判断
    if (buttonIndex == 1) {
        //获取修改后的英雄的name
        UITextField *textField = [alertView textFieldAtIndex:0];
        //新name
        NSString *newName = textField.text;
        /*
         把新name辅助给model才可以显示修改后的name,所以要在懒加载里重新定义数组(可变数组)
         修改数据源:是修改点击对应的那个cell的数据,要先取到那个cell
         */
        NSInteger index = alertView.tag;
//        NSLog(@"index%ld",(long)index);
        HoreModel *horeModel = self.dataArray[index];
        //newName赋值回去
        horeModel.name = newName;
        NSLog(@"name%@",horeModel.name);

        //刷新
//        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;.
//}


//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
