//
//  AppDelegate.m
//  MePlusiPhone
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "ViewController.h"
#import "RegisterViewController.h"
#import <PubNub/PubNub.h>
#import <sqlite3.h>

static sqlite3 *database = nil;

@interface AppDelegate ()<PNObjectEventListener>

{
    NSString *path;

}
@property(nonatomic)PubNub *client;
@property(nonatomic,copy)NSString *authkey;
//@property(nonatomic,copy,setter=setUUID:)NSString *uuid;
@property(nonatomic,strong)NSString *channel;
@property(nonatomic,strong)NSString *channel2;
@property(nonatomic,strong)NSString *channelGroup1;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)PNConfiguration *myConfig;


#pragma mark ------ configuration
- (void)updateClientConfiguration;
- (void)printClientConfiguration;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //判断是不是第一次使用
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        //停留3秒再进主界面
        [NSThread sleepForTimeInterval:3.0];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLaunch"];
        MJJLog(@"第一次启动");
    }else{
        //停留3秒再进主界面
        [NSThread sleepForTimeInterval:3.0];
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser != nil) {
            //跳转到首页
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *VC = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
            nav.navigationBar.barTintColor = kMainColor;
            self.window.rootViewController = nav;
        }else{
        //缓存用户对象为空时，可打开用户注册界面
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RegisterViewController *registerVC = [sb instantiateViewControllerWithIdentifier:@"RegisterVC"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:registerVC];
            nav.navigationBar.barTintColor = kMainColor;
            self.window.rootViewController = nav;
            MJJLog(@"不是第一次启动");
            
        }
        
    }
    
    
    //LeanCloud
    [AVOSCloud setApplicationId:kLAppID clientKey:kLAppKey];
    //跟踪统计应用打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    //PubNub
    self.channel = @"e3347dee5a6c11f5";//robotUUID
    self.authkey = @"myAuthKey";//userUUID
    
#pragma mark ------ kick the Tires
//    [self tireKicker];
    
    
    
    
    
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:kPUBKey subscribeKey:kSUBKey];
    configuration.uuid = @"机器人编码";
    configuration.TLSEnabled = YES;
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    [self.client subscribeToChannels:@[@"my_channel"]  withPresence:YES];
    
    
//    NSString *uniqueName = [[NSString alloc]initWithString:[(NSString )CFBridgingRelease(cfUUID)lowercaseString]];
//    configuration.uuid = [[NSString alloc]initWithString:[(NSString)CFBridgingRelease(cfUUID) lowercaseString]];
//    [self.client subscribeToChannels:@[uniqueName] withPresence:NO];
    
