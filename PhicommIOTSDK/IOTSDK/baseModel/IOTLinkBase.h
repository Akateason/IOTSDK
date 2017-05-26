//
//  IOTLinkBase.h
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWifiInfo.h"

@interface IOTLinkBase : NSObject

@property (nonatomic,strong)NetWifiInfo *wifiInfo ;

- (void)prepareWhenApplicationDidLaunch ;

- (void)doLinkSuccess:(void(^)(id result))success
                 fail:(void(^)(void))fail ;

@end
