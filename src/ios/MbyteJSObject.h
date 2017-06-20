//
//  MbyteJSObject.h
//  SEC
//
//  Created by yilongxie on 2017/6/19.
//  Copyright © 2017年 yilongxie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDVInAppBrowser.h"

@interface MbyteJSObject : NSObject

//+ (instancetype)objectWithWebView:(UIWebView *)webView;
+ (instancetype)objectWithInAppBrowserVC:(CDVInAppBrowserViewController *)inAppBrowserVC;
-(void)close;

@end
