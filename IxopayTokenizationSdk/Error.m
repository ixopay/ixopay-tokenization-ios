//
//  Error.m
//  IxopayDemo
//
//  Created by Marco Dania on 25.02.19.
//  Copyright © 2019 Marco Dania. All rights reserved.
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
