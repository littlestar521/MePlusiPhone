//
//  SingleTon.h
//  MePlusiPhone
//
//  Created by sks on 16/6/20.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTon : NSObject

@property(nonatomic,strong)NSString *tip;//提示语
@property(nonatomic,strong)NSString *robotNum;//是否绑定机器人

+ (instancetype)shareData;




@end
