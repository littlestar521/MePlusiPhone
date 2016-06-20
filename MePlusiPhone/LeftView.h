//
//  LeftView.h
//  MePlusiPhone
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushVCDelegate <NSObject>

- (void)getOtherViewController:(UIViewController *)otherVC;

@end
@interface LeftView : UIView
@property(nonatomic,assign)id<PushVCDelegate>delegate;

- (void)dataWithMessage:(UILabel *)label;

@end
