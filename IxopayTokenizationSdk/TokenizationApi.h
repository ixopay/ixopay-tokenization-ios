//
//  IxopayApi.h
//
//  Copyright © 2019 IXOPAY GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardData.h"
#import "Error.h"
#import "Token.h"

@interface TokenizationApi : NSObject

@property (strong, nonatomic) NSString* gatewayHost;
@property (strong, nonatomic) NSString* tokenizationHost;
@property (strong, nonatomic) NSString* publicIntegrationKey;

- (instancetype)initWithPublicIntegrationKey:(NSString *)publicIntegrationKey;
- (instancetype)initWithGatewayHost:(NSString *)gatewayHost TokenizationHost:(NSString *)tokenizationHost AndPublicIntegrationKey:(NSString *)publicIntegrationKey;

- (void)tokenizeCardData:(CardData *)cardData onComplete:(void (^)(Token *token))completeHandler onError:(void(^)(NSArray<Error*> *errors))errorHandler;

@end
