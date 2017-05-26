//
//  IOTLinkBase.m
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "IOTLinkBase.h"
#import "IOTLinkBase+FetchNetInfo.h"


@implementation IOTLinkBase

#pragma mark - public
- (NetWifiInfo *)wifiInfo
{
    if (!_wifiInfo) {
        _wifiInfo = [self fetchNewWifiInfo] ;
    }
    return _wifiInfo ;
}

- (void)prepareWhenApplicationDidLaunch
{
    
}

- (void)doLinkSuccess:(void(^)(id result))success
                 fail:(void(^)(void))fail
{
    
}

#pragma mark - private
- (NetWifiInfo *)fetchNewWifiInfo
{
    NSDictionary *netInfo = [self fetchNetInfo] ;
    NetWifiInfo *wifiINfo = [NetWifiInfo new] ;
    wifiINfo.pwd    = nil ;
    wifiINfo.ssid   = [netInfo objectForKey:@"SSID"] ;
    wifiINfo.bssid  = [netInfo objectForKey:@"BSSID"] ;
    return wifiINfo ;
}

@end









