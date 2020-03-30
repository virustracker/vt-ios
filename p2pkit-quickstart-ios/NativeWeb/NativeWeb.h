//
//  Native.h
//  OnePass
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 Polbyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NWMethod) {
    NWMethodLog = 0,
    NWMethodCodeScannerStart = 10,
    NWMethodCodeScannerPause = 11,
    NWMethodCodeScannerContinue = 12,
    NWMethodCodeScannerStop = 13,
    NWMethodGetHash = 14,
    NWMethodGetProximityEvents = 15,
    NWMethodAddInfectionRequest = 16,
    NWMethodGetUserSettings = 17,
    NWMethodSetUserSettings = 18,
    NWMethodSyncData = 19
};

typedef NS_ENUM(NSUInteger, NWScanOption) {
    NWScanOptionModal,
    NWScanOptionBackground
};

@interface NativeWeb : NSObject

- (void)setupForViewController:(UIViewController *)viewController withUrl:(NSURL *)url;

@property (copy) void (^webCallback)(NativeWeb *object, NWMethod type, NSString *message);

//
// Webview

- (void)webAppendJSCode:(NSString *)code;

//
// Native

- (void)codeScannerStartWithOption:(NWScanOption)option andScanCallback:(void (^)(NativeWeb *object, NSString *code))scanCallback;
- (void)codeScannerPause;
- (void)codeScannerContinue;
- (void)codeScannerStop;

@end

NS_ASSUME_NONNULL_END
