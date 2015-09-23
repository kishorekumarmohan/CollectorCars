//
//  KKMCollectorCarsRequest.h
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/21/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKMCollectorCarsRequest : NSObject

@property (nonatomic, assign) NSInteger minPrice;
@property (nonatomic, assign) NSInteger maxPrice;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@property (nonatomic, assign) NSInteger categoryID;

@property (nonatomic, strong) NSString *keywords;

@end
