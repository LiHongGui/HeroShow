//
//  HoreModel.m
//  HoreShow
//
//  Created by MichaelLi on 2016/10/21.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import "HoreModel.h"

@implementation HoreModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)horeModelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
