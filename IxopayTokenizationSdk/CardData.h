//
//  CardData.h
//  IxopayDemo
//
//  Created by Marco Dania on 25.02.19.
//  Copyright © 2019 Marco Dania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardData : NSObject

@property (strong, nonatomic) NSString* pan;
@property (strong, nonatomic) NSString* cvv;
@property (strong, nonatomic) NSString* cardHolder;
@property (strong, nonatomic) NSNumber* expirationMonth;
@property (strong, nonatomic) NSNumber* expirationYear;


@end
