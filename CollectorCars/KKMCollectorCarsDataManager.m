//
//  KKMCollectorCarsDataManager.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/20/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsDataManager.h"
#import "KKMCollectorCarsRequest.h"

NSString *const KKMBaseUrlString = @"http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=KishoreK-d288-4f95-bb9f-884a571b018d&RESPONSE-DATA-FORMAT=JSON";

@interface KKMCollectorCarsDataManager ()

@property (nonatomic, strong) KKMCollectorCarsRequest *request;
@end

@implementation KKMCollectorCarsDataManager

- (void)fetchData
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:KKMBaseUrlString];
    if (self.request.minPrice > 0 || self.request.maxPrice > 0)
    {
        [urlString stringByAppendingString:@"&itemFilter(0).name="];
        [urlString stringByAppendingString:@"MaxPrice"];
        [urlString stringByAppendingString:@"&itemFilter(0).value="];

        if (self.request.minPrice > 0)
            [urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.request.minPrice]];
        else
            [urlString stringByAppendingString:@"0"];

        [urlString stringByAppendingString:@"&itemFilter(0).paramName=Currency"];
        [urlString stringByAppendingString:@"&itemFilter(0).paramValue=USD"];
        [urlString stringByAppendingString:@"&itemFilter(1).name="];
        [urlString stringByAppendingString:@"MinPrice"];
        [urlString stringByAppendingString:@"&itemFilter(1).value="];

        if (self.request.maxPrice > 0)
            [urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.request.maxPrice]];
        else
            [urlString stringByAppendingString:@"10000000"];
        
        [urlString stringByAppendingString:@"&itemFilter(1).paramName=Currency"];
        [urlString stringByAppendingString:@"&itemFilter(1).paramValue=USD"];
    }
    
    if (self.request.minYear > 0 || self.request.maxYear > 0)
    {
        [urlString stringByAppendingString:@"&aspectFilter.aspectName=Model%20Year"];
        [urlString stringByAppendingString:@"&aspectFilter.aspectValueName="];
        if (self.request.minYear <=0 )
            self.request.minYear = 1986;

        NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];

        if (self.request.maxYear <=0 )
            self.request.maxYear = year;
        
        if (self.request.minYear > 0 && self.request.maxYear > 0)
        {
            for (NSInteger j = self.request.minYear; j < self.request.maxYear; j++)
            {
                [urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)j]];
            }
        }
    }
    [urlString stringByAppendingString:@"&paginationInput.entriesPerPage="];
    [urlString stringByAppendingString:@"10"];
    [urlString stringByAppendingString:@"&categoryId="];
    [urlString stringByAppendingString:@"6001"];
    [urlString stringByAppendingString:@"keywords"];
    [urlString stringByAppendingString:@"shelby"];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // ...
                                  }];
    
    [task resume];
}


@end

//http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=KishoreK-d288-4f95-bb9f-884a571b018d&RESPONSE-DATA-FORMAT=JSON&itemFilter(0).name=MaxPrice&itemFilter(0).value=100000&itemFilter(0).paramName=Currency&itemFilter(0).paramValue=USD&itemFilter(1).name=MinPrice&itemFilter(1).value=50000&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD&aspectFilter.aspectName=Model%20Year&aspectFilter.aspectValueName=2015%7C2014&paginationInput.entriesPerPage=2&categoryId=6001&keywords=shelby