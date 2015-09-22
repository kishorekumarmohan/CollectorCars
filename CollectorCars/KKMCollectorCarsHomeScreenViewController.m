//
//  KKMCollectorCarsHomeScreenViewController.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/12/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsHomeScreenViewController.h"
#import "KKMCollectorCarsVehicleInfo.h"

@interface KKMCollectorCarsHomeScreenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) NSMutableArray *vehicleInfoArray;
@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation KKMCollectorCarsHomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vehicleInfoArray = [NSMutableArray new];
    
    KKMCollectorCarsVehicleInfo *vehicleInfo1 = [[KKMCollectorCarsVehicleInfo alloc] init];
    vehicleInfo1.title = @"2014 BMW X4";
    vehicleInfo1.price = @"$90,000";
    vehicleInfo1.imageUrls = @[@"http://globe-views.com/dcim/dreams/car/car-03.jpg"];

    KKMCollectorCarsVehicleInfo *vehicleInfo2 = [[KKMCollectorCarsVehicleInfo alloc] init];
    vehicleInfo2.title = @"2016 Shelby 427 cobra";
    vehicleInfo2.price = @"$15,000,000";
    vehicleInfo2.imageUrls = @[@"http://globe-views.com/dcim/dreams/car/car-02.jpg"];

    KKMCollectorCarsVehicleInfo *vehicleInfo3 = [[KKMCollectorCarsVehicleInfo alloc] init];
    vehicleInfo3.title = @"2016 Ford Mustang";
    vehicleInfo3.price = @"$94,000";
    vehicleInfo3.imageUrls = @[@"http://globe-views.com/dcim/dreams/car/car-02.jpg"];

    [self.vehicleInfoArray addObject:vehicleInfo1];
    [self.vehicleInfoArray addObject:vehicleInfo2];
    [self.vehicleInfoArray addObject:vehicleInfo3];
}

- (IBAction)tap:(id)sender
{
    NSLog(@"Here tapped");
}

- (IBAction)swipe:(id)sender
{
    UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)sender;
    if(swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"Left");
        self.currentIndex++;
    }
    else if(swipeGesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Right");
        self.currentIndex--;
    }
    
    if(self.currentIndex < 0)
        self.currentIndex = self.vehicleInfoArray.count - 1;

    if (self.currentIndex >= self.vehicleInfoArray.count)
        self.currentIndex = self.currentIndex % self.vehicleInfoArray.count;
    
    KKMCollectorCarsVehicleInfo *vehicleInfo = self.vehicleInfoArray[self.currentIndex];
    self.titleLabel.text = vehicleInfo.title;
    self.priceLabel.text = vehicleInfo.price;
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:vehicleInfo.imageUrls[0]]]];

}


@end
