//
//  HeroCell.m
//  英雄(collectionView)
//
//  Created by lihonggui on 2016/11/11.
//  Copyright © 2016年 lihonggui. All rights reserved.
//

#import "HeroCell.h"
#import "HeroModel.h"
@implementation HeroCell


-(void)setModel:(HeroModel *)model
{
    _model = model;
    
    _iconImageView.image = [UIImage imageNamed:model.icon];
    _nameLabel.text = model.name;
    _introLabel.text = model.intro;
}
@end
