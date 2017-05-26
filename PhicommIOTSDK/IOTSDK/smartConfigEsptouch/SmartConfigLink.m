//
//  SmartConfigLink.m
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.

//  SmartConfig esptouch   //

#import "SmartConfigLink.h"
#import "ESP_NetUtil.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import <UIKit/UIAlertView.h>
#import "IOTLinkBase+FetchNetInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@interface SmartConfigLink () <ESPTouchDelegate>
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

// the state of the confirm/cancel button
@property (nonatomic, assign) BOOL _isConfirmState;

// without the condition, if the user tap confirm/cancel quickly enough,
// the bug will arise. the reason is follows:
// 0. task is starting created, but not finished
// 1. the task is cancel for the task hasn't been created, it do nothing
// 2. task is created
// 3. Oops, the task should be cancelled, but it is running
@property (nonatomic, strong) NSCondition *_condition;
@end


typedef void(^LinkSuccess)(void) ;
typedef void(^LinkFailure)(void) ;

@interface SmartConfigLink ()
@property (nonatomic,copy) LinkSuccess successBlock ;
@property (nonatomic,copy) LinkSuccess LinkFailure ;
@end

@implementation SmartConfigLink

- (instancetype)init
{
    self = [super init];
    if (self) {
        self._isConfirmState = YES ;
    }
    return self;
}

- (void)prepareWhenApplicationDidLaunch
{
    [ESP_NetUtil tryOpenNetworkPermission] ;
}

- (void)doLinkSuccess:(void(^)(id result))success
                 fail:(void(^)(void))fail
{
    // do confirm
    if (self._isConfirmState)
    {
//        [self._spinner startAnimating];
//        [self enableCancelBtn];
        self._isConfirmState = NO;
        NSLog(@"smartconfigesp do confirm action...");
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"smartconfigesp do the execute work...");
            // execute the task
            NSArray *esptouchResultArray = [self executeForResults];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self._spinner stopAnimating];
//                [self enableConfirmBtn];
                self._isConfirmState = YES;
                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                // check whether the task is cancelled and no results received
                if (!firstResult.isCancelled)
                {
                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
                    NSUInteger count = 0;
                    // max results to be displayed, if it is more than maxDisplayCount,
                    // just show the count of redundant ones
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc])
                    {
                        for (int i = 0; i < [esptouchResultArray count]; ++i)
                        {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount)
                            {
                                break;
                            }
                        }
                        
                        if (count < [esptouchResultArray count])
                        {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]] ;
                        }
                        
                        if (success) success(mutableStr) ;
                    }
                    
                    else
                    {
                        if (fail) fail() ;
                    }
                }
                
            });
        });
    }
    // do cancel
    else
    {
//        [self._spinner stopAnimating];
//        [self enableConfirmBtn];
        self._isConfirmState = YES;
        NSLog(@"smartconfigesp do cancel action...");
        [self cancel];
        if (fail) fail() ;
    }
}


#pragma mark - the example of how to cancel the executing task

- (void)cancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}

#pragma mark - the example of how to use executeForResults
- (NSArray *)executeForResults
{
    [self._condition lock] ;
    NSString *apPwd = self.wifiInfo.pwd ; // need send in VIEW .
    NSString *apSsid = self.wifiInfo.ssid ;
    NSString *apBssid = self.wifiInfo.bssid ;
    // taskCount
    int taskCount = self.taskCount ?: 1 ;
    //
    self._esptouchTask = [[ESPTouchTask alloc] initWithApSsid:apSsid
                                                   andApBssid:apBssid
                                                     andApPwd:apPwd] ;
    // set delegate
    [self._esptouchTask setEsptouchDelegate:self] ;
    [self._condition unlock] ;
    NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount] ;
    NSLog(@"smartconfigesp executeForResult() result is: %@",esptouchResults) ;
    return esptouchResults;
}

#pragma mark - esptouchDelegate
- (void)onEsptouchResultAddedWithResult:(ESPTouchResult *)result
{  //linking wifi ...
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithResult:result] ;
    });
}

- (void)dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES] ;
}

- (void)showAlertWithResult:(ESPTouchResult *)result
{
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@ is connected to the wifi" , result.bssid];
    NSTimeInterval dismissSeconds = 3.5;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:dismissSeconds];
}


@end
