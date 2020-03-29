//
//  NSObject+Api.h
//  Kinofinder
//
//  Created by Artur Olszak on 09/04/17.
//  Copyright © 2017 bam! interactive marketing GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Api)

/** */
- (NSString *)jsonString;

/** */
- (NSDictionary *)dictionaryFromJSONString;

/** */
- (NSArray *)arrayFromJSONString;

@end
