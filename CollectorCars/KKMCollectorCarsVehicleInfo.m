//
//  KKMCollectorCarsVehicleInfo.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/16/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsVehicleInfo.h"

@implementation KKMCollectorCarsVehicleInfo


- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"itemID: %@\r title: %@\r price: %@\r imageURLs: %@\r", self.itemID, self.title, self.price, self.imageURLs];
    return desc;
}

@end
