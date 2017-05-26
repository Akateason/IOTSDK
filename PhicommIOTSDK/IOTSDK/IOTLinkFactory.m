//
//  IOTLinkFactory.m
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/26.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "IOTLinkFactory.h"
#import "SmartConfigLink.h"

@interface IOTLinkFactory () //// link ways
@property (nonatomic,strong) SmartConfigLink *smartConfigLink ; // smartconfig esptouch
@end

@implementation IOTLinkFactory

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static IOTLinkFactory *instance ;
    dispatch_once(&onceToken, ^{
        instance = [[IOTLinkFactory alloc] init] ;
    });
    return instance ;
}

- (NSString *)ssidWithType:(TypeOf_IOTLinkFactory)type
{
    switch (type)
    {
        case TypeOf_IOTLinkFactory_SmartConfigEsptouch:
        {
            return self.smartConfigLink.wifiInfo.ssid ;
            
        }
            break;
            
        default:
            break;
    }
}

- (void)prepareWithType:(TypeOf_IOTLinkFactory)type
{
    switch (type)
    {
        case TypeOf_IOTLinkFactory_SmartConfigEsptouch:
        {
            [self.smartConfigLink prepareWhenApplicationDidLaunch] ;
        }
            break;
            
        default:
            break;
    }
}

- (void)doLinkWithWifiPassword:(NSString *)pwd
                         Type:(TypeOf_IOTLinkFactory)type
                      success:(void(^)(id result))success
                         fail:(void(^)(void))fail
{
    switch (type)
    {
        case TypeOf_IOTLinkFactory_SmartConfigEsptouch:
        {
            self.smartConfigLink.wifiInfo.pwd = pwd ; // pwd
            self.smartConfigLink.taskCount = 1 ; // taskCount default is 1
            [self.smartConfigLink doLinkSuccess:success
                                fail:fail] ;
        }
            break ;
            
        default:
            break ;
    }
}


#pragma mark - private
#pragma mark - prop
- (SmartConfigLink *)smartConfigLink
{
    if (!_smartConfigLink) {
        _smartConfigLink = [SmartConfigLink new] ;
    }
    return _smartConfigLink ;
}


@end
