//
//  KKMCollectorCarsHomeScreenViewController.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/12/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsHomeScreenViewController.h"
#import "KKMCollectorCarsVehicleInfo.h"
#import "KKMCollectorCarsDataManager.h"

@interface KKMCollectorCarsHomeScreenViewController () <KKMCollectorCarsDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) NSArray *vehicleInfoArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) KKMCollectorCarsDataManager *dataManager;


@end

@implementation KKMCollectorCarsHomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp
{
    [self.activityIndicatorView startAnimating];
    [self fetchData];
}

- (void)fetchData
{
    if (self.dataManager == nil)
    {
        self.dataManager = [KKMCollectorCarsDataManager new];
        self.dataManager.dataManagerDelegate = self;
    }
    
    [self.dataManager fetchData];
}


- (IBAction)tap:(id)sender
{
    NSLog(@"Here tapped");
}

- (IBAction)swipe:(id)sender
{
    self.activityIndicatorView.hidden = NO;

    UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)sender;
    if(swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft)
        self.currentIndex++;
    else if(swipeGesture.direction == UISwipeGestureRecognizerDirectionRight)
        self.currentIndex--;
    
    if(self.currentIndex < 0)
        self.currentIndex = self.vehicleInfoArray.count - 1;

    if (self.currentIndex >= self.vehicleInfoArray.count)
        self.currentIndex = self.currentIndex % self.vehicleInfoArray.count;
    
    [self setUpData];
}

- (void)setUpData
{
    KKMCollectorCarsVehicleInfo *vehicleInfo = self.vehicleInfoArray[self.currentIndex];
    self.titleLabel.text = vehicleInfo.title;
    self.priceLabel.text = vehicleInfo.price;
    NSLog(@"%@", vehicleInfo);
    [self loadImage:[NSURL URLWithString: vehicleInfo.imageURLs[0]]];
}

- (void)loadImage:(NSURL *)imageURL
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(requestRemoteImage:)
                                        object:imageURL];
    [queue addOperation:operation];
}

- (void)requestRemoteImage:(NSURL *)imageURL
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(placeImageInUI:) withObject:image waitUntilDone:YES];
}

- (void)placeImageInUI:(UIImage *)image
{
    self.imageView.image = image;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - KKMCollectorCarsDataManagerDelegate
- (void)dataFetchComplete:(NSArray *)vehicleInfoArray
{
    self.vehicleInfoArray = vehicleInfoArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUpData];
    });

}

@end
