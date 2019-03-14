//
//  IxopayApi.h
//
//  Copyright © 2019 IXOPAY GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardData.h"
#import "Token.h"

typedef void (^IxopayLoggerFunc) (NSString* logMsg);
typedef enum {
    IxopayInvalidPublicIntegrationKey = -401,
    IxopayRequestFailed = -500,
    IxopayValueValidationFailed = 1002,
    IxopayTokenizationNotSupported = 3002
} IxopayErrorCode;

@interface TokenizationApi : NSObject

@property (strong, nonatomic) NSString* gatewayHost;
@property (strong, nonatomic) NSString* tokenizationHost;
@property (strong, nonatomic) NSString* publicIntegrationKey;
@property (strong, nonatomic) IxopayLoggerFunc loggerFunc;

- (instancetype)initWithPublicIntegrationKey:(NSString *)publicIntegrationKey;
- (instancetype)initWithGatewayHost:(NSString *)gatewayHost TokenizationHost:(NSString *)tokenizationHost AndPublicIntegrationKey:(NSString *)publicIntegrationKey;

- (void)tokenizeCardData:(CardData *)cardData onComplete:(void (^)(Token *token))completeHandler onError:(void(^)(NSError *))errorHandler;

@end
