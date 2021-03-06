//
//  LeftView.m
//  MePlusiPhone
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "LeftView.h"
#import "ViewController.h"



@interface LeftView ()
@property (nonatomic,strong)UIView *setView;
@property (nonatomic,strong)UIView *backView;

@end
@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UIWindow *window = [[UIApplication sharedApplication].delegate  window];
    self.setView = [[UIView alloc]initWithFrame:CGRectMake(100-kScreenWidth, 0, kScreenWidth-100, kScreenHeight)];
    self.setView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.setView];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.0;
    [window addSubview:self.backView];
    
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100, kScreenHeight/3)];
    messageView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
    [self.setView addSubview:messageView];
    
    NSArray *userArray = @[@"用户名：",@"邮箱：",@"未绑定多我机器人"];
    NSArray *widthArray = @[@"60",@"50",@"120"];
    for (int i = 0; i < 3; i++) {
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(20, messageView.frame.size.height*2/3+24*i, [widthArray[i] integerValue], 24)];
        userName.text = userArray[i];
        userName.font = [UIFont systemFontOfSize:14];
        [messageView addSubview:userName];
        UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(20+[widthArray[i] integerValue], messageView.frame.size.height*2/3+24*i, 120, 24)];
        number.text = @"";
        number.font = [UIFont systemFontOfSize:14];
        [messageView addSubview:number];
        
    }
    
    
    

    NSArray *titleArray = @[@"首页",@"通话记录",@"设置"];
    for (int i = 0; i < 3; i++) {
        //按钮图片
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, kScreenHeight/3+44*i+13, 20, 20)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"me_icon_%d",i]];
        [self.setView addSubview:imageView];
        //按钮title
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(60, kScreenHeight/3 + 44*i,  kScreenWidth-100,44)];
        titleLable.text = titleArray[i];
        [self.setView addSubview:titleLable];
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, kScreenHeight/3 + 44*i,  kScreenWidth-100,44);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(setSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.setView addSubview:btn];
        
        
    }
    UITapGestureRecognizer *disappear = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disapearAction)];
    [self.backView addGestureRecognizer:disappear];
    [UIView animateWithDuration:0.5 animations:^{
        //移入屏幕后的frame
        self.setView.frame = CGRectMake(0, 0, kScreenWidth-100, kScreenHeight);
        self.backView.frame = CGRectMake(kScreenWidth-100, 0, 100, kScreenHeight);
        self.backView.alpha = 0.6;
        
    }];

}
- (void)disapearAction{
    [UIView animateWithDuration:0.5 animations:^{
        //移出屏幕的frame
        self.setView.frame = CGRectMake(100-kScreenWidth, 0, kScreenWidth-100, kScreenHeight);
        self.backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backView.alpha = 0.0;
    }];
}

- (void)setSelectAction:(UIButton *)btn{
    switch (btn.tag) {
        case 100:
        {
            [self disapearAction];
            
        }
            break;
        case 101:
        {
            [self disapearAction];
            
        }
            break;
        case 102:
        {
            [self disapearAction];
            
        }
            break;
            
        default:
            break;
    }
}


@end
