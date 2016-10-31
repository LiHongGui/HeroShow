//
//  HoreModel.h
//  HoreShow
//
//  Created by MichaelLi on 2016/10/21.
//  Copyright © 2016年 手持POS机. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoreModel : NSObject

@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *intro;
@property(nonatomic,copy) NSString *name;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)horeModelWithDict:(NSDictionary *)dict;



@end
