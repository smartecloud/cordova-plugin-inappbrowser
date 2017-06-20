//
//  MbyteJSObject.h
//  SEC
//
//  Created by yilongxie on 2017/6/19.
//  Copyright © 2017年 yilongxie. All rights reserved.
//

#import "MbyteJSObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@protocol MbyteJSExport <JSExport>

//- (void)nslog:(NSString *)str;
/*JSExportAs(showconfirm, - (void)showconfirm:(NSString*)str Scripts:(NSString*)scripts);
 这个方法没有，这个方法的作用是当js端的方法有两个或两个以上参数时，我们需要让
 - (void)showconfirm:(NSString*)str Scripts:(NSString*)scripts这个方法代替 showconfirm 这个方法，因为oc端的方法名必须和js端的保持一致，不然就不会调用
 */
JSExportAs(mNSLog, - (void)printWithString:(NSString *)string callback:(NSString *)callback  );
JSExportAs(exchange, - (void)exchange:(NSString *)handler objData:(NSString *)objData);
-(void)goClose;
-(void)close;

@end


@interface MbyteJSObject()<MbyteJSExport>

//- (void)nslog:(NSString *)str;
@property(strong, nonatomic) UIWebView *webView;
@property(strong, nonatomic) CDVInAppBrowserViewController *inAppBrowserVC;
@end

@implementation MbyteJSObject

//- (instancetype)initWithWebView:(UIWebView *)webView {
//    if (self = [super init]) {
//        _webView = webView;
//    }
//    return self;
//}

- (instancetype)initWithVC:(CDVInAppBrowserViewController *)inAppBrowserVC {
    if (self = [super init]) {
        _inAppBrowserVC = inAppBrowserVC;
    }
    return self;
}

//+ (instancetype)objectWithWebView:(UIWebView *)webView {
//    return [[self alloc] initWithWebView:webView];
//}

+ (instancetype)objectWithInAppBrowserVC:(CDVInAppBrowserViewController *)inAppBrowserVC
{
    return [[self alloc] initWithVC:inAppBrowserVC];
}

-(NSString *)getAccessToken
{
    return @"This is self token";
}

-(void)close
{
    [self.inAppBrowserVC close];
}

//- (void)nslog:(NSString *)str {
//    NSLog(@"测试一下JavaScript!");
//}

- (void)printWithString:(NSString *)string callback:(NSString *)callback {
    NSLog(@"%@", string);
    NSString *callbackJS = [NSString stringWithFormat:@"%@('我是callback')", callback];
    //    [self.webView stringByEvaluatingJavaScriptFromString:callbackJS];
    [self.webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackJS afterDelay:1];
    //网页加载完成调用此方法
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
    [context evaluateScript:callbackJS];//通过oc方法调用js的alert
}

- (void)exchange:(NSString *)handler objData:(NSString *)objData {
    //NSLog(@"%@", handler);
    //[self.inAppBrowserVC receiveJSDate:handler objData:objData];
    if ((self.inAppBrowserVC.navigationDelegate != nil) && [self.inAppBrowserVC.navigationDelegate respondsToSelector:@selector(sendUpdate:objData:)]) {
        [self.inAppBrowserVC.navigationDelegate  sendUpdate:handler objData:objData];
    }

}


@end
