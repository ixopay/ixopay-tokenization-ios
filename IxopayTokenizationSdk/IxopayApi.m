//
//  IxopayApi.m
//
//  Copyright © 2019 IXOPAY GmbH. All rights reserved.
//

#import "IxopayApi.h"
#import "Token.h"

@implementation IxopayApi

- (instancetype)init {
    self = [super init];
    self.host = @"https://gateway.ixopay.com";
    return self;
}

- (instancetype)initWithPublicIntegrationKey:(NSString *)publicIntegrationKey {
    self = [self init];
    self.publicIntegrationKey = publicIntegrationKey;
    return self;
}

/**
 host format: @"https://gateway.ixopay.com" (for Production) resp. @"https://sandbox.ixopay.com" (for Sandbox Environment)
 */
- (instancetype)initWithHost:(NSString *)host AndPublicIntegrationKey:(NSString *)publicIntegrationKey {
    self = [super init];
    
    //prepend https if not defined
    if (![[host substringToIndex:5] isEqualToString:@"http"])  {
        host = [@"https://" stringByAppendingString:host];
    }
    self.host = host;
    self.publicIntegrationKey = publicIntegrationKey;
    
    return self;
}


- (void)tokenizeCardData:(CardData *)cardData onComplete:(void (^)(Token *token))completeHandler onError:(void(^)(NSArray<Error*> *errors))errorHandler {
    
    //get tokenization endpoint
    [self getTokenizationUrl:^(NSString *tokenizationUrl) {
        //tokenize card
        NSMutableArray *queryItems = [NSMutableArray array];

        //Build Request Data
        if (cardData.cvv && ![cardData.cvv isEqualToString:@""]) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pan" value:cardData.pan]];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"cvv" value:cardData.cvv]];
        } else {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"panonly" value:cardData.pan]];
        }

        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"cardHolder" value:cardData.cardHolder]];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"month" value:cardData.expirationMonth.stringValue]];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"year" value:cardData.expirationYear.stringValue]];
        
        NSURLComponents *urlComp = [NSURLComponents componentsWithString:tokenizationUrl];
        [urlComp setQueryItems:queryItems];
        
        //NSLog(@"Sending request to %@", urlComp.URL.absoluteString);
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:urlComp.URL];
        [req setHTTPMethod:@"POST"];
        
        //Send Request
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            //NSLog(@"Token response: %@", json);
            
            //Error handling first
            NSError *e = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            
            if (!result) {
                NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:@"Unexpected response" Code:@"REQUEST_ERROR"], nil];
                errorHandler(errors);
                return;
            }
            
            if (![[result objectForKey:@"success"] isKindOfClass:[NSNumber class]]) {
                NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:@"Unexpected response" Code:@"REQUEST_ERROR"], nil];
                errorHandler(errors);
                return;
            }
            NSNumber *status = [result objectForKey:@"success"];
            if ([status boolValue] == false) {
                NSMutableArray *errors = [NSMutableArray array];
                
                NSDictionary *jsonErrors = [result objectForKey:@"errors"];
                                       
                [jsonErrors enumerateKeysAndObjectsWithOptions:0 usingBlock:^(NSString*  _Nonnull field, NSArray*  _Nonnull fieldErrors, BOOL * _Nonnull stop) {
                    [fieldErrors enumerateObjectsUsingBlock:^(NSString*  _Nonnull fieldError, NSUInteger idx, BOOL * _Nonnull stop) {
                        Error *err = [[Error alloc] initWithField:field Message:[NSString stringWithFormat:@"Field validation failed: %@ - %@", field, fieldError] Code:fieldError];
                        [errors addObject:err];
                    }];
                }];

                errorHandler([NSArray arrayWithArray:errors]);
                return;
            }
            
            //All good, build token object
            
            Token *token = [[Token alloc] init];
            
            token.token = [result objectForKey:@"token"];
            token.fingerprint = [result objectForKey:@"fingerprint"];
            
            completeHandler(token);
            
            return;
        }] resume];
        
    } onError:errorHandler];

}

- (void)getTokenizationUrl:(void (^)(NSString *tokenizationUrl))completeHandler onError:(void(^)(NSArray<Error*> *errors))errorHandler {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/integrated/tokenizationEndpoint/%@", self.host, self.publicIntegrationKey]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //NSLog(@"Sending request to %@", url.absoluteString);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //NSLog(@"Got some response");
        if (error) {
            NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:error.description Code:@"REQUEST_ERROR"], nil];
            errorHandler(errors);
            return;
        }
        //NSLog(@"No error");
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode == 401) {
                NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:@"Invalid public integration key" Code:@"INVALID_KEY"], nil];
                errorHandler(errors);
                return;
            } else if (statusCode != 200) {
                NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:@"Request failed" Code:@"REQUEST_ERROR"], nil];
                errorHandler(errors);
                return;
            }
        }
        
        //NSLog(@"Status 200");
        
        NSError *e = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        
        if (!json) {
            NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:@"Unexpected response" Code:@"REQUEST_ERROR"], nil];
            errorHandler(errors);
            return;
        }
        
        if (![[json objectForKey:@"success"] isKindOfClass:[NSNumber class]]) {
            NSArray *errors = [[NSArray alloc] initWithObjects:[[Error alloc] initWithField:nil Message:@"Unexpected response" Code:@"REQUEST_ERROR"], nil];
            errorHandler(errors);
            return;
        }
        NSNumber *status = [json objectForKey:@"success"];
        if ([status boolValue] == false) {
            Error *err = [[Error alloc] initWithField:[json objectForKey:@"field"] Message:[json objectForKey:@"error_message"] Code:[json objectForKey:@"error_code"]];
            NSArray *errors = [[NSArray alloc] initWithObjects:err, nil];
            errorHandler(errors);
            return;
        }
        
        //now we are fine
        NSString *tokenizationUrl = [json objectForKey:@"tokenizationUrl"];
        
        NSLog(@"Tokenize URL is: %@", tokenizationUrl);
        
        completeHandler(tokenizationUrl);
        return;
    }] resume];
}


@end
