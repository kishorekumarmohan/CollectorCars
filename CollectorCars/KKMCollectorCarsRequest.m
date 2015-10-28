//
//  KKMCollectorCarsRequest.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/21/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsRequest.h"

@implementation KKMCollectorCarsRequest

- (NSInteger)pageNumber
{
    if (_pageNumber == 0)
        _pageNumber = 1;

    return _pageNumber;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"minPrice: %ld; maxPrice: %ld; minYear: %ld; maxYear: %ld; categoryId: %ld; keywords %@; pageNumber: %ld;", (long)self.minPrice, (long)self.maxPrice, (long)self.minYear, (long)self.maxYear, (long)self.categoryID, self.keywords, (long)self.pageNumber];
    return desc;
}

@end
