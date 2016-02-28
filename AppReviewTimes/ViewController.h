//
//  ViewController.h
//  AppReviewTimes
//
//  Created by Shubham Sorte on 28/02/16.
//  Copyright © 2016 Shubham Sorte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)openShinyDevelopmentWebpage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *iosStoreMainLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *iosStoreActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *macStoreMainLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *macStoreActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *iosReviewDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *macReviewDaysLabel;

@end

