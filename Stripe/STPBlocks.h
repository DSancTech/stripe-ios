//
//  STPBlocks.h
//  Stripe
//
//  Created by Jack Flintermann on 3/23/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPSource.h"

typedef NS_ENUM(NSUInteger, STPPaymentStatus) {
    STPPaymentStatusSuccess,
    STPPaymentStatusError,
    STPPaymentStatusUserCancellation,
};

typedef void (^STPVoidBlock)();
typedef void (^STPErrorBlock)(NSError * __nullable error);
