//
//  ProximityCommunicationController.m
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import "ProximityCommunicationController.h"
#import <P2PKit/P2PKit.h>

@interface ProximityCommunicationController () <PPKControllerDelegate>

@end

@implementation ProximityCommunicationController

- (void)configure {
    [PPKController enableWithConfiguration:@"7459a9a5aba94b3c9a170651674b3c09" observer:self];
}

- (void)startOrUpdateWithToken:(NSString *)token {
    [self startOrUpdateDiscoveryWithToken:token];
}

- (void)stop {
    [PPKController disable];
}

- (BOOL)startOrUpdateDiscoveryWithToken:(NSString *)token {
    
    NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
    
    if(![PPKController isEnabled]){
        NSLog(@"Failed to update color, p2pkit is not running");
        return NO;
    }
    
    BOOL success = NO;
    
    switch ([PPKController discoveryState]) {
            
            // case p2pkit discovery not yet started
        case PPKDiscoveryStateStopped:
            
            [PPKController enableProximityRanging];
            [PPKController startDiscoveryWithDiscoveryInfo:data stateRestoration:NO];
            success = YES;
            
            break;
            
            // case p2pkit discovery is already runnning/suspended
        case PPKDiscoveryStateServerConnectionUnavailable:
        case PPKDiscoveryStateSuspended:
        case PPKDiscoveryStateRunning:
            
            @try {
                [PPKController pushNewDiscoveryInfo:data];
                success = YES;
            } @catch (NSException *exception) {
                NSLog(@"Failed! Discovery info update is limited to once per 60 seconds");
                success = NO;
            }
            
            break;
            
        default:
            break;
    }
    
    return success;
}

- (void)PPKControllerFailedWithError:(PPKErrorCode)error {
    
    NSString *description;
    
    switch (error) {
        case PPKErrorInvalidAppKey:
            description = @"Invalid app key";
            break;
        case PPKErrorInvalidBundleId:
            description = @"Invalid bundle ID";
            break;
        case PPKErrorIncompatibleClientVersion:
            description = @"Incompatible p2pkit (SDK) version, please update";
            break;
        default:
            description = @"Unknown error";
            break;
    }
    
    NSLog(@"%@", description);
}

-(BOOL)startOrUpdateDiscoveryWithDiscoveryInfo:(NSData*)data {
    
    if(![PPKController isEnabled]){
        NSLog(@"Failed to update color, p2pkit is not running");
        return NO;
    }
    
    BOOL success = NO;
    
    switch ([PPKController discoveryState]) {
            
            // case p2pkit discovery not yet started
        case PPKDiscoveryStateStopped:
            
            [PPKController enableProximityRanging];
            [PPKController startDiscoveryWithDiscoveryInfo:data stateRestoration:NO];
            success = YES;
            
            break;
            
            // case p2pkit discovery is already runnning/suspended
        case PPKDiscoveryStateServerConnectionUnavailable:
        case PPKDiscoveryStateSuspended:
        case PPKDiscoveryStateRunning:
            
            @try {
                [PPKController pushNewDiscoveryInfo:data];
                success = YES;
            } @catch (NSException *exception) {
                NSLog(@"Failed! Discovery info update is limited to once per 60 seconds");
                success = NO;
            }
            
            break;
            
        default:
            break;
    }
    
    return success;
}

-(void)stopDiscovery {
    [PPKController stopDiscovery];
}

-(void)peerDiscovered:(PPKPeer*)peer {
    if (peer != nil && peer.discoveryInfo != nil) {
        NSString *token = [[NSString alloc] initWithData:peer.discoveryInfo encoding:NSUTF8StringEncoding];
        if (token != nil && self.peerDiscoveredCallback != nil) {
            self.peerDiscoveredCallback(token);
        }
    }
}

-(void)peerLost:(PPKPeer*)peer {
    if (peer != nil && peer.discoveryInfo != nil) {
        NSString *token = [[NSString alloc] initWithData:peer.discoveryInfo encoding:NSUTF8StringEncoding];
        if (token != nil && self.peerDiscoveredCallback != nil) {
            self.peerLostCallback(token);
        }
    }
}

-(void)discoveryInfoUpdatedForPeer:(PPKPeer*)peer {
//    [self changeTokenIfNeeded];
}

-(void)proximityStrengthChangedForPeer:(PPKPeer*)peer {
    
}

-(void)discoveryStateChanged:(PPKDiscoveryState)state {
    
    if (state == PPKDiscoveryStateStopped) {
        
    }
    else if (state == PPKDiscoveryStateUnauthorized) {
        NSLog(@"p2pkit cannot run because it is missing a user permission");
    }
    else if (state == PPKDiscoveryStateUnsupported) {
        NSLog(@"p2pkit is not supported on this device");
    }
}

@end
