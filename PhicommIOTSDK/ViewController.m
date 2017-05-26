//
//  ViewController.m
//  PhicommIOTSDK
//
//  Created by teason23 on 2017/5/25.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "ViewController.h"
#import "IOTLinkView.h"
#import "IOTLinkFactory.h"

@interface ViewController ()
@property (nonatomic,strong) IOTLinkView *linkView ;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    //1
    [self layoutUIs] ;
    //2 set ssid on view
    self.linkView.lbSsid.text = [[IOTLinkFactory shareInstance] ssidWithType:TypeOf_IOTLinkFactory_SmartConfigEsptouch] ;    
    //3 link
    __weak ViewController *weakSelf = self ;
    self.linkView.btLinkOnClickBLock = ^{
        // do link
        [weakSelf.linkView.activityView startAnimating] ;
        // complete
        [[IOTLinkFactory shareInstance] doLinkWithWifiPassword:weakSelf.linkView.tfPassword.text
                                                          Type:TypeOf_IOTLinkFactory_SmartConfigEsptouch
                                                       success:^(id result) {
                                                  
                                                  [weakSelf.linkView.activityView stopAnimating] ;
                                                  [[[UIAlertView alloc] initWithTitle:@"Execute Result"
                                                                              message:result
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"I know"
                                                                    otherButtonTitles:nil] show] ;
                                                           
                                                       }
                                                          fail:^{
                                                     
                                                     [weakSelf.linkView.activityView stopAnimating] ;
                                                     [[[UIAlertView alloc] initWithTitle:@"Execute Result"
                                                                                 message:@"Execute fail"
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"I know"
                                                                       otherButtonTitles:nil] show] ;

                                                          }] ;
        
    } ;
    //
    
}

- (void)layoutUIs
{
    self.linkView = ({
        IOTLinkView *linkView = [[[NSBundle mainBundle] loadNibNamed:@"IOTLinkView" owner:self options:nil] lastObject] ;
        linkView.frame = CGRectMake(0,
                                    0,
                                    [UIScreen mainScreen].bounds.size.width,
                                    CGRectGetHeight(linkView.frame)) ;
        [self.view addSubview:linkView] ;
        linkView ;
    }) ;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews] ;
    self.linkView.center = self.view.center ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
