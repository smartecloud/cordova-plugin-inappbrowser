<!---
 license: Licensed to the Apache Software Foundation (ASF) under one
         or more contributor license agreements.  See the NOTICE file
         distributed with this work for additional information
         regarding copyright ownership.  The ASF licenses this file
         to you under the Apache License, Version 2.0 (the
         "License"); you may not use this file except in compliance
         with the License.  You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

         Unless required by applicable law or agreed to in writing,
         software distributed under the License is distributed on an
         "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
         KIND, either express or implied.  See the License for the
         specific language governing permissions and limitations
         under the License.
-->

# org.apache.cordova.inappbrowser

Plugin documentation: [doc/index.md](doc/index.md)



### iOS  打开本地录音、视频 出现 - 204 错误

	- (void)webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
	{
    	if(error.code == - 204)
       	 return;
       	 
    	// log fail message, stop spinner, update back/forward
   		 NSLog(@"webView:didFailLoadWithError - %ld: %@", (long)error.code, [error localizedDescription]);
    
   		self.backButton.enabled = theWebView.canGoBack;
    	self.forwardButton.enabled = theWebView.canGoForward;
    	[self.spinner stopAnimating];
    
    	//self.addressLabel.text = NSLocalizedString(@"Load Error", nil);
    	self.addressLabel.text = @"";//当为录音和视频时显示error的问题
    	[self.navigationDelegate webView:theWebView didFailLoadWithError:error];
	}


####	- (void)navigateTo:(NSURL*)url

	- (void)navigateTo:(NSURL*)url{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"MediaCapture"];
    NSLog(@"documentPath >> %d",[[NSString stringWithFormat:@"%@",url] rangeOfString:@"file"].location);
    
    if([[NSString stringWithFormat:@"%@",url] rangeOfString:@"file"].location== NSNotFound) {
        //[[UIApplication sharedApplication] openURL:url];
    }else
    {
        //NSMutableArray *array = []
        NSString *filename = [[url absoluteString] lastPathComponent];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath, filename];
        NSLog(@"filePaht >>> %@",filePath);
        url = [NSURL URLWithString:filePath];
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    if (_userAgentLockToken != 0) {
        [self.webView loadRequest:request];
    } else {
        [CDVUserAgentUtil acquireLock:^(NSInteger lockToken) {
            _userAgentLockToken = lockToken;
            [CDVUserAgentUtil setUserAgent:_userAgent lockToken:lockToken];
            [self.webView loadRequest:request];
        }];
    	}
	}
####
	- (BOOL)webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:	(UIWebViewNavigationType)navigationType
	{
    //
    if([[NSString stringWithFormat:@"%@",request.URL] rangeOfString:@"file"].location== NSNotFound) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    ....
    }