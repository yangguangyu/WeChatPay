//
//  WeChatPayManager.h
//  WeChatPay
//
//  Created by Qi Chen on 1/19/16.
//  Copyright © 2016 Qi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WXApi.h"

@interface WeChatPayManager : NSObject <WXApiDelegate>

+ (instancetype)sharedManager;

- (void) pay;

@end
