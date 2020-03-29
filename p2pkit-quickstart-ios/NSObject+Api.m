//
//  NSObject+Api.m
//  Kinofinder
//
//  Created by Artur Olszak on 09/04/17.
//  Copyright © 2017 bam! interactive marketing GmbH. All rights reserved.
//

#import "NSObject+Api.h"

@implementation NSObject (Api)

- (NSString *)jsonString {
    NSString *string = nil;
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:self options:0 error:&error];
        if (error == nil) {
            string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return string;
}

- (NSDictionary *)dictionaryFromJSONString {
    id obj = [self objectFromJSONString];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    } else {
        return nil;
    }
}

- (NSArray *)arrayFromJSONString {
    id obj = [self objectFromJSONString];
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    } else {
        return nil;
    }
}

- (id)objectFromJSONString {
    NSError *jsonError = nil;
    id responseObject = nil;
    if ([self isKindOfClass:[NSString class]]) {
        NSData *data = [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
        if (data != nil) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        }
    }
    return responseObject;
}

@end
