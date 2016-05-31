//
//  UIViewController+Common.m
//  MePlusiPhone
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "UIViewController+Common.h"
#import "LeftView.h"

@interface UIViewController ()<PushVCDelegate>

@end
@implementation UIViewController (Common)
//导航栏添加菜单按钮
-(void)showLeftBtnWithName:(NSString *)name{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 10);
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(showLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(30, 0, 40, 40);
    [titleBtn setTitle:name forState:UIControlStateNormal];
    [titleBtn setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *otherBarBtn = [[UIBarButtonItem alloc]initWithCustomView:titleBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftBarBtn,otherBarBtn, nil]];
    
}
- (void)showLeftBtnAction{
    LeftView *leftView = [[LeftView alloc]init];
    leftView.delegate = self;
    [self.view addSubview: leftView];
}
//导航栏添加返回按钮
- (void)showBackBtnWithName:(NSString *)name{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 14);
    [backBtn setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(20, 0, 90, 40);
    [titleBtn setTitle:name forState:UIControlStateNormal];
    [titleBtn setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *otherBarBtn = [[UIBarButtonItem alloc]initWithCustomView:titleBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftBarBtn,otherBarBtn, nil]];
    
    
}
- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
