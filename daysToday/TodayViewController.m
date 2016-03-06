//
//  TodayViewController.m
//  daysToday
//
//  Created by Shubham Sorte on 28/02/16.
//  Copyright © 2016 Shubham Sorte. All rights reserved.
//
#define URL @"https://api.import.io/store/connector/4ccbc290-ceb0-4e4c-86e4-caa858dba55b/_query?input=webpage/url:http%3A%2F%2Fappreviewtimes.com%2F&&_apikey=7ae5ea39381a4abc8f346e73d51883cb45a505d6dbd54af0fa28b4fee27b94a87acc55b2e7af1dd0b5946bf72cb2d3a185e6f8a697768800bc02de32179326691b2f8819d571cdeb04b1145a6189b6ca"

//#import "Reachability.h"
#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property NSArray * resultsArray;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 44);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    if (reachability.isReachable) {
        [self sendRequest];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    return UIEdgeInsetsMake(2, 40, 8, 40);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}


#pragma mark Fetching New Data

- (void)sendRequest {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                @try {
                    if (data) {
                        NSLog(@"DATA IS %@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                        _resultsArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:@"results"];
                    }
                }
                @catch (NSException *exception){
                    
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _iosReviewDaysLabel.text = [[_resultsArray objectAtIndex:0] objectForKey:@"data"];
                        _macReviewDaysLabel.text = [[_resultsArray objectAtIndex:1] objectForKey:@"data"];
                    });
                }
            }] resume];
}

@end
