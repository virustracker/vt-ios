//
//  RESTClient.h
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief Custom HTTP Response status enumeration
 */
typedef NS_ENUM(NSUInteger, RESTClientResponseStatus) {
    RESTClientResponseStatusNetworkError,
    RESTClientResponseStatusTimeout,
    RESTClientResponseStatusResponseError,
    RESTClientResponseStatusSuccess
};

@interface RESTClient : NSObject

/**
 @brief Custom request timeout implementation (default value is 25s)
 */
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

/**
 @brief Singleton initialization method
 */
+ (instancetype)sharedInstance;

/**
 @brief HTTP GET request method
 @param url complete url including http prefix
 @param completion asynchronous completion block with response status and data
 */
- (void)sendGETRequestWithUrl:(NSString *)url andCompletion:(void(^)(RESTClientResponseStatus status, id obj))completion;

/**
 @brief HTTP POST request method
 @param url complete url including http prefix
 @param completion asynchronous completion block with response status and data
 */
- (void)sendPOSTRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters andCompletion:(void(^)(RESTClientResponseStatus status, id obj))completion;

/**
 @brief HTTP GET OAuth method
 @param request oauth request
 @param completion asynchronous completion block with response status and data
 */
- (void)sendOAuthRequestWithRequest:(NSURLRequest *)request andCompletion:(void (^)(RESTClientResponseStatus status, id obj))completion;

/**
 @brief check if netwekt is availeable
 */

- (BOOL)isNetworkReachable;

@end
