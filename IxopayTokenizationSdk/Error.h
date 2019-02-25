//
//  Error.h
//  IxopayDemo
//
//  Created by Marco Dania on 25.02.19.
//  Copyright © 2019 Marco Dania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property (strong, nonatomic) NSString *field;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *code;

- (instancetype)initWithField:(NSString*)field Message:(NSString *)message Code:(NSString* )code;

@end
