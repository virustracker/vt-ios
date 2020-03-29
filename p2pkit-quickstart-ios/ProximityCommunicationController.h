//
//  ProximityCommunicationController.h
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProximityCommunicationController : NSObject

@property (copy) void (^peerDiscoveredCallback)(NSString *token);
@property (copy) void (^peerLostCallback)(NSString *token);

- (void)configure;
- (void)startOrUpdateWithToken:(NSString *)token;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
