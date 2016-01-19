//
//  ViewController.m
//  WeChatPay
//
//  Created by Qi Chen on 1/19/16.
//  Copyright © 2016 Qi Chen. All rights reserved.
//

#import "ViewController.h"

#import "WXApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weChatPay:(id)sender {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"wx20160119103005b46aa7998c0757063639";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"d11e7d48da10c094f0be86f06d733b14";
    request.timeStamp= 1453170605;
    request.sign= @"6A9C22F23B31C41448F96894E107940D";
    [WXApi sendReq: request];
    
    
    
//    appid=wxb4ba3c02aa476ea1
//    partid=10000100
//    prepayid=wx20160119103005b46aa7998c0757063639
//    noncestr=d11e7d48da10c094f0be86f06d733b14
//    timestamp=1453170605
//    package=Sign=WXPay
//    sign=6A9C22F23B31C41448F96894E107940D
}

@end
