//
//  KKMCollectorCarsDataManager.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/20/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsDataManager.h"
#import "KKMCollectorCarsRequest.h"
#import "KKMCollectorCarsVehicleInfo.h"

NSInteger const KKMCollectorCarEntriesPerPage = 5;

NSString *const KKMBaseUrlString = @"https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=KishoreK-d288-4f95-bb9f-884a571b018d&RESPONSE-DATA-FORMAT=JSON&outputSelector(0)=PictureURLSuperSize&outputSelector(1)=PictureURLLarge";

@interface KKMCollectorCarsDataManager ()

@property (nonatomic, strong) KKMCollectorCarsRequest *request;
@property (nonatomic, strong) NSMutableArray *vehicleInfoArray;

@end

@implementation KKMCollectorCarsDataManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _request = [KKMCollectorCarsRequest new];
        _vehicleInfoArray = [NSMutableArray new];
    }
    return self;
}

- (void)fetchDataForPageNumber:(NSInteger)pageNumber
{
    self.request.pageNumber = pageNumber;
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:KKMBaseUrlString];

    // page number
    urlString = [[urlString stringByAppendingString:@"&paginationInput.entriesPerPage="] mutableCopy];
    urlString = [[urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", KKMCollectorCarEntriesPerPage]] mutableCopy];
    
    urlString = [[urlString stringByAppendingString:@"&paginationInput.pageNumber="] mutableCopy];
    urlString = [[urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.request.pageNumber]] mutableCopy];
    
    // price
    urlString = [[urlString stringByAppendingString:@"&itemFilter(0).name=MinPrice&itemFilter(0).value="] mutableCopy];
    
    if (self.request.minPrice == 0 && self.request.maxPrice == 0)
        urlString = [[urlString stringByAppendingString:@"65000"] mutableCopy];
    else if (self.request.minPrice > 0)
        urlString = [[urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.request.minPrice]] mutableCopy];
    else
        urlString = [[urlString stringByAppendingString:@"0"] mutableCopy];
    
    
    urlString = [[urlString stringByAppendingString:@"&itemFilter(0).paramName=Currency&itemFilter(0).paramValue=USD&itemFilter(1).name=MaxPrice&itemFilter(1).value="] mutableCopy];
    
    if (self.request.maxPrice > 0)
        urlString = [[urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.request.maxPrice]] mutableCopy];
    else
        urlString = [[urlString stringByAppendingString:@"10000000"] mutableCopy];
    
    urlString = [[urlString stringByAppendingString:@"&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD"] mutableCopy];
    
    
    // year
    if (self.request.minYear > 0 || self.request.maxYear > 0)
    {
        urlString = [[urlString stringByAppendingString:@"&aspectFilter.aspectName=Model%20Year&aspectFilter.aspectValueName="] mutableCopy];
        
        NSInteger minYear;
        if (self.request.minYear <= 0)
            minYear = 1986;

        NSInteger maxYear;
        if (self.request.maxYear <= 0)
        {
            NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
            maxYear = year;
        }

        for (NSInteger j = minYear; j < maxYear; j++)
        {
            urlString = [[urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)j]] mutableCopy];
        }
    }
    
    urlString = [[urlString stringByAppendingString:@"&categoryId="] mutableCopy];
    urlString = [[urlString stringByAppendingString:@"6001"] mutableCopy];
    urlString = [[urlString stringByAppendingString:@"&keywords="] mutableCopy];
    urlString = [[urlString stringByAppendingString:@"shelby"] mutableCopy];
    
    NSLog(@"%@", urlString);
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data)
        {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *results = [self parseJSON:jsonDict];
            if (results)
                [self.vehicleInfoArray addObjectsFromArray:results];
        }
        
        [self.dataManagerDelegate dataFetchComplete:self.vehicleInfoArray];
    }];
    
    [task resume];
}

- (NSArray *)parseJSON:(NSDictionary *)jsonDict
{
    NSArray *itemsArray = jsonDict[@"findItemsAdvancedResponse"][0][@"searchResult"][0][@"item"];
    NSMutableArray *vehicleInfoArray = [NSMutableArray new];
    for (NSDictionary *itemDict in itemsArray)
    {
        KKMCollectorCarsVehicleInfo *vehicleInfo = [KKMCollectorCarsVehicleInfo new];
        vehicleInfo.itemID = itemDict[@"itemId"][0];
        vehicleInfo.title = itemDict[@"title"][0];
        vehicleInfo.price = itemDict[@"sellingStatus"][0][@"currentPrice"][0][@"__value__"];

        NSArray *imageURLs = itemDict[@"pictureURLSuperSize"];
        if (imageURLs.count > 0)
            vehicleInfo.imageURLs = imageURLs;
        else
            imageURLs = itemDict[@"pictureURLLarge"];
        
        if (imageURLs.count)
        {
            vehicleInfo.imageURLs = imageURLs;
            [vehicleInfoArray addObject:vehicleInfo];
        }
    }
    return vehicleInfoArray;
}

@end

//https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=KishoreK-d288-4f95-bb9f-884a571b018d&RESPONSE-DATA-FORMAT=JSON&itemFilter(0).name=MinPrice&itemFilter(0).value=0&itemFilter(0).paramName=Currency&itemFilter(0).paramValue=USD&itemFilter(1).name=MaxPrice&itemFilter(1).value=10000000&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD&paginationInput.entriesPerPage=10&categoryId=6001&keywords=shelby&outputSelector(0)=searchResult.item.pictureURLSuperSize