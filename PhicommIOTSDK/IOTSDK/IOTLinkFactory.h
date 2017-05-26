//
//  IOTLinkFactory.h
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/26.
//  Copyright © 2017年 teaason. All rights reserved.
//  singleton class in simple factory modue.



#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TypeOf_IOTLinkFactory_SmartConfigEsptouch = 0 ,
    
} TypeOf_IOTLinkFactory ;


@class NetWifiInfo ;
@interface IOTLinkFactory : NSObject

+ (instancetype)shareInstance ;

- (NSString *)ssidWithType:(TypeOf_IOTLinkFactory)type ;

- (void)prepareWithType:(TypeOf_IOTLinkFactory)type ;

- (void)doLinkWithWifiPassword:(NSString *)pwd
                          Type:(TypeOf_IOTLinkFactory)type
                       success:(void(^)(id result))success
                          fail:(void(^)(void))fail ;
@end
