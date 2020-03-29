//
//  VirusRESTClient.m
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import "VirusRESTClient.h"
#import "RESTClient.h"

@interface VirusRESTClient ()

@property RESTClient *restClient;

@end

@implementation VirusRESTClient

- (RESTClient *)getClient {
    if (_restClient == nil) {
        _restClient = [[RESTClient alloc] init];
    }
    return _restClient;
}

- (void)getInfectedTokenList:(void (^)(NSArray<RESTToken *> * _Nonnull))completion {
    RESTClient *client = [self getClient];
    [client sendGETRequestWithUrl:@"https://europe-west1-fabled-emissary-272419.cloudfunctions.net/vt-server-token" andCompletion:^(RESTClientResponseStatus status, id obj) {
        NSMutableArray *list = [NSMutableArray array];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tokenPack = (NSDictionary *)obj;
            if ([tokenPack objectForKey:@"tokens"]) {
                NSArray *tokenDictionaryList = tokenPack[@"tokens"];
                for (NSDictionary *tokenDictionary in tokenDictionaryList) {
                    if ([tokenDictionary objectForKey:@"type"] && [tokenDictionary objectForKey:@"value"]) {
                        RESTToken *token = [[RESTToken alloc] init];
                        token.value = tokenDictionary[@"value"];
                        token.type = [tokenDictionary[@"type"] isEqualToString:@"VERIFIED"] ? RESTTokenVerificationTypeVerifiedByInstitution : RESTTokenVerificationTypeSelfReport;
                        [list addObject:token];
                    }
                }
            }
        }
        if (completion != nil) {
            completion(list);
        }
    }];
}

@end
