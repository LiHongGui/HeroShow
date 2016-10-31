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

@property (weak, nonatomic) IBOutlet UITableView *tableView;
#warning 必须是strong如果是weak的话,就会改好名字后,再次点击还会显示原来的名字
@property(nonatomic,strong)NSMutableArray *dataArray;
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
//    self.tableView.allowsMultipleSelection = YES;
    //添加这个就不能手动滑动删除
//    _tableView.editing = YES;


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

        //自定义选中颜色
//        UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
//        cell.selectedBackgroundView = view;
//        cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
//        NSLog(@"%p",cell);
    }
    //下面这一句是错误的,因为没有section
    //    HoreModel *horeModel = self.dataArray[indexPath.section];
    HoreModel *horeModel = self.dataArray[indexPath.row];
    cell.imageView.image  = [UIImage imageNamed:horeModel.icon];
    cell.textLabel.text = horeModel.name;
    cell.detailTextLabel.text = horeModel.intro;
    //箭头模式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;

}

#pragma mark
#pragma mark -  编辑cell的name
/*
 1.点击cell时,编辑cell的name,要先确定选中的是哪一个cell
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    NSLog(@"%ld",(long)indexPath.row);
    //2.点击cell时要跳出对话框---UIAlertView已经作废,在ios9之前可以用,之后不可以用.
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定 ", nil];
//    //显示文本框
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//    //文本框里显示原来的文本---获取alertView的文本---为0 是第一个字段,为1是密码
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    //显示文本框---原来默认的文本(model中)
//    textField.text = horeModel.name;
//    NSLog(@"%@",textField.text);
//
//    //点击那个cell就把它对应的row赋值给tag
//    alertView.tag = indexPath.row;
//    [alertView show];
     //设置控制器
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //设置取消动作
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action2];

    //设置 确定动作
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //创建文本框---第一段字母,显示原来的文本
        UITextField *text = controller.textFields[0];
        text.returnKeyType = UIReturnKeyDefault;
        NSLog(@"text%@",text);
        //新的名字
        NSString *newName = text.text;
        NSLog(@"nweName%@",newName);
        //修改后的名字
        HoreModel *horeModel = self.dataArray[indexPath.row];
        horeModel.name = newName;
        NSLog(@"horeModel.name%@",horeModel.name);

        //刷新
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        [tableView reloadData];
    }];
    [controller addAction:action1];
    HoreModel *horeModel = self.dataArray[indexPath.row];
    //添加对话框
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = horeModel.name;
        NSLog(@"textField.text%@",horeModel.name);
    }];


    //显示对话框
    [self presentViewController:controller animated:YES completion:nil];
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
//        NSLog(@"name%@",horeModel.name);

        //刷新
//        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark
#pragma mark -  滑动显示删除按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath%@",indexPath);
    //判断
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        //直接移除数据源里对应得row
        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [_tableView reloadData];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }else if (editingStyle ==UITableViewCellEditingStyleInsert){
        //插入:给数据源添加一个新的model
        HoreModel *model = [[HoreModel alloc]init];
        model.name = @"lihonggui";
        [self.dataArray insertObject:model atIndex:indexPath.row];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
#pragma mark
#pragma mark - 确定编辑的模式:插入/删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark
#pragma mark -  显示中文删除
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark
#pragma mark -  编辑行为:可以添加很多动作(添加,删除,收藏,置顶等)
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加按钮
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //
//        [self.dataArray insertObject:model atIndex:indexPath.row];
        HoreModel *model = [[HoreModel alloc]init];
        model.name = @"lihonggui";
        [self.dataArray insertObject:model atIndex:indexPath.row];
//        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_tableView reloadData];
    }];
    addAction.backgroundColor = [UIColor blueColor];

    //删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];

    }];
    return @[addAction,deleteAction];
}
@end
