//
//  Native.m
//  OnePass
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 Polbyte. All rights reserved.
//

#import "NativeWeb.h"
#import "UIView+Api.h"
#import "BCScanner/BCScannerView.h"

@interface NativeWeb () <BCScannerViewDelegate, WKScriptMessageHandler, WKUIDelegate>

@property WKWebView *webView;
@property UIViewController *viewController;
@property BCScannerView *scannerView;

@property NWScanOption scanOption;
@property (copy) void (^scanCallback)(NativeWeb *object, NSString *code);

@end

@implementation NativeWeb

#pragma mark - Public

- (void)setupForViewController:(UIViewController *)viewController withUrl:(nonnull NSURL *)url {
    
    self.viewController = viewController;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"NativeWeb"];
    config.userContentController = controller;
    
    self.webView = [[WKWebView alloc] initWithFrame:viewController.view.frame configuration:config];
    self.webView.scrollView.bounces = false;
    self.webView.UIDelegate = self;
    [viewController.view addSubview:self.webView];
    [self.webView addConstraintsToFillSuperview];
    
    self.webView.backgroundColor = UIColor.clearColor;
    for (UIView *view in self.webView.subviews) {
        view.backgroundColor = UIColor.clearColor;
        for (UIView *subview in view.subviews) {
            subview.backgroundColor = UIColor.clearColor;
        }
    }
    self.webView.opaque = NO;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}

- (void)webAppendJSCode:(NSString *)code {
    [self.webView evaluateJavaScript:code completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        
    }];
}

- (void)codeScannerStartWithOption:(NWScanOption)option andScanCallback:(void (^)(NativeWeb *object, NSString *code))scanCallback {
    if (option == NWScanOptionBackground) {
        if ([BCScannerView scannerAvailable]) {
            self.scanOption = option;
            self.scanCallback = scanCallback;
            [self showVideoBackground];
        }
    }
}

- (void)codeScannerPause {
    [self.scannerView stopRunning];
}

- (void)codeScannerContinue {
    [self.scannerView continueRunning];
}

- (void)codeScannerStop {
    [self.scannerView stopRunning];
    [self.scannerView teardownCaptureSession];
    [self.scannerView removeFromSuperview];
    self.scannerView = nil;
    self.scanCallback =  nil;
}

#pragma mark - Private

- (void)showVideoBackground {
    self.scannerView = [BCScannerView new];
    self.scannerView.delegate = self;
    self.scannerView.backgroundColor = UIColor.lightGrayColor;
    self.scannerView.viewController = self.viewController;
    [self.viewController.view insertSubview:self.scannerView atIndex:0];
    [self.scannerView addConstraintsToFillSuperview];
    [self.scannerView setup];
    self.scannerView.codeTypes = [NativeWeb allCodeTypes];
}

#pragma mark - BCScannerViewDelegate

+ (NSArray *)allCodeTypes {
    return @[ BCScannerUPCECode, BCScannerCode39Code, BCScannerCode39Mod43Code, BCScannerEAN13Code, BCScannerEAN8Code, BCScannerCode93Code, BCScannerCode128Code, BCScannerPDF417Code, BCScannerQRCode, BCScannerAztecCode, BCScannerI25Code, BCScannerITF14Code, BCScannerDataMatrixCode ];
}

- (void)scanner:(BCScannerView *)scanner codesDidEnterFOV:(NSSet *)codes
{
    NSString *code = codes.allObjects.firstObject;
    if (self.scanCallback != nil) {
        self.scanCallback(self, code);
    }
//    NSLog(@"Added: [%@]", code);
}

- (void)scanner:(BCScannerView *)scanner codesDidLeaveFOV:(NSSet *)codes
{
//    NSLog(@"Deleted: [%@]", codes);
}

- (UIImage *)scannerHUDImage:(BCScannerView *)scanner
{
    return [UIImage imageNamed:@"hud"];
}

//
// From Webview

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    NSLog(@"Message: %@", message.body);
    
    NSData* jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    NSMutableDictionary *dictionary = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError] mutableCopy];
    if (dictionary != nil) {
        long method = [dictionary[@"method"] integerValue];
        [dictionary removeObjectForKey:@"method"];
        
        if (method == NWMethodLog) {
            NSLog(@"Log: %@", message.body);
        }
        else if (method == NWMethodCodeScannerStart) {
            [self codeScannerStartWithOption:[dictionary[@"option"] integerValue] andScanCallback:^(NativeWeb * _Nonnull object, NSString * _Nonnull code) {
                
            }];
        }
        else if (method == NWMethodCodeScannerPause) {
            [self codeScannerPause];
        }
        else if (method == NWMethodCodeScannerContinue) {
            [self codeScannerContinue];
        }
        else if (method == NWMethodCodeScannerStop) {
            [self codeScannerStop];
        }
        else if (method == NWMethodGetHash) {
            
        }
        if (self.webCallback) {
            self.webCallback(self, method, message.body);
        }
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self.viewController presentViewController:alertController animated:YES completion:^{}];
}

@end
