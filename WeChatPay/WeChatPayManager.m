//
//  WeChatPayManager.m
//  WeChatPay
//
//  Created by Qi Chen on 1/19/16.
//  Copyright © 2016 Qi Chen. All rights reserved.
//

#import "WeChatPayManager.h"

#import <CommonCrypto/CommonDigest.h>

#define WX_partnerId @"10000100"
#define WX_key @"192006250b4c09247ec02edce69f6a2d"

@implementation WeChatPayManager

+ (id)sharedManager {
    static WeChatPayManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) pay{
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        PayReq *request = [[PayReq alloc] init];
        
        
//        WX_partnerId;
//        [self prepayId];
//        [self nonceStr];
//        [self timeStamp];
//        [self package];
//        [self sign:dictionary];
        
        
        NSMutableDictionary *dictionary = [self getWeChatDemoData];
        
        NSMutableString *stamp  = [dictionary objectForKey:@"timestamp"];
        
        request.partnerId           = [dictionary objectForKey:@"partnerid"];
        request.prepayId            = [dictionary objectForKey:@"prepayid"];
        request.nonceStr            = [dictionary objectForKey:@"noncestr"];
        request.timeStamp           = stamp.intValue;
        request.package             = [dictionary objectForKey:@"package"];
        request.sign                = [dictionary objectForKey:@"sign"];
        
        
        [WXApi sendReq: request];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"微信未安装或版本过低" message:@"微信未安装或版本过低" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (NSString*) prepayId{
    //get prepayId from server
    return @"1101000000140415649af9fc314aa427";
}

- (NSString*) nonceStr{
    return [self md5:[NSString stringWithFormat:@"%d", arc4random()]];
}

- (UInt32) timeStamp{
    return [[NSDate date] timeIntervalSince1970];
}

- (NSString*) package{
    return @"Sign=WXPay";
}

- (NSString*)sign:(NSMutableDictionary*)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *contentString = [NSMutableString string];
    
    for (NSString *key in sortedKeys) {
        
        NSString *value = [dictionary objectForKey:key];
        
        if (value.length&&![key isEqualToString:@"sign"]) {
            [contentString appendFormat:@"%@=%@&", key, value];
        }
    }
    
    [contentString appendFormat:@"key=%@", WX_key];
    
    return [self md5:contentString];
}

- (NSString*)md5:(NSString*)input{
    
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", result[i]];
    }
    
    return  output;
}

-(NSMutableDictionary*)getWeChatDemoData{
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
//                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //                //调起微信支付
                //                PayReq* req             = [[[PayReq alloc] init]autorelease];
                //                req.partnerId           = [dict objectForKey:@"partnerid"];
                //                req.prepayId            = [dict objectForKey:@"prepayid"];
                //                req.nonceStr            = [dict objectForKey:@"noncestr"];
                //                req.timeStamp           = stamp.intValue;
                //                req.package             = [dict objectForKey:@"package"];
                //                req.sign                = [dict objectForKey:@"sign"];
                //                [WXApi sendReq:req];
                //                //日志输出
                //                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                //                return @"";
                return dict;
            }else{
                //                return [dict objectForKey:@"retmsg"];
            }
        }else{
            //            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        //        return @"服务器返回错误";
    }
    return nil;
}

#pragma mark - WXApiDelegate

-(void)onResp: (BaseResp*)resp{
    if ([resp isKindOfClass: [PayResp class]]){
        NSString *alertTitle = @"支付结果";
        NSString *alertMessage;
        
        switch(resp.errCode){
            case WXSuccess:
                //成功
                alertMessage = @"成功";
                break;
            case WXErrCodeCommon:
                //错误
                alertMessage = @"错误";
                break;
            case WXErrCodeUserCancel:
                //用户取消
                alertMessage = @"用户取消";
                break;
            default:
                NSLog(@"支付失败，retcode=%d", resp.errCode);
                break;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

@end
