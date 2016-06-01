//
//  RobotOnLineViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/5/30.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "RobotOnLineViewController.h"
#import "MePlus.pch"
@interface RobotOnLineViewController ()

@end

@implementation RobotOnLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtnWithName:@"绑定机器人"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = kMainColor;
    [self robotOnLine];
    
}

- (void)robotOnLine{
    //编号输入框
    UITextField *robotNum = [[UITextField alloc]initWithFrame:CGRectMake(20, kScreenHeight*2/3, kScreenWidth-40, 44)];
    robotNum.borderStyle = UITextBorderStyleLine;
    robotNum.placeholder = @"机器人ID";
    robotNum.textColor = kMainColor;
    [self.view addSubview:robotNum];
    //提示
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight*2/3+44, robotNum.frame.size.width, 44)];
    tip.textColor = kMainColor;
    tip.text = @"请认真填写机器人ID或通过扫描的方式";
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    //绑定机器人按钮
    UIButton *bindingRobot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bindingRobot setBackgroundColor:kMainColor];
    bindingRobot.frame = CGRectMake(20, kScreenHeight*2/3+44*2, robotNum.frame.size.width, 44);
    [bindingRobot.layer setMasksToBounds:YES];
    [bindingRobot.layer setCornerRadius:10.0];
    [bindingRobot setTitle:@"绑定机器人" forState:UIControlStateNormal];
    [bindingRobot setTintColor:[UIColor whiteColor]];
    [bindingRobot addTarget:self action:@selector(bindingRobotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingRobot];
    //扫描机器人
    UIButton *scanRobot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanRobot setBackgroundColor:kMainColor];
    scanRobot.frame = CGRectMake(20, kScreenHeight*2/3+44*3+15, robotNum.frame.size.width, 44);
    [scanRobot.layer setMasksToBounds:YES];
    [scanRobot.layer setCornerRadius:10.0];
    [scanRobot setTitle:@"扫描机器人" forState:UIControlStateNormal];
    [scanRobot setTintColor:[UIColor whiteColor]];
    [scanRobot addTarget:self action:@selector(scanRobotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanRobot];
    
    
    
}
- (void)bindingRobotAction{
    
}
- (void)scanRobotAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
