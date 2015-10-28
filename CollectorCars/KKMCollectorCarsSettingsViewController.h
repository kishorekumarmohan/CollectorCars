//
//  KKMCollectorCarsSettingsViewController.h
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/11/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  KKMCollectorCarsHomeScreenViewController;
@class KKMCollectorCarsRequest;

@protocol KKMSaveButtonTappedDelegate;


@interface KKMCollectorCarsSettingsViewController : UITableViewController

@property (nonatomic, strong) KKMCollectorCarsRequest *request;
@property (nonatomic, weak) id<KKMSaveButtonTappedDelegate> saveButtonDelegate;

@end


@protocol KKMSaveButtonTappedDelegate <NSObject>

- (void)saveButtonTappedOnViewController:(KKMCollectorCarsSettingsViewController *)contoller withRequest:(KKMCollectorCarsRequest *)request;

@end

