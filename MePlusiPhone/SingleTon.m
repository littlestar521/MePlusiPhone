//
//  SingleTon.m
//  MePlusiPhone
//
//  Created by sks on 16/6/20.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "SingleTon.h"

@implementation SingleTon

static SingleTon *singleTon = nil;

+ (instancetype)shareData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [[SingleTon alloc]init];
    });
    return singleTon;
}



@end
