//
//  KKMCollectorCarsHomeScreenViewController.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/12/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

@import WebImage;

#import "KKMCollectorCarsHomeScreenViewController.h"
#import "KKMCollectorCarsVehicleInfo.h"
#import "KKMCollectorCarsDataManager.h"
#import "KKMCollectorCarsCollectionViewCell.h"
#import <WebImage/UIImageView+WebCache.h>
#import "UIImage+AverageColor.h"
#import "KKMCollectorCarsSettingsViewController.h"
#import "KKMCollectorCarsRequest.h"

@interface KKMCollectorCarsHomeScreenViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, KKMCollectorCarsDataManagerDelegate, KKMSaveButtonTappedDelegate>

@property (nonatomic, strong) NSArray *vehicleInfoArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) KKMCollectorCarsDataManager *dataManager;
@property (nonatomic, strong) KKMCollectorCarsRequest *request;

@end

@implementation KKMCollectorCarsHomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    if (self.dataManager == nil)
        self.dataManager = [[KKMCollectorCarsDataManager alloc] init];
 
    self.dataManager.dataManagerDelegate = self;

    if (self.request == nil)
        self.request = [[KKMCollectorCarsRequest alloc] init];
    
    [self.dataManager fetchDataWithRequest:self.request];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"KKMCollectorCarsSettingsViewController"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        KKMCollectorCarsSettingsViewController *settingsVC = (KKMCollectorCarsSettingsViewController *)navigationController.topViewController;
        settingsVC.saveButtonDelegate = self;
        settingsVC.request = self.request;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vehicleInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    KKMCollectorCarsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        cell.activityIndicator.hidden = NO;
//        [cell.activityIndicator startAnimating];
//    });
    
    KKMCollectorCarsVehicleInfo *vehicleInfo = self.vehicleInfoArray[indexPath.row];
    cell.titleLabel.text = vehicleInfo.title;
    NSLog(@"%@", cell.titleLabel.text);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:vehicleInfo.imageURLs[0]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        cell.activityIndicator.hidden = YES;
//        [cell.activityIndicator stopAnimating];
//    });
    return cell;
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}



#pragma mark - KKMCollectorCarsDataManagerDelegate

- (void)dataFetchComplete:(NSArray *)vehicleInfoArray
{
    self.vehicleInfoArray = vehicleInfoArray;
    NSLog(@"%@", vehicleInfoArray);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}




#pragma mark - KKMSaveButtonTappedDelegate

- (void)saveButtonTappedOnViewController:(KKMCollectorCarsSettingsViewController *)contoller withRequest:(KKMCollectorCarsRequest *)request
{
    NSLog(@"%@", request);
    self.request = request;
    [self loadData];
}


@end
