//
//  IOTLinkBase+FetchNetInfo.h
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "IOTLinkBase.h"

@interface IOTLinkBase (FetchNetInfo)

- (NSString *)fetchSsid ;

- (NSString *)fetchBssid ;

- (NSDictionary *)fetchNetInfo ;

@end
