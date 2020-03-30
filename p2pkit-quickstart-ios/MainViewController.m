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
#import "AltBeacon/AltBeaconController.h"
#import "VirusRESTClient.h"
#import "ProximityEvent.h"
#import "UserSettings.h"
#import "NSObject+Api.h"
#import "NSDate+Api.h"

@interface MainViewController ()

@property NativeWeb *nativeWeb;
@property AltBeaconController *communictionController;
@property VirusRESTClient *restClient;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak MainViewController *weakSelf = self;
    
    // Webview wrapper
//    NSURL *url = [NSURL URLWithString:@"https://polbyte.atthouse.pl/public/virus"];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"vt-app-ui"]];
    self.nativeWeb = [[NativeWeb alloc] init];
    [self.nativeWeb setupForViewController:self withUrl:url];
    self.nativeWeb.webCallback = ^(NativeWeb * _Nonnull object, NWMethod type, NSString * _Nonnull message) {
        if (type == NWMethodGetProximityEvents || type == NWMethodSyncData) {
            NSLog(@"Get proximity events %@", message);
            [weakSelf loadDataFromRestAndGenerateProximityEventsWithCompletion:^{
                [weakSelf pushDataToWebView];
            }];
        }
        else if (type == NWMethodAddInfectionRequest) {
            NSLog(@"Add infection request %@", message);
            [object webAppendJSCode:[NSString stringWithFormat:@"nw.callbackInfectionRequest(%d)", 1]];
        }
        else if (type == NWMethodGetUserSettings) {
            NSLog(@"Get user settings");
            UserSettings *settings = [[UserSettings allObjects] firstObject];
            if (settings == nil) {
                settings = [[UserSettings alloc] init];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm addObject:settings];
                }];
            }
            NSDictionary *settinsDictionary = [settings getDictionary];
            NSString *settingsJson = [settinsDictionary jsonString];
            [object webAppendJSCode:[NSString stringWithFormat:@"nw.callbackUserSettings('%@')", settingsJson]];
        }
        else if (type == NWMethodSetUserSettings) {
            UserSettings *settings = [[UserSettings allObjects] firstObject];
            if (settings == nil) {
                settings = [[UserSettings alloc] init];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm addObject:settings];
                }];
            }
            if (message) {
                NSDictionary *settinsDictionary = [message dictionaryFromJSONString];
                NSLog(@"Settings to save %@", settinsDictionary);
                if (settinsDictionary) {
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    [settings setWith:settinsDictionary];
                    [realm commitWriteTransaction];
                }
            }
        }
    };
    
    // Local communication
    self.communictionController = [[AltBeaconController alloc] init];
    [self.communictionController configure];
    self.communictionController.peerDiscoveredCallback = ^(NSString * _Nonnull token, NSUInteger distanceType) {
        DiscoveredToken *existingToken = [[DiscoveredToken objectsWhere:@"token == %@", token] firstObject];
        if (existingToken == nil) {
            NSLog(@"Peer discovered %@", token);
            [weakSelf storeDiscoveredToken:token andDistanceType:(int)distanceType];
            [weakSelf changeTokenIfNeeded];
            
            [weakSelf loadDataFromRestAndGenerateProximityEventsWithCompletion:^{
                [weakSelf pushDataToWebView];
            }];
        } else {
            long currentTimestampMs = [[NSDate date] timeIntervalSince1970]*1000;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            existingToken.duration = currentTimestampMs - existingToken.timestamp;
            [realm commitWriteTransaction];
//            NSLog(@"Update %@ duration %ld", existingToken.token, existingToken.duration);
        }
    };
    self.communictionController.peerLostCallback = ^(NSString * _Nonnull token) {
        [weakSelf changeTokenIfNeeded];
    };
    NSString *currentDate = [[NSDate date] timestampString];
    NSString *preimage = [CryptoHelper getSha256:currentDate];
    NSString *generatedToken = [MainViewController getDeviceToken:preimage];
    [self.communictionController startOrUpdateWithToken:generatedToken];
    
    [self changeTokenIfNeeded];
    
    self.restClient = [[VirusRESTClient alloc] init];
    
    [self loadDataFromRestAndGenerateProximityEventsWithCompletion:^{
        [self pushDataToWebView];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

#pragma mark - Logic

+ (NSString *)getDeviceToken:(NSString *)preimage {
    NSString *key = [NSString stringWithFormat:@"VIRUSTRACKER||%@", preimage];
    NSString *hash = [CryptoHelper getSha256:key];
    return hash;
}

- (void)storeDiscoveredToken:(NSString *)token andDistanceType:(int)distanceType {
    NSLog(@"Discovered Count %lu", [[DiscoveredToken allObjects] count]);
    DiscoveredToken *dt = [[DiscoveredToken alloc] init];
    dt.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    dt.duration = 0;
    dt.token = token;
    dt.distanceType = distanceType;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:dt];
    }];
}

