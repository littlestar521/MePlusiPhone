//
//  ViewController.m
//  MePlusiPhone
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "ViewController.h"
#import "MePlus.pch"
#import "LeftView.h"
#import "RobotOnLineViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self showLeftBtnWithName:@"首页"];
    [self voiceAction];

    
}
- (void)voiceAction{
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.frame = CGRectMake(kScreenWidth*3/4, kScreenHeight-80, 60, 60);
    [voice setBackgroundColor: [UIColor redColor]];
    [voice setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [voice addTarget:self action:@selector(robotOnLineAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voice];
    
}
- (void)robotOnLineAction:(UIButton *)btn{
    RobotOnLineViewController *robotVC = [[RobotOnLineViewController alloc]init];
    [self.navigationController pushViewController:robotVC animated:YES];
    
    
}
//- (void)showLeftBtnAction{
//    LeftView *leftView = [[LeftView alloc]init];
//    leftView.delegate = self;
//    [self.view addSubview: leftView];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
