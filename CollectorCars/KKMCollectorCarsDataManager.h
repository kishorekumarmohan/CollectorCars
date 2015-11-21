//
//  KKMCollectorCarsDataManager.h
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/20/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKMCollectorCarsRequest;

extern NSString *const KKMCollectorCarEntriesPerPage;

@protocol KKMCollectorCarsDataManagerDelegate <NSObject>

- (void)dataFetchComplete:(NSArray *)vehicleInfoArray;

@end


@interface KKMCollectorCarsDataManager : NSObject

@property (nonatomic, weak) id<KKMCollectorCarsDataManagerDelegate> dataManagerDelegate;

- (void)fetchDataWithRequest:(KKMCollectorCarsRequest *)request;

@end
