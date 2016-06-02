//
//  RobotOnLineViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/5/30.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "RobotOnLineViewController.h"
#import "MePlus.pch"
#import "ViewController.h"


@interface RobotOnLineViewController ()
@property(nonatomic,strong)UITextField *robotNum;

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
    self.robotNum = [[UITextField alloc]initWithFrame:CGRectMake(20, kScreenHeight*2/3, kScreenWidth-40, 44)];
    self.robotNum.borderStyle = UITextBorderStyleLine;
    self.robotNum.placeholder = @"机器人ID";
    self.robotNum.textColor = kMainColor;
    [self.view addSubview:self.robotNum];
    //提示
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight*2/3+44, self.robotNum.frame.size.width, 44)];
    tip.textColor = kMainColor;
    tip.text = @"请认真填写机器人ID或通过扫描的方式";
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    //绑定机器人按钮
    UIButton *bindingRobot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bindingRobot setBackgroundColor:kMainColor];
    bindingRobot.frame = CGRectMake(20, kScreenHeight*2/3+44*2, self.robotNum.frame.size.width, 44);
    [bindingRobot.layer setMasksToBounds:YES];
    [bindingRobot.layer setCornerRadius:10.0];
    [bindingRobot setTitle:@"绑定机器人" forState:UIControlStateNormal];
    [bindingRobot setTintColor:[UIColor whiteColor]];
    [bindingRobot addTarget:self action:@selector(bindingRobotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingRobot];
    //扫描机器人
    UIButton *scanRobot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanRobot setBackgroundColor:kMainColor];
    scanRobot.frame = CGRectMake(20, kScreenHeight*2/3+44*3+15, self.robotNum.frame.size.width, 44);
    [scanRobot.layer setMasksToBounds:YES];
    [scanRobot.layer setCornerRadius:10.0];
    [scanRobot setTitle:@"扫描机器人" forState:UIControlStateNormal];
    [scanRobot setTintColor:[UIColor whiteColor]];
    [scanRobot addTarget:self action:@selector(scanRobotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanRobot];
    
    
}
- (void)bindingRobotAction{
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"message" object:nil userInfo:@{@"input": self.robotNum.text}];
    UIStoryboard *viewSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *VC = [viewSB instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
- (void)scanRobotAction{
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"message" object:nil userInfo:@{@"input": self.robotNum.text}];
    UIStoryboard *viewSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *VC = [viewSB instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:VC animated:YES];
    
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
