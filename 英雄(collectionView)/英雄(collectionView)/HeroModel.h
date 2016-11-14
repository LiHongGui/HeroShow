//
//  HeroModel.h
//  英雄(collectionView)
//
//  Created by lihonggui on 2016/11/11.
//  Copyright © 2016年 lihonggui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroModel : NSObject
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *intro;
@property(nonatomic,copy) NSString *name;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)heroModelWithDict:(NSDictionary *)dict;
@end
