//
//  ViewController.m
//  英雄(collectionView)
//
//  Created by lihonggui on 2016/11/11.
//  Copyright © 2016年 lihonggui. All rights reserved.
//

#import "ViewController.h"
#import "HeroModel.h"
#import "HeroCell.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowlayout;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

static NSString *identifier = @"HeroCell";
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionViewFlowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"heros.plist" ofType:nil];
        _dataArray = [NSMutableArray array];
        NSArray *temp = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in temp) {
            HeroModel *model = [HeroModel heroModelWithDict:dict];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HeroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    HeroModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    //cell选中后的背景色
    [cell setSelectedBackgroundView:view];
    return cell;
}
#pragma mark
#pragma mark -  屏幕旋转
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    _collectionViewFlowlayout.itemSize = CGSizeMake(size.width, 80);
    NSLog(@"%@",NSStringFromCGSize(size));
}
#warning 提供了复制粘贴
#pragma mark
#pragma mark -  长安显示cut/copy/paste 这个方法用于设置要展示的菜单选项
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    if (indexPath.row == 0) {//设置第一行长安无反应
//        return NO;
//    }else
//    {
//        return YES;
//    }
    return YES;
}
#pragma mark
#pragma mark -  这个方法用于设置要展示的菜单选项
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if (action == @selector(copy:)|| action == @selector(paste:)) {
        return YES;
    }else
    {
        return NO;
    }
    return YES;
}
#pragma mark
#pragma mark -  这个方法用于实现点击菜单按钮后的触发方法,通过测试，只有copy，cut和paste三个方法可以使用
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    #warning 复制粘贴步骤:复制-剪贴板-粘贴
    if (action == @selector(copy:)) {
        //取出数据---复制
        HeroModel *model = self.dataArray[indexPath.row];
        //剪贴板
        [UIPasteboard generalPasteboard].strings = @[model.icon,model.name,model.intro];
        
    }else if (action ==@selector(paste:))
    {
        //取出剪贴板上的数据
        NSArray *strings = [UIPasteboard generalPasteboard].strings;
        HeroModel *model = [[HeroModel alloc]init];
        model = self.dataArray[indexPath.row];
        model.icon = strings[0];
        model.name = strings[1];
        model.intro = strings[2];
        //刷新
        [_dataArray insertObject:model atIndex:indexPath.row];
//        [_collectionView reloadData];
        
        [_collectionView insertItemsAtIndexPaths:@[indexPath]];
    }
}
@end