//    __weak __typeof(self) weekSelf = self;
//    [self.client copyWithConfiguration:configuration completion:^(PubNub * _Nonnull client) {
//        weekSelf.client = client;
//    }];
    
    
    
    return YES;
}
//- (void)pubNubInit{
//    [PNLog enabled:YES];
//    [PNLog dumpToFile:YES];
//    [PNLog setMaximumLogFileSize:(10*1024*1024)];
//    [PNLog setMaximumNumberOfLogFiles:10];
//    //初始化Pubnubclient
//    self.myConfig = [PNConfiguration configurationWithPublishKey:kPUBKey subscribeKey:kSUBKey];
//    
//    [self updateClientConfiguration];
//    [self printClientConfiguration];
//    
//    //绑定config
//    [self.client addListener:self];
//    [self pubNubSetState];
//    
//}
//- (void)tireKicker{
//    [self pubNubInit];
//#pragma mark ------ time
//    [self pubNubTime];
//#pragma mark - Publish
//    [self pubNubPublish];
//    
//#pragma mark - History
//    
//    [self pubNubHistory];
//    
//#pragma mark - Channel Groups Subscribe / Unsubscribe
//    
//    [self pubNubSubscribeToChannelGroup];
//    [self pubNubUnsubFromChannelGroups];
//    
//#pragma mark - Channel Subscribe / Unsubscribe
//    
//    [self pubNubSubscribeToChannels];
//    [self pubNubUnsubscribeFromChannels];
//    
//#pragma mark - Presence Subscribe / Unsubscribe
//    
//    [self pubNubSubscribeToPresence];
//    [self pubNubUnsubFromPresence];
//    
//#pragma mark - Here Nows
//    
//    [self pubNubHereNowForChannel];
//    [self pubNubGlobalHereNow];
//    [self pubNubHereNowForChannelGroups];
//    [self pubNubWhereNow];
//    
//#pragma mark - CG Admin
//    
//    [self pubNubCGAdd];
//    [self pubNubChannelsForGroup];
//    [self pubNubCGRemoveAllChannels];
//    [self pubNubCGRemoveSomeChannels];
//    
//#pragma mark - State Admin
//    [self pubNubSetState];
//    [self pubNubGetState];
//    
//    
////#pragma mark - 3rd Party Push Notifications Admin
////    
////    [self pubNubAddPushNotifications];
////    [self pubNubRemovePushNotification];
////    [self pubNubRemoveAllPushNotifications];
////    [self pubNubGetAllPushNotifications];
////    
////#pragma mark - Public Encryption/Decryption Methods
////    
////    [self pubNubAESDecrypt];
////    [self pubNubAESEncrypt];
//    
//#pragma mark - Message Size Check Methods
//    
//    [self pubNubSizeOfMessage];
//}
//- (void)pubNubSizeOfMessage{
//    [self.client sizeOfMessage:@"Connected! I'm here!" toChannel:self.channel1 withCompletion:^(NSInteger size) {
//        MJJLog(@"~~~~~Message size:%@",@(size));
//        
//    }];
//}
//
//- (void)pubNubSetState {
//    
//    __weak __typeof(self) weakSelf = self;
//    [self.client setState:@{[self randomString] : @{[self randomString] : [self randomString]}} forUUID:_myConfig.uuid onChannel:_channel1 withCompletion:^(PNClientStateUpdateStatus *status) {
//        
//        __strong __typeof(self) strongSelf = weakSelf;
//        [strongSelf handleStatus:status];
//    }];
//}
//
//- (void)pubNubGetState{
//    
//    [self.client stateForUUID:_myConfig.uuid onChannel:_channel1
//               withCompletion:^(PNChannelClientStateResult *result, PNErrorStatus *status) {
//                   
//                   if (status) {
//                       [self handleStatus:status];
//                   }
//                   else if (result) {
//                       
//                       MJJLog(@"^^^^ Loaded state %@ for channel %@", result.data.state, self->_channel1);
//                   }
//                   
//               }];
//    
//    /*
//     [self.client stateForUUID:<#(NSString *)uuid#> onChannelGroup:<#(NSString *)group#> withCompletion:<#(PNChannelGroupStateCompletionBlock)block#>];
//     */
//}
//
//
//
//- (void)pubNubUnsubFromChannelGroups {
//    [self.client unsubscribeFromChannelGroups:@[@"myChannelGroup"] withPresence:NO];
//    
//    
//}
//
//- (void)pubNubSubscribeToPresence {
//    [self.client subscribeToPresenceChannels:@[_channel1]];
//}
//
//- (void)pubNubUnsubFromPresence {
//    [self.client unsubscribeFromPresenceChannels:@[_channel1]];
//}
//
//
//
//- (void)pubNubSubscribeToChannels {
//    [self.client subscribeToChannels:@[_channel1] withPresence:YES clientState:@{_channel1:@{@"foo":@"bar"}}];
//    
//    /*
//     [self.client subscribeToChannels:<#(NSArray *)channels#> withPresence:<#(BOOL)shouldObservePresence#>];
//     [self.client isSubscribedOn:<#(NSString *)name#>]
//     */
//    
//}
//
//- (void)pubNubUnsubscribeFromChannels {
//    [self.client unsubscribeFromChannels:@[_channel1] withPresence:YES];
//}
//
//- (void)pubNubSubscribeToChannelGroup {
//    [self.client subscribeToChannelGroups:@[_channelGroup1] withPresence:NO];
//    /*
//     [self.client subscribeToChannelGroups:@[_channelGroup1] withPresence:YES clientState:@{@"foo":@"bar"}];
//     */
//    
//}
//
//
//
//- (void)pubNubWhereNow {
//    [self.client whereNowUUID:@"123456" withCompletion:^(PNPresenceWhereNowResult *result,
//                                                         PNErrorStatus *status) {
//        
//        if (status) {
//            [self handleStatus:status];
//        }
//        else if (result) {
//            MJJLog(@"^^^^ Loaded whereNow data: %@", result.data.channels);
//        }
//    }];
//}
//
//- (void)pubNubCGRemoveSomeChannels {
//    
//    [self.client removeChannels:@[_channel2] fromGroup:_channelGroup1 withCompletion:^(PNAcknowledgmentStatus *status) {
//        
//        
//        if (!status.isError) {
//            MJJLog(@"^^^^CG Remove Some Channels request succeeded at timetoken %@.", status);
//        } else {
//            MJJLog(@"^^^^CG Remove Some Channels request did not succeed. All subscribe operations will autoretry when possible.");
//            [self handleStatus:status];
//        }
//    }];
//}
//
//- (void)pubNubCGRemoveAllChannels {
//    
//    [self.client removeChannelsFromGroup:_channelGroup1
//                          withCompletion:^(PNAcknowledgmentStatus *status) {
//                              
//                              if (!status.isError) {
//                                  MJJLog(@"^^^^CG Remove All Channels request succeeded");
//                              } else {
//                                  MJJLog(@"^^^^CG Remove All Channels request did not succeed. All subscribe operations will autoretry when possible.");
//                                  [self handleStatus:status];
//                              }
//                          }];
//}
//
//
//- (void)pubNubCGAdd {
//    
//    __weak __typeof(self) weakSelf = self;
//    [self.client addChannels:@[_channel1, _channel2] toGroup:_channelGroup1
//              withCompletion:^(PNAcknowledgmentStatus *status) {
//                  
//                  __strong __typeof(self) strongSelf = weakSelf;
//                  
//                  if (!status.isError) {
//                      
//                      MJJLog(@"^^^^CGAdd request succeeded");
//                  }
//                  else {
//                      
//                      MJJLog(@"^^^^CGAdd Subscribe request did not succeed. All subscribe operations will autoretry when possible.");
//                      [strongSelf handleStatus:status];
//                  }
//              }];
//    
//}
//
//- (void)pubNubChannelsForGroup {
//    
//    [self.client channelsForGroup:_channelGroup1
//                   withCompletion:^(PNChannelGroupChannelsResult *result, PNErrorStatus *status) {
//                       if (status) {
//                           [self handleStatus:status];
//                       }
//                       else if (result) {
//                           MJJLog(@"^^^^ Loaded all channels %@ for group %@",
//                                 result.data.channels, self->_channelGroup1);
//                       }
//                   }];
//}
//
//- (void)pubNubHereNowForChannel {
//    
//    [self.client hereNowForChannel:_channel1 withCompletion:^(PNPresenceChannelHereNowResult *result,
//                                                              PNErrorStatus *status) {
//        if (status) {
//            
//            [self handleStatus:status];
//        }
//        else if (result) {
//            MJJLog(@"^^^^ Loaded hereNowForChannel data: occupancy: %@, uuids: %@", result.data.occupancy, result.data.uuids);
//        }
//    }];
//    
//    // If you want to control the 'verbosity' of the server response -- restrict to (values are additive):
//    
//    // Occupancy                : PNHereNowOccupancy
//    // Occupancy + UUID         : PNHereNowUUID
//    // Occupancy + UUID + State : PNHereNowState
//    
//    [self.client hereNowForChannel:_channel1 withVerbosity:PNHereNowState
//                        completion:^(PNPresenceChannelHereNowResult *result, PNErrorStatus *status) {
//                            if (status) {
//                                [self handleStatus:status];
//                            }
//                            else if (result) {
//                                MJJLog(@"^^^^ Loaded hereNowForChannel data: occupancy: %@, uuids: %@", result.data.occupancy, result.data.uuids);
//                            }
//                        }];
//    
//}
//
//
//- (void)pubNubGlobalHereNow {
//    
//    [self.client hereNowWithCompletion:^(PNPresenceGlobalHereNowResult *result, PNErrorStatus *status) {
//        if (status) {
//            [self handleStatus:status];
//        }
//        else if (result) {
//            MJJLog(@"^^^^ Loaded Global hereNow data: channels: %@, total channels: %@, total occupancy: %@", result.data.channels, result.data.totalChannels, result.data.totalOccupancy);
//        }
//    }];
//    
//    // If you want to control the 'verbosity' of the server response -- restrict to (values are additive):
//    
//    // Occupancy                : PNHereNowOccupancy
//    // Occupancy + UUID         : PNHereNowUUID
//    // Occupancy + UUID + State : PNHereNowState
//    
//    [self.client hereNowWithVerbosity:PNHereNowOccupancy completion:^(PNPresenceGlobalHereNowResult *result,
//                                                                      PNErrorStatus *status) {
//        if (status) {
//            [self handleStatus:status];
//        }
//        else if (result) {
//            MJJLog(@"^^^^ Loaded Global hereNow data: channels: %@, total channels: %@, total occupancy: %@", result.data.channels, result.data.totalChannels, result.data.totalOccupancy);
//        }
//    }];
//    
//}
//
//- (void)pubNubHereNowForChannelGroups{
//    /*
//     [self.client hereNowForChannelGroup:<#(NSString *)group#> withCompletion:<#(PNChannelGroupHereNowCompletionBlock)block#>];
//     [self.client hereNowForChannelGroup:<#(NSString *)group#> withVerbosity:<#(PNHereNowVerbosityLevel)level#> completion:<#(PNChannelGroupHereNowCompletionBlock)block#>];
//     */
//}
//
//
//- (void)pubNubHistory {
//    // History
//    
//    [self.client historyForChannel:_channel1 withCompletion:^(PNHistoryResult *result,
//                                                              PNErrorStatus *status) {
//        
//        // For completion blocks that provide both result and status parameters, you will only ever
//        // have a non-nil status or result.
//        
//        // If you have a result, the data you specifically requested (in this case, history response) is available in result.data
//        // If you have a status, error or non-error status information is available regarding the call.
//        
//        if (status) {
//            // As a status, this contains error or non-error information about the history request, but not the actual history data I requested.
//            // Timeout Error, PAM Error, etc.
//            
//            [self handleStatus:status];
//        }
//        else if (result) {
//            // As a result, this contains the messages, start, and end timetoken in the data attribute
//            
//            MJJLog(@"Loaded history data: %@ with start %@ and end %@", result.data.messages, result.data.start, result.data.end);
//        }
//    }];
//    
//    /*
//     [self.client historyForChannel:<#(NSString *)channel#> start:<#(NSNumber *)startDate#> end:<#(NSNumber *)endDate#> includeTimeToken:<#(BOOL)shouldIncludeTimeToken#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     [self.client historyForChannel:<#(NSString *)channel#> start:<#(NSNumber *)startDate#> end:<#(NSNumber *)endDate#> limit:<#(NSUInteger)limit#> includeTimeToken:<#(BOOL)shouldIncludeTimeToken#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     [self.client historyForChannel:<#(NSString *)channel#> start:<#(NSNumber *)startDate#> end:<#(NSNumber *)endDate#> limit:<#(NSUInteger)limit#> reverse:<#(BOOL)shouldReverseOrder#> includeTimeToken:<#(BOOL)shouldIncludeTimeToken#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     [self.client historyForChannel:<#(NSString *)channel#> start:<#(NSNumber *)startDate#> end:<#(NSNumber *)endDate#> limit:<#(NSUInteger)limit#> reverse:<#(BOOL)shouldReverseOrder#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     [self.client historyForChannel:<#(NSString *)channel#> start:<#(NSNumber *)startDate#> end:<#(NSNumber *)endDate#> limit:<#(NSUInteger)limit#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     [self.client historyForChannel:<#(NSString *)channel#> start:<#(NSNumber *)startDate#> end:<#(NSNumber *)endDate#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     [self.client historyForChannel:<#(NSString *)channel#> withCompletion:<#(PNHistoryCompletionBlock)block#>];
//     */
//    
//}
//
//
//- (void)pubNubTime {
//    
//    [self.client timeWithCompletion:^(PNTimeResult *result, PNErrorStatus *status) {
//        if (result.data) {
//            MJJLog(@"Result from Time: %@", result.data.timetoken);
//        }
//        else if (status) {
//            [self handleStatus:status];
//        }
//    }];
//}
//
//- (void)pubNubPublish {
//    [self.client publish:@"Connected! I'm here!" toChannel:_channel1
//          withCompletion:^(PNPublishStatus *status) {
//              if (!status.isError) {
//                  MJJLog(@"Message sent at TT: %@", status.data.timetoken);
//              } else {
//                  [self handleStatus:status];
//              }
//          }];
//    
//    /*
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> compressed:<#(BOOL)compressed#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> storeInHistory:<#(BOOL)shouldStore#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> storeInHistory:<#(BOOL)shouldStore#> compressed:<#(BOOL)compressed#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> mobilePushPayload:<#(NSDictionary *)payloads#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> mobilePushPayload:<#(NSDictionary *)payloads#> compressed:<#(BOOL)compressed#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> mobilePushPayload:<#(NSDictionary *)payloads#> storeInHistory:<#(BOOL)shouldStore#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     [self.client publish:<#(id)message#> toChannel:<#(NSString *)channel#> mobilePushPayload:<#(NSDictionary *)payloads#> storeInHistory:<#(BOOL)shouldStore#> compressed:<#(BOOL)compressed#> withCompletion:<#(PNPublishCompletionBlock)block#>];
//     */
//    
//}
//
//#pragma mark - Streaming Data didReceiveMessage Listener
//
//- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
//    
//    if (message) {
//        
//        MJJLog(@"Received message: %@ on channel %@ at %@", message.data.message,
//              message.data.subscribedChannel, message.data.timetoken);
//    }
//}
//
//#pragma mark - Streaming Data didReceivePresenceEvent Listener
//
//- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
//    
//    MJJLog(@"^^^^^ Did receive presence event: %@", event.data.presenceEvent);
//}
//
//#pragma mark - Streaming Data didReceiveStatus Listener
//
//- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
//    
//    // This is where we'll find ongoing status events from our subscribe loop
//    // Results (messages) from our subscribe loop will be found in didReceiveMessage
//    // Results (presence events) from our subscribe loop will be found in didReceiveStatus
//    
//    [self handleStatus:status];
//}
//
//#pragma mark - example status handling
//
//- (void)handleStatus:(PNStatus *)status {
//    
//    //    Two types of status events are possible. Errors, and non-errors. Errors will prevent normal operation of your app.
//    //
//    //    If this was a subscribe or presence PAM error, the system will continue to retry automatically.
//    //    If this was any other operation, you will need to manually retry the operation.
//    //
//    //    You can always verify if an operation will auto retry by checking status.willAutomaticallyRetry
//    //    If the operation will not auto retry, you can manually retry by calling [status retry]
//    //    Retry attempts can be cancelled via [status cancelAutomaticRetry]
//    
//    if (status.isError) {
//        [self handleErrorStatus:(PNErrorStatus *)status];
//    } else {
//        [self handleNonErrorStatus:status];
//    }
//    
//}
//
//- (void)handleErrorStatus:(PNErrorStatus *)status {
//    
//    MJJLog(@"^^^^ Debug: %@", status.debugDescription);
//    
//    if (status.category == PNAccessDeniedCategory) {
//        
//        MJJLog(@"^^^^ handleErrorStatus: PAM Error: for resource Will Auto Retry?: %@", status.willAutomaticallyRetry ? @"YES" : @"NO");
//        
//        [self handlePAMError:status];
//    }
//    else if (status.category == PNDecryptionErrorCategory) {
//        
//        MJJLog(@"Decryption error. Be sure the data is encrypted and/or encrypted with the correct cipher key.");
//        MJJLog(@"You can find the raw data returned from the server in the status.data attribute: %@", status.associatedObject);
//        if (status.operation == PNSubscribeOperation) {
//            
//            MJJLog(@"Decryption failed for message from channel: %@\nmessage: %@",
//                  ((PNMessageData *)status.associatedObject).subscribedChannel,
//                  ((PNMessageData *)status.associatedObject).message);
//        }
//    }
//    else if (status.category == PNMalformedFilterExpressionCategory) {
//        
//        MJJLog(@"Value which has been passed to -setFilterExpression: malformed.");
//        MJJLog(@"Please verify specified value with declared filtering expression syntax.");
//    }
//    else if (status.category == PNMalformedResponseCategory) {
//        
//        MJJLog(@"We were expecting JSON from the server, but we got HTML, or otherwise not legal JSON.");
//        MJJLog(@"This may happen when you connect to a public WiFi Hotspot that requires you to auth via your web browser first,");
//        MJJLog(@"or if there is a proxy somewhere returning an HTML access denied error, or if there was an intermittent server issue.");
//    }
//    
//    else if (status.category == PNTimeoutCategory) {
//        
//        MJJLog(@"For whatever reason, the request timed out. Temporary connectivity issues, etc.");
//    }
//    else if (status.category == PNNetworkIssuesCategory) {
//        
//        MJJLog(@"Request can't be processed because of network issues.");
//    }
//    else {
//        // Aside from checking for PAM, this is a generic catch-all if you just want to handle any error, regardless of reason
//        // status.debugDescription will shed light on exactly whats going on
//        
//        MJJLog(@"Request failed... if this is an issue that is consistently interrupting the performance of your app,");
//        MJJLog(@"email the output of debugDescription to support along with all available log info: %@", [status debugDescription]);
//    }
//    if (status.operation == PNHeartbeatOperation) {
//        
//        MJJLog(@"Heartbeat operation failed.");
//    }
//}
//
//- (void)handlePAMError:(PNErrorStatus *)status {
//    // Access Denied via PAM. Access status.data to determine the resource in question that was denied.
//    // In addition, you can also change auth key dynamically if needed."
//    
//    NSString *pamResourceName = status.errorData.channels ? status.errorData.channels.firstObject :
//    status.errorData.channelGroups.firstObject;
//    NSString *pamResourceType = status.errorData.channels ? @"channel" : @"channel-groups";
//    
//    MJJLog(@"PAM error on %@ %@", pamResourceType, pamResourceName);
//    
//    // If its a PAM error on subscribe, lets grab the channel name in question, and unsubscribe from it, and re-subscribe to a channel that we're authed to
//    
//    if (status.operation == PNSubscribeOperation) {
//        
//        if ([pamResourceType isEqualToString:@"channel"]) {
//            MJJLog(@"^^^^ Unsubscribing from %@", pamResourceName);
//            [self reconfigOnPAMError:status];
//        }
//        
//        else {
//            [self.client unsubscribeFromChannelGroups:@[pamResourceName] withPresence:YES];
//            // the case where we're dealing with CGs instead of CHs... follows the same pattern as above
//        }
//        
//    } else if (status.operation == PNPublishOperation) {
//        
//        MJJLog(@"^^^^ Error publishing with authKey: %@ to channel %@.", self.authkey, pamResourceName);
//        MJJLog(@"^^^^ Setting auth to an authKey that will allow for both sub and pub");
//        
//        [self reconfigOnPAMError:status];
//    }
//}
//
//- (void)reconfigOnPAMError:(PNErrorStatus *)status {
//    
//    
//    // If this is a subscribe PAM error
//    
//    if (status.operation == PNSubscribeOperation) {
//        
//        PNSubscribeStatus *subscriberStatus = (PNSubscribeStatus *)status;
//        
//        NSArray *currentChannels = subscriberStatus.subscribedChannels;
//        NSArray *currentChannelGroups = subscriberStatus.subscribedChannelGroups;
//        
//        self.myConfig.authKey = @"myAuthKey";
//        
//        [self.client copyWithConfiguration:self.myConfig completion:^(PubNub *client){
//            
//            self.client = client;
//            
//            [self.client subscribeToChannels:currentChannels withPresence:NO];
//            [self.client subscribeToChannelGroups:currentChannelGroups withPresence:NO];
//        }];
//    }
//    
//}
//
//- (void)handleNonErrorStatus:(PNStatus *)status {
//    
//    // This method demonstrates how to handle status events that are not errors -- that is,
//    // status events that can safely be ignored, but if you do choose to handle them, you
//    // can get increased functionality from the client
//    
//    if (status.category == PNAcknowledgmentCategory) {
//        MJJLog(@"^^^^ Non-error status: ACK");
//        
//        // For methods like Publish, Channel Group Add|Remove|List, APNS Add|Remove|List
//        // when the method is executed, and completes, you can receive the 'ack' for it here.
//        // status.data will contain more server-provided information about the ack as well.
//        
//    }
//    
//    if (status.operation == PNSubscribeOperation) {
//        
//        PNSubscribeStatus *subscriberStatus = (PNSubscribeStatus *)status;
//        // Specific to the subscribe loop operation, you can handle connection events
//        // These status checks are only available via the subscribe status completion block or
//        // on the long-running subscribe loop listener didReceiveStatus
//        
//        // Connection events are never defined as errors via status.isError
//        if (status.category == PNUnexpectedDisconnectCategory) {
//            // PNUnexpectedDisconnect happens as part of our regular operation
//            // This event happens when radio / connectivity is lost
//            
//            MJJLog(@"^^^^ Non-error status: Unexpected Disconnect, Channel Info: %@",
//                  subscriberStatus.subscribedChannels);
//        }
//        
//        else if (status.category == PNConnectedCategory) {
//            
//            // Connect event. You can do stuff like publish, and know you'll get it.
//            // Or just use the connected event to confirm you are subscribed for UI / internal notifications, etc
//            
//            // MJJLog(@"Subscribe Connected to %@", status.data[@"channels"]);
//            MJJLog(@"^^^^ Non-error status: Connected, Channel Info: %@",
//                  subscriberStatus.subscribedChannels);
//            [self pubNubPublish];
//            
//        }
//        else if (status.category == PNReconnectedCategory) {
//            
//            // PNUnexpectedDisconnect happens as part of our regular operation
//            // This event happens when radio / connectivity is lost
//            
//            MJJLog(@"^^^^ Non-error status: Reconnected, Channel Info: %@",
//                  subscriberStatus.subscribedChannels);
//            
//        }
//    }
//    else if (status.operation == PNUnsubscribeOperation) {
//        
//        if (status.category == PNDisconnectedCategory) {
//            
//            // PNDisconnect happens as part of our regular operation
//            // No need to monitor for this unless requested by support
//            MJJLog(@"^^^^ Non-error status: Expected Disconnect");
//        }
//    }
//    else if (status.operation == PNHeartbeatOperation) {
//        
//        MJJLog(@"Heartbeat operation successful.");
//    }
//}
//
//#pragma mark - Configuration
//
//- (void)updateClientConfiguration {
//    
//    // Set PubNub Configuration
//    self.myConfig.TLSEnabled = NO;
//    self.myConfig.uuid = [self randomString];
//    self.myConfig.origin = @"pubsub.pubnub.com";
//    self.myConfig.authKey = self.authkey;
//    
//    // Presence Settings
//    self.myConfig.presenceHeartbeatValue = 120;
//    self.myConfig.presenceHeartbeatInterval = 5;
//    
//    // Cipher Key Settings
//    //    self.myConfig.cipherKey = @"enigma";
//    
//    // Time Token Handling Settings
//    self.myConfig.keepTimeTokenOnListChange = YES;
//    self.myConfig.restoreSubscription = YES;
//    self.myConfig.catchUpOnSubscriptionRestore = YES;
//}
//
//- (NSString *)randomString {
//    return [NSString stringWithFormat:@"%d", arc4random_uniform(74)];
//}
//
//- (void)printClientConfiguration {
//    
//    // Get PubNub Options
//    MJJLog(@"TLSEnabled: %@", (self.myConfig.isTLSEnabled ? @"YES" : @"NO"));
//    MJJLog(@"Origin: %@", self.myConfig.origin);
//    MJJLog(@"authKey: %@", self.myConfig.authKey);
//    MJJLog(@"UUID: %@", self.myConfig.uuid);
//    
//    // Time Token Handling Settings
//    MJJLog(@"keepTimeTokenOnChannelChange: %@",
//          (self.myConfig.shouldKeepTimeTokenOnListChange ? @"YES" : @"NO"));
//    MJJLog(@"resubscribeOnConnectionRestore: %@",
//          (self.myConfig.shouldRestoreSubscription ? @"YES" : @"NO"));
//    MJJLog(@"catchUpOnSubscriptionRestore: %@",
//          (self.myConfig.shouldTryCatchUpOnSubscriptionRestore ? @"YES" : @"NO"));
//    
//    // Get Presence Options
//    MJJLog(@"Heartbeat value: %@", @(self.myConfig.presenceHeartbeatValue));
//    MJJLog(@"Heartbeat interval: %@", @(self.myConfig.presenceHeartbeatInterval));
//    
//    // Get CipherKey
//    MJJLog(@"Cipher key: %@", self.myConfig.cipherKey);
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
