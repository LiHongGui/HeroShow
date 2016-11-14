//
//  HeroModel.m
//  英雄(collectionView)
//
//  Created by lihonggui on 2016/11/11.
//  Copyright © 2016年 lihonggui. All rights reserved.
//

#import "HeroModel.h"

@implementation HeroModel


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self =[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)heroModelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
