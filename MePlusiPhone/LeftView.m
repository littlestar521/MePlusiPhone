//
//  LeftView.m
//  MePlusiPhone
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "LeftView.h"
#import "ViewController.h"
#import "SingleTon.h"


@interface LeftView ()
@property (nonatomic,strong)UIView *setView;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong)UILabel *number;
@property (nonatomic,strong)NSString *robotNum;

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

//    //注册通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLabelText:) name:@"message" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelText:) name:@"login" object:nil];
    SingleTon *data = [SingleTon shareData];
    self.robotNum = data.robotid;
    
    
    UIWindow *window = [[UIApplication sharedApplication].delegate  window];
    self.setView = [[UIView alloc]initWithFrame:CGRectMake(100-kScreenWidth, 0, kScreenWidth-100, kScreenHeight)];
    self.setView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.setView];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.0;
    [window addSubview:self.backView];
    
    //信息展示view
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100, kScreenHeight/3)];
    messageView.backgroundColor = kMainColor;
    [self.setView addSubview:messageView];
    
    NSArray *userArray1 = @[@"用户名：",@"邮箱：",@"未绑定多我机器人"];
    NSArray *userArray2 = @[@"用户名：",@"邮箱：",@"机器人："];
    NSArray *widthArray1 = @[@"60",@"50",@"120"];
    NSArray *widthArray2 = @[@"60",@"50",@"60"];
    for (int i = 0; i < 3; i++) {
        if (self.robotNum == nil) {
            UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(20, messageView.frame.size.height*2/3+24*i, [widthArray1[i] integerValue], 24)];
            userName.text = userArray1[i];
            userName.font = [UIFont systemFontOfSize:14];
            [messageView addSubview:userName];
            self.number = [[UILabel alloc]initWithFrame:CGRectMake(20+[widthArray1[i] integerValue], messageView.frame.size.height*2/3+24*i, 180, 24)];
//           self.number.backgroundColor = [UIColor yellowColor];
            self.number.tag = i+100;
            self.number.font = [UIFont systemFontOfSize:14];
            [messageView addSubview:self.number];
        }else{
            UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(20, messageView.frame.size.height*2/3+24*i, [widthArray2[i] integerValue], 24)];
            userName.text = userArray2[i];
            userName.font = [UIFont systemFontOfSize:14];
            [messageView addSubview:userName];
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(20+[widthArray2[i] integerValue], messageView.frame.size.height*2/3+24*i, 180, 24)];
//            self.number.backgroundColor = [UIColor yellowColor];
            number.tag = i+100;
            number.font = [UIFont systemFontOfSize:14];
            [messageView addSubview:number];
        }
        [self dataWithMessage:self.number];


        
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
        btn.tag = 100+i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(setSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.setView addSubview:btn];
        
        
    }
    //添加轻拍手势
    UITapGestureRecognizer *disappear = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disapearAction)];
    [self.backView addGestureRecognizer:disappear];
    [UIView animateWithDuration:0.5 animations:^{
        //移入屏幕后的frame
        self.setView.frame = CGRectMake(0, 0, kScreenWidth-100, kScreenHeight);
        self.backView.frame = CGRectMake(kScreenWidth-100, 0, 100, kScreenHeight);
        self.backView.alpha = 0.6;
        
    }];

}
//轻拍手势事件
- (void)disapearAction{
    [UIView animateWithDuration:0.5 animations:^{
        //移出屏幕的frame
        self.setView.frame = CGRectMake(100-kScreenWidth, 0, kScreenWidth-100, kScreenHeight);
        self.backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backView.alpha = 0.0;
    }];
}
#pragma mark ----------- 传值
//传值
- (void)dataWithMessage:(UILabel *)label{
    if (label.tag == 100) {
        NSString *currentUsername = [AVUser currentUser].username;
        self.number.text = currentUsername;
    }else if (label.tag == 101){
        NSString *currentEmail = [AVUser currentUser].email;
        self.number.text = currentEmail;

    }else{
        if (self.robotNum == nil) {
            
        }else{
//            SingleTon *data = [SingleTon shareData];
            self.number.text = self.robotNum;
        }
    }
}
//leftView
- (void)setSelectAction:(UIButton *)btn{
    [self disapearAction];
    switch (btn.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
