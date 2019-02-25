//
//  Token.h
//
//  Copyright © 2019 IXOPAY GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *fingerprint;

@end
