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

@interface KKMCollectorCarsHomeScreenViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, KKMCollectorCarsDataManagerDelegate>

@property (nonatomic, strong) NSArray *vehicleInfoArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) KKMCollectorCarsDataManager *dataManager;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation KKMCollectorCarsHomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupData];
}

- (void)setup
{
    self.pageNumber = 1;
}

- (void)setupData
{
    if (self.dataManager == nil)
        self.dataManager = [[KKMCollectorCarsDataManager alloc] init];
 
    self.dataManager.dataManagerDelegate = self;
    [self.dataManager fetchDataForPageNumber:self.pageNumber];
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

    KKMCollectorCarsVehicleInfo *vehicleInfo = self.vehicleInfoArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:vehicleInfo.imageURLs[0]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
