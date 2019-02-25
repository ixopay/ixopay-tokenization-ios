//
//  IxopayApi.h
//  IxopayDemo
//
//  Created by Marco Dania on 25.02.19.
//  Copyright © 2019 Marco Dania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardData.h"
#import "Error.h"
#import "Token.h"

@interface IxopayApi : NSObject

@property (strong, nonatomic) NSString* host;
@property (strong, nonatomic) NSString* publicIntegrationKey;

- (instancetype)initWithPublicIntegrationKey:(NSString *)publicIntegrationKey;
- (instancetype)initWithHost:(NSString *)host AndPublicIntegrationKey:(NSString *)publicIntegrationKey;

- (void)tokenizeCardData:(CardData *)cardData onComplete:(void (^)(Token *token))completeHandler onError:(void(^)(NSArray<Error*> *errors))errorHandler;

@end
