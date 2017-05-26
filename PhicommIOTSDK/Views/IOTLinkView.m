//
//  IOTLinkView.m
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "IOTLinkView.h"

@implementation IOTLinkView

- (IBAction)btLinkOnClick:(id)sender
{
    if (self.btLinkOnClickBLock)
    {
        self.btLinkOnClickBLock() ;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

