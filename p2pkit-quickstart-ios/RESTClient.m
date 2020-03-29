//
//  RESTClientRequestManager.m
//  Kinofinder
//
//  Created by Artur Olszak on 15/03/16.
//  Copyright © 2016 bam! interactive marketing GmbH. All rights reserved.
//

#import "RESTClient.h"
#import "Reachability.h"
#import <CommonCrypto/CommonCrypto.h>

@interface RESTClient ()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) Reachability *networkReachability;

@end

@implementation RESTClient

static id singleton = nil;
static bool isFirstAccess = YES;
static const int kDefaultRequestTimeoutInterval = 25;

static NSString * const kAuthAuthKey = @"X-Auth";
static NSString * const kAuthHashKey = @"X-Hash";
static NSString * const kAuthTimeKey = @"X-Time";

#pragma mark - Setters / Getters

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeoutInterval = kDefaultRequestTimeoutInterval;
    }
    return  self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Setter / Getter

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (Reachability *)networkReachability {
    if (_networkReachability == nil) {
        _networkReachability = [Reachability reachabilityForInternetConnection];
        [_networkReachability startNotifier];
    }
    return _networkReachability;
}

#pragma mark - Public methods

- (void)sendGETRequestWithUrl:(NSString *)url andCompletion:(void (^)(RESTClientResponseStatus status, id obj))completion {
    
    // Return when no completion block
    if (completion == nil) {
        NSLog(@"Request completion block is nil");
        return;
    }
    
    // Check network availability
    if (![self isNetworkReachable]) {
        NSLog(@"Network not reachable");
        completion(RESTClientResponseStatusNetworkError, nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSLog(@"Request start with url %@", url);
    
    // Encode url
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // HMAC
    NSUInteger timestamp = [[NSDate date] timeIntervalSince1970];
    NSDictionary *postData = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:encodedUrl]];
    [request setValue:[@(YES) stringValue] forHTTPHeaderField:kAuthAuthKey];
    [request setValue:[@(timestamp) stringValue] forHTTPHeaderField:kAuthTimeKey];
    
    [self executePreparedRequest:request withCompletion:completion];
}


- (void)sendOAuthRequestWithRequest:(NSURLRequest *)request andCompletion:(void (^)(RESTClientResponseStatus status, id obj))completion {
    
    // Return when no completion block
    if (completion == nil) {
        NSLog(@"Request completion block is nil");
        return;
    }
    
    // Check network availability
    if (![self isNetworkReachable]) {
        NSLog(@"Network not reachable");
        completion(RESTClientResponseStatusNetworkError, nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSLog(@"Request start with url %@", request);
    
    [self executePreparedRequest:request withCompletion:completion];
    
}

- (void)sendPOSTRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters andCompletion:(void (^)(RESTClientResponseStatus, id))completion {
    
    // Return when no completion block
    if (completion == nil) {
        NSLog(@"Request completion block is nil");
        return;
    }
    
    // Check network availability
    if (![self isNetworkReachable]) {
        NSLog(@"Network not reachable");
        completion(RESTClientResponseStatusNetworkError, nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Make url parameters
    NSMutableArray *pairList = [NSMutableArray array];
    for (NSString *key in parameters) {
        NSString *pairString = [NSString stringWithFormat:@"%@=%@&", key, parameters[key]];
        [pairList addObject:pairString];
    }
    NSString *parameterString = [pairList componentsJoinedByString:@"&"];
    
    // Encode url
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"Request start with url %@", encodedUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if (parameters != nil) {
        [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        NSLog(@"Request POST parameter object invalid");
    }
    
    // HMAC
    NSUInteger timestamp = [[NSDate date] timeIntervalSince1970];
    
    [request setValue:[@(YES) stringValue] forHTTPHeaderField:kAuthAuthKey];
    [request setValue:[@(timestamp) stringValue] forHTTPHeaderField:kAuthTimeKey];
    
    [self executePreparedRequest:request withCompletion:completion];
}

- (void)executePreparedRequest:(NSURLRequest *)request withCompletion:(void (^)(RESTClientResponseStatus, id))completion {
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Response status code
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"Response status code: %d", (int)statusCode);
        
        // Handle network error
        if (error != nil && error.code == -1009) {
            
            NSLog(@"Response network error");
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(RESTClientResponseStatusNetworkError, nil);
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            return;
            
        }
        
        // Handle other errors
        if (error != nil || statusCode != 200) {
            
            NSLog(@"Response status not 200 (%@ %@)", request.HTTPMethod, request.URL.absoluteString);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(RESTClientResponseStatusResponseError, nil);
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            return;
            
        }
        
        // Use data for JSON serialization
        NSError *jsonError = nil;
        id responseObject = nil;
        if (data != nil) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        } else {
            NSLog(@"%@ - no response data", request.URL.absoluteString);
        }
        
        if (jsonError == nil) {
            NSLog(@"%@ - response object size: %lu", request.URL.absoluteString, (unsigned long)[responseObject count]);
        } else {
            NSLog(@"%@ - json unserialization error", request.URL.absoluteString);
            
            // If response data is not valid json then we pass raw object
            responseObject = data;
        }
        
        // Make sure to call callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(RESTClientResponseStatusSuccess, responseObject);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }];
    
    // Add timeout call when request last for too long
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.timeoutInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (dataTask.state != NSURLSessionTaskStateCompleted) {
            NSLog(@"Request task timeout");
            [dataTask cancel];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(RESTClientResponseStatusTimeout, nil);
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }
    });
    
    // Start task
    [dataTask resume];
}

- (BOOL)isNetworkReachable {
    NetworkStatus networkStatus = [self.networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

@end
