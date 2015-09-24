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

@end
