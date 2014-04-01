//
//  CFViewController.h
//  twitter
//
//  Created by Christina Francis on 11/11/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "DetailViewController.h"

@interface CFViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property ACAccountStore *accountStore;
@property ACAccount *account;
- (IBAction)post:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *octa_tweets;
@property (weak, nonatomic) IBOutlet UITableView *metro_tweets;
@property NSInteger row;
@property NSArray* octa_labels;

@property NSArray* metro_labels;

@property NSArray* octa_imgs;

@property NSArray* metro_imgs;

@end
