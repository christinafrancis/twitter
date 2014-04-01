//
//  CFViewController.m
//  twitter
//
//  Created by Christina Francis on 11/11/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "CFViewController.h"
#import "CFAppDelegate.h"

@interface CFViewController ()

@end

@implementation CFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.octa_labels =[[NSArray alloc] init];
    self.metro_labels =[[NSArray alloc] init];
    self.octa_imgs =[[NSArray alloc] init];
    self.metro_imgs =[[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)post:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Post a tweet to verify login before continuing: Setting simulator to twitter account for 1st time: Press cancel to avoid posting!"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
	// Do any additional setup after loading the view, typically from a nib.
    [self getInfo_octa];
    [self getInfo_metro];
      NSLog(@"%@ is octa label",self.octa_labels);
    self.octa_tweets.delegate = self;
    self.octa_tweets.dataSource = self;
    [self.octa_tweets reloadData];
    NSLog(@"%@ is octa label",self.octa_labels);
    self.metro_tweets.delegate = self;
    self.metro_tweets.dataSource = self;
    [self.metro_tweets reloadData];
    

}

- (void) getInfo_octa
{
    // Request access to the Twitter accounts
    NSArray* outside = [[NSArray alloc] init];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
                NSDictionary *params = @{@"count": @"5" ,@"screen_name" : @"OCTABusUpdates" };
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                // Creating a request to get the info about a user on Twitter
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"] parameters:params];
                [twitterInfoRequest setAccount:twitterAccount];
                // Making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        // Check if there was an error
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        // Check if there is some response data
                        if (responseData) {
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                            // Filter the preferred data
                           
                            for (NSDictionary *td in TWData){
                        self.octa_labels=[self.octa_labels arrayByAddingObject:[td objectForKey:@"text"]];
                                NSString* profileImageStringURL =  [[td objectForKey:@"user"] objectForKey:@"profile_image_url_https"];
                                //NSLog(@"%@ is a profile_image_url_https",[td objectForKey:@"user"] );
                               profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                //NSLog(@"%@ is a profile_image_url_https",profileImageStringURL);
                                self.octa_imgs = [self.octa_imgs arrayByAddingObject:profileImageStringURL];
                            }
                            [self.octa_tweets reloadData];
                           //NSLog(@"%@ is a tweet",self.octa_labels);
                        }
                    });
                }];
            }
              NSLog(@"%@ is octa label",outside);
        } else {
            NSLog(@"No access granted");
        }
    }];
      NSLog(@"%@ is octa label",self.octa_labels);
}


- (void) getInfo_metro
{
    // Request access to the Twitter accounts
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
                NSDictionary *params = @{@"count": @"5" ,@"screen_name" : @"Metrolink" };
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                // Creating a request to get the info about a user on Twitter
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"] parameters:params];
                [twitterInfoRequest setAccount:twitterAccount];
                // Making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        // Check if there was an error
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        // Check if there is some response data
                        if (responseData) {
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                            // Filter the preferred data
                            
                            for (NSDictionary *td in TWData){
                                self.metro_labels=[self.metro_labels arrayByAddingObject:[td objectForKey:@"text"]];
                                NSString* profileImageStringURL =  [[td objectForKey:@"user"] objectForKey:@"profile_image_url"];
                                profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                self.metro_imgs = [self.metro_imgs arrayByAddingObject:profileImageStringURL];
                                
                            }
                            [self.metro_tweets reloadData];
                            //NSLog(@"%@ is a tweet",self.octa_labels);
                        }
                    });
                }];
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
}




#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.octa_tweets) {
        
        return [self.octa_labels count];
    }
    else{
        return [self.metro_labels count];
    }
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    if (tableView == self.octa_tweets)
        return @"OCTA TWEETS";
    else 
        return @"METROLINK TWEETS";
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* label;
    NSString* img;
    
    static NSString *MyIdentifier = @"MyCellIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    
    if (tableView == self.octa_tweets){
        
            
            label = [self.octa_labels objectAtIndex:indexPath.row] ;
            img = [self.octa_imgs objectAtIndex:indexPath.row] ;
            cell.textLabel.text=label;
        NSURL *url = [NSURL URLWithString:img];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [[cell imageView] setImage:[UIImage imageWithData:data]];
       
    }
    else{ 
            label = [self.metro_labels objectAtIndex:indexPath.row] ;
        img = [self.metro_imgs objectAtIndex:indexPath.row] ;
        cell.textLabel.text=label;
        NSURL *url = [NSURL URLWithString:img];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [[cell imageView] setImage:[UIImage imageWithData:data]];
    }
    
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
     NSLog(@"prepareForSegue inside:");
     //DetailViewController *dvc = [[DetailViewController alloc] init];
     // ...
    [dvc viewDidLoad];
    NSString* img = [self.octa_imgs objectAtIndex:indexPath.row] ;
    dvc.tv_tweet.text = [self.octa_labels objectAtIndex:indexPath.row] ;
    
    NSURL *url = [NSURL URLWithString:img];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [dvc.img_prof setImage:[UIImage imageWithData:data]];
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:dvc animated:YES];
      [dvc viewDidLoad];
    self.row = indexPath.row;
   // NSLog(@"prepareForSegue: %ld", (long)self.row);
   // [self performSegueWithIdentifier:@"octa_detail" sender:self.octa_tweets];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %ld", (long)self.row);
    
    NSLog(@"prepareForSegue inside:");
    if ([segue.identifier isEqualToString:@"octa_detail"]){
        DetailViewController *dvc= segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.octa_tweets indexPathForSelectedRow];
       // self.row = indexPath.row;
        NSString* img = [self.octa_tweets. objectAtIndex:indexPath.row];
        NSLog(@"prepareForSegue: %ld", (long)indexPath.row);
        
        dvc.tv_tweet.text = [self.octa_labels objectAtIndex:indexPath.row] ;
        NSLog(@"prepareForSegue: %@", dvc.tv_tweet.text);
        NSURL *url = [NSURL URLWithString:img];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [dvc.img_prof setImage:[UIImage imageWithData:data]];
    }
    
    if ([segue.identifier isEqualToString:@"metro_detail"]){
        DetailViewController *dvc= segue.destinationViewController;
        NSIndexPath *indexPath = [self.metro_tweets indexPathForSelectedRow];
        NSString* img = [self.metro_imgs objectAtIndex:indexPath.row] ;
        dvc.tv_tweet.text = [self.metro_labels objectAtIndex:indexPath.row] ;
        
        NSURL *url = [NSURL URLWithString:img];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [dvc.img_prof setImage:[UIImage imageWithData:data]];
    }
}

*/
@end
