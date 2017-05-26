//
//  IOTLinkView.h
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtLinkOnClick)(void);

@interface IOTLinkView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btLink;
@property (weak, nonatomic) IBOutlet UILabel *lbSsid;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfTaskCount;

@property (nonatomic,copy) BtLinkOnClick btLinkOnClickBLock ;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