- (void)changeTokenIfNeeded {
    NSUInteger generatedCount = [[GeneratedToken allObjects] count];
    NSLog(@"Generated Count %lu", generatedCount);
    GeneratedToken *token = [[GeneratedToken allObjects] lastObject];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:token.date];
    if (timeInterval > 5* 60 || generatedCount == 0) {
        
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

- (void)pushDataToWebView {
    
    // Events
    NSMutableArray *plainList = [NSMutableArray array];
    RLMResults *results = [ProximityEvent allObjects];
    for (ProximityEvent *event in results) {
        NSDictionary *eventDictionary = [event getDictionary];
        [plainList addObject:eventDictionary];
    }
    
    // Tokens
    NSMutableDictionary *tokenMap = [NSMutableDictionary dictionary];
    RLMResults *discoveredTokenList = [DiscoveredToken allObjects];
    for (DiscoveredToken *discoveredToken in discoveredTokenList) {
        NSString *tokenTimestamp = [[[NSDate dateWithTimeIntervalSince1970:discoveredToken.timestamp/1000] dateWithoutTime] timestampString];
        if ([tokenMap objectForKey:tokenTimestamp]) {
            
        } else {
            tokenMap[tokenTimestamp] = @(0);
        }
        tokenMap[tokenTimestamp] = @([tokenMap[tokenTimestamp] integerValue]+1);
    }
    NSMutableArray *tokenList = [NSMutableArray array];
    for (NSString *timestampString in tokenMap) {
        NSDate *timestampDate = [NSDate dateFromString:timestampString];
        NSNumber *timestamp = @([timestampDate timeIntervalSince1970]*1000);
        NSDictionary *item = @{@"timestamp":timestamp, @"count":tokenMap[timestampString]};
        [tokenList addObject:item];
    }
    
    NSLog(@"Push tokens %@, events %@", tokenList, plainList);
    
    NSString *listJSON = [@{@"tokens": tokenList, @"events": plainList} jsonString];
    [self.nativeWeb webAppendJSCode:[NSString stringWithFormat:@"nw.callbackProximityEventList('%@')", listJSON]];
}

- (void)loadDataFromRestAndGenerateProximityEventsWithCompletion:(void(^)(void))completion {
    [self.restClient getInfectedTokenList:^(NSArray<RESTToken *> * _Nonnull restTokenList) {
        
        NSMutableArray *eventList = [NSMutableArray array];
        RLMResults *discoveredTokenList = [DiscoveredToken allObjects];
        for (RESTToken *restToken in restTokenList) {
            for (DiscoveredToken *discoveredToken in discoveredTokenList) {
                if ([restToken.value isEqualToString:discoveredToken.token]) {
                    ProximityEvent *event = [[ProximityEvent alloc] init];
                    event.distanceType = discoveredToken.distanceType;
                    event.timestampMs = discoveredToken.timestamp;
                    [eventList addObject:event];
                }
            }
        }
        
        NSLog(@"Store %lu events", eventList.count);
        if (eventList.count > 0) {
            
        }
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObjects:eventList];
        }];
        
        if (completion) {
            completion();
        }
    }];
}

@end
