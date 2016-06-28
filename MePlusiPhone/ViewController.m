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
#import "AGDChatViewController.h"
#import "SingleTon.h"
#import <PubNub/PubNub.h>

static NSString *const AGDSegueID  = @"Chat";

@interface ViewController ()<PNObjectEventListener>

@property(nonatomic,strong)UIButton *actionBtn;
//@property(nonatomic,strong)NSString *vendorKey;
@property(nonatomic,strong)NSString *roomNum;
@property(nonatomic,strong)UIView *lightView;
@property(nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,strong)PubNub *client;
@property(nonatomic,strong)NSString *uuid;//设备id,channelKey
@property(nonatomic,strong)NSString *message;
//@property(nonatomic,copy)NSString *authkey;
@property(nonatomic,strong)NSString *channel;





- (IBAction)RTVAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self showLeftBtnWithName:@"首页"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self voiceAction];
    
    //设备id
    self.uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self configureService];
    
    //PubNub
    self.channel = self.roomNum;//robotUUID
//    self.authkey = self.uuid;//userUUID
    

    
    
}
- (void)configureService{
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:kPUBKey subscribeKey:kSUBKey];
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
//    [self.client subscribeToChannels: @[self.roomNum] withPresence:YES];
}
- (void)sendMessage{
    self.message = @"call";

    [self.client publish:[NSString stringWithFormat:@"Message:%@ \nfrom: %@", self.message,self.uuid] toChannel:self.roomNum withCompletion:^(PNPublishStatus * _Nonnull status) {
        if (!status.isError) {
            MJJLog(@"send succcess")
        }else{
            MJJLog(@"send error");
        }
    }];
}
#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if (message.data.actualChannel) {
        
        // Message has been received on channel group stored in
        // message.data.subscribedChannel
    }
    else {
        
        // Message has been received on channel stored in
        // message.data.subscribedChannel
    }
    self.message = [NSString stringWithFormat:@"%@ \non channel %@ \nat %@", message.data.message,
                              message.data.subscribedChannel, message.data.timetoken ];
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.subscribedChannel, message.data.timetoken);
}

- (void)client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    
    if (status.category == PNUnexpectedDisconnectCategory) {
        // This event happens when radio / connectivity is lost
    }
    
    else if (status.category == PNConnectedCategory) {
        
        [self.client publish:@"Hello from the iOS" toChannel:self.uuid
              withCompletion:^(PNPublishStatus *status) {
                  
                  if (!status.isError) {
                      
                  }else {
                      
                  }
              }];
    }
    else if (status.category == PNReconnectedCategory) {
        
            }
    else if (status.category == PNDecryptionErrorCategory) {
        
       
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }

}

#pragma mark  ------------- appKey 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (![segue.identifier isEqualToString:AGDSegueID]) {
        return;
    }
    AGDChatViewController *chatVC = segue.destinationViewController;
    chatVC.dictionary = @{AGDKeyChannel:self.roomNum,AGDKeyVendorKey:kAppKey};
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        chatVC.chatType = AGDChatTypeDefault;
    }
}
- (void)resultAction:(UIButton *)btn{
}

#pragma mark ---------------- voice
- (IBAction)wakeupAction:(id)sender {
    
    SingleTon *data = [SingleTon shareData];
    self.roomNum = data.robotNum;

    if (self.roomNum == nil) {
        self.tipLabel.text = @"   绑定多我机器人吗？";
    }else{
        
        self.tipLabel.text = @"   唤醒多我机器人吗？";
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.lightView.frame = CGRectMake(0, kScreenHeight-120, kScreenWidth, 120);
    }];
}

- (void)voiceAction{
    
    self.lightView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-70, kScreenWidth, 120)];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50+20, kScreenWidth, 50)];
    self.tipLabel.backgroundColor = [UIColor grayColor];
    self.tipLabel.textColor = [UIColor whiteColor];
    
    [self.lightView addSubview:self.tipLabel];
    
    UIButton *makesureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    makesureBtn.frame = CGRectMake(kScreenWidth*3/4-20, 50+30, 90, 30);
    [makesureBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [makesureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makesureBtn addTarget:self action:@selector(robotOnLineAction:) forControlEvents:UIControlEventTouchUpInside];
    makesureBtn.tag = 2;
    [self.lightView addSubview:makesureBtn];
    [self.view addSubview:self.lightView];
    
}
//
- (void)robotOnLineAction:(UIButton *)btn{
    SingleTon *data = [SingleTon shareData];
    self.roomNum = data.robotNum;

    switch (btn.tag) {
        case 1:
        {
            if (self.roomNum == nil) {
                self.tipLabel.text = @"   绑定多我机器人吗？";
            }else{
                self.tipLabel.text = @"   唤醒多我机器人吗？";
            }
                [UIView animateWithDuration:0.1 animations:^{
                self.lightView.frame = CGRectMake(0, kScreenHeight-120, kScreenWidth, 120);
                 }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.lightView.frame = CGRectMake(0, kScreenHeight-70, kScreenWidth, 120);
                
            }];
            if (kAppKey.length && self.roomNum.length) {
                MJJLog(@"appKey  = %@,roomNum = %@",kAppKey,self.roomNum);
//                return YES;
            }else{
                MJJLog(@"####请求失败##### = %@ ,$$$$$$$$ = %@",kAppKey,self.roomNum);
//                return NO;
            }

            if (self.roomNum == nil) {
                RobotOnLineViewController *robotVC = [[RobotOnLineViewController alloc]init];
                [self.navigationController pushViewController:robotVC animated:YES];
            }else{
                
                [self sendMessage];

                UIStoryboard *agdSB = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                AGDChatViewController *AGDChatVC = [agdSB instantiateViewControllerWithIdentifier:@"AGDChatViewController"];
                AGDChatVC.dictionary =   @{AGDKeyChannel: self.roomNum,
                                           AGDKeyVendorKey: kAppKey};
                [self.navigationController pushViewController:AGDChatVC animated:YES];
            }
        }
            break;

        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//视频界面
- (IBAction)RTVAction:(id)sender {
    if ([self isValidInput]) {
        [self performSegueWithIdentifier:AGDSegueID sender:sender];
        
    }
}
- (BOOL)isValidInput{
    [self.view endEditing:YES];
    if (kAppKey.length && self.roomNum.length) {
        
        MJJLog(@"#######请求成功 appKey  = %@,roomNum = %@",kAppKey,self.roomNum);
        return YES;
    }else{
        MJJLog(@"####请求失败##### = %@ ,$$$$$$$$ = %@",kAppKey,self.roomNum);
        
    return NO;
    }
}

@end
