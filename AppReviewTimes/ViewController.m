//
//  ViewController.m
//  AppReviewTimes
//
//  Created by Shubham Sorte on 28/02/16.
//  Copyright © 2016 Shubham Sorte. All rights reserved.
//

#define URL @"https://api.import.io/store/connector/4ccbc290-ceb0-4e4c-86e4-caa858dba55b/_query?input=webpage/url:http%3A%2F%2Fappreviewtimes.com%2F&&_apikey=7ae5ea39381a4abc8f346e73d51883cb45a505d6dbd54af0fa28b4fee27b94a87acc55b2e7af1dd0b5946bf72cb2d3a185e6f8a697768800bc02de32179326691b2f8819d571cdeb04b1145a6189b6ca"

#import "ViewController.h"
#import "Reachability.h"

@interface ViewController ()
@property NSArray * resultsArray;
@property (strong, nonatomic) UIView *gradientView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
		
	CGRect barRect = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	
	self.gradientView = [[UIView alloc] initWithFrame:barRect];
	
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	NSArray *colors = @[(id)[[UIColor colorWithRed:(51/255.f) green:(102/255.f) blue:(153/255.f) alpha:1] CGColor],
						(id)[[UIColor colorWithRed:(0/255.f) green:(51/255.f) blue:(102/255.f) alpha:1] CGColor]];
	[gradientLayer setColors:colors];
	[gradientLayer setFrame:[self.gradientView frame]];
	
	[[self.gradientView layer] addSublayer:gradientLayer];
	[self.view insertSubview:self.gradientView atIndex:0];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _iosReviewDaysLabel.alpha = 0;
    _macReviewDaysLabel.alpha = 0;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.isReachable) {
        [_iosStoreActivityIndicator startAnimating];
        [_macStoreActivityIndicator startAnimating];
        [self sendRequest];
    }
    else {
        [_iosStoreActivityIndicator removeFromSuperview];
        [_macStoreActivityIndicator removeFromSuperview];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"An active internet connection is required to get the latest data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
						[_iosStoreActivityIndicator stopAnimating];
						[_macStoreActivityIndicator stopAnimating];
						[_iosStoreActivityIndicator removeFromSuperview];
						[_macStoreActivityIndicator removeFromSuperview];
						_iosStoreMainLabel.text = [[_resultsArray objectAtIndex:0] objectForKey:@"data"];
						_macStoreMainLabel.text = [[_resultsArray objectAtIndex:1] objectForKey:@"data"];
						_iosReviewDaysLabel.text = [[_resultsArray objectAtIndex:0] objectForKey:@"data_time/_text"];
						_macReviewDaysLabel.text = [[_resultsArray objectAtIndex:1] objectForKey:@"data_time/_text"];
						_iosReviewDaysLabel.alpha = 1;
						_macReviewDaysLabel.alpha = 1;
					});
                }
	}] resume];
}

#pragma mark - Helper Methods
- (IBAction)openShinyDevelopmentWebpage:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://shinydevelopment.com"]];
    
}

@end
