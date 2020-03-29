//
//  ViewController.m
//  OnePass
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 Polbyte. All rights reserved.
//

#import "MainViewController.h"
#import <WebKit/WebKit.h>
#import "NativeWeb.h"
#import "CryptoHelper.h"
#import "DiscoveredToken.h"
#import "GeneratedToken.h"
#import "ProximityCommunicationController.h"

@interface MainViewController ()

@property NativeWeb *nativeWeb;
@property ProximityCommunicationController *communictionController;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Webview wrapper
    NSURL *url = [NSURL URLWithString:@"https://polbyte.atthouse.pl/public/virus"];
    self.nativeWeb = [[NativeWeb alloc] init];
    [self.nativeWeb setupForViewController:self withUrl:url];
    self.nativeWeb.webCallback = ^(NativeWeb * _Nonnull object, NWMethod type, NSString * _Nonnull message) {
        
    };
    
    // Local communication
    __weak MainViewController *weakSelf = self;
    self.communictionController = [[ProximityCommunicationController alloc] init];
    [self.communictionController configure];
    self.communictionController.peerDiscoveredCallback = ^(NSString * _Nonnull token) {
        [weakSelf storeDiscoveredToken:token];
        [weakSelf changeTokenIfNeeded];
    };
    self.communictionController.peerLostCallback = ^(NSString * _Nonnull token) {
        [weakSelf storeDiscoveredToken:token];
        [weakSelf changeTokenIfNeeded];
    };
    
    [self changeTokenIfNeeded];
}

#pragma mark - Logic

+ (NSString *)getDeviceToken:(NSString *)preimage {
    NSString *key = [NSString stringWithFormat:@"VIRUSTRACKER||%@", preimage];
    NSString *hash = [CryptoHelper getSha256:key];
    return hash;
}

- (void)storeDiscoveredToken:(NSString *)token {
    NSLog(@"Discovered Count %d", [[DiscoveredToken allObjects] count]);
    DiscoveredToken *dt = [[DiscoveredToken alloc] init];
    dt.startDate = [NSDate date];
    dt.token = token;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:dt];
    }];
}

- (void)changeTokenIfNeeded {
    NSLog(@"Generated Count %d", [[GeneratedToken allObjects] count]);
    GeneratedToken *token = [[GeneratedToken allObjects] lastObject];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:token.date];
    NSLog(@"%@ - %@ - %f", currentDate, token, timeInterval);
    if (timeInterval > 60) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *preimage = [CryptoHelper getSha256:currentDate];
        NSString *generatedToken = [MainViewController getDeviceToken:preimage];
        NSLog(@"New token %@", generatedToken);
        [self.communictionController startOrUpdateWithToken:generatedToken];
        
        GeneratedToken *dt = [[GeneratedToken alloc] init];
        dt.date = [NSDate date];
        dt.token = generatedToken;
        dt.preimage = preimage;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:dt];
        }];
    }
}

@end
