//
//  UserSettings.m
//  Virus Tracker
//
//  Created by admin on 30/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

- (NSDictionary *)getDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@(self.shouldSyncData) forKey:@"should_share_data"];
    [dictionary setObject:@(self.isMarkedAsInfected) forKey:@"is_marked_as_infected"];
    [dictionary setObject:@(self.didFinishOnboarding) forKey:@"did_finish_onboarding"];
    return dictionary;
}

- (void)setWith:(NSDictionary *)dictionary {
    if (dictionary) {
        if ([dictionary objectForKey:@"should_share_data"]) {
            self.shouldSyncData = [dictionary[@"should_share_data"] boolValue];
        }
        if ([dictionary objectForKey:@"is_marked_as_infected"]) {
            self.isMarkedAsInfected = [dictionary[@"is_marked_as_infected"] boolValue];
        }
        if ([dictionary objectForKey:@"did_finish_onboarding"]) {
            self.didFinishOnboarding = [dictionary[@"did_finish_onboarding"] boolValue];
        }
    }
}

@end
