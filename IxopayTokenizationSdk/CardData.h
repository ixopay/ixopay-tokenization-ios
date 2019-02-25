//
//  CardData.h
//
//  Copyright © 2019 IXOPAY GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardData : NSObject

@property (strong, nonatomic) NSString* pan;
@property (strong, nonatomic) NSString* cvv;
@property (strong, nonatomic) NSString* cardHolder;
@property (strong, nonatomic) NSNumber* expirationMonth;
@property (strong, nonatomic) NSNumber* expirationYear;


@end
