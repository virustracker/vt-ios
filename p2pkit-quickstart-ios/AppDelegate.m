//
//  AppDelegate.m
//  p2pkit-quickstart-ios
//
//  Copyright (c) 2015 Uepaa AG. All rights reserved.
//

#import "AppDelegate.h"
#import "NearbyPeersViewControlleriOS.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    // DB setup
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *customRealmPath = [documentsDirectory stringByAppendingPathComponent:@"db.realm"];
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = [NSURL URLWithString:customRealmPath];
    return YES;
}

-(void)applicationWillTerminate:(UIApplication*)application {
    
}

@end
