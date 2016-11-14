//
//  HeroCell.h
//  英雄(collectionView)
//
//  Created by lihonggui on 2016/11/11.
//  Copyright © 2016年 lihonggui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeroModel;
@interface HeroCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property(nonatomic,strong) HeroModel *model;
@end
