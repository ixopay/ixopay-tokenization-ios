//
//  Error.m
//
//  Copyright © 2019 IXOPAY GmbH. All rights reserved.
//

#import "Error.h"

@implementation Error

- (instancetype)initWithField:(NSString *)field Message:(NSString *)message Code:(NSString *)code {
    self = [super init];
    
    self.field = field;
    self.message = message;
    self.code = code;
    
    return self;
}

@end
