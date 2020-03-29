//
//  ProximityEvent.m
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import "ProximityEvent.h"

@implementation ProximityEvent

- (NSDictionary *)getDisctionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@(self.distanceType) forKey:@"distance_type"];
    [dictionary setObject:@(self.timestampMs) forKey:@"timestamp"];
    [dictionary setObject:@(self.durationMs) forKey:@"duration"];
    [dictionary setObject:@(self.infectionState) forKey:@"infection_state"];
    [dictionary setObject:@(self.isConfidential) forKey:@"is_confidential"];
    return dictionary;
}

@end
