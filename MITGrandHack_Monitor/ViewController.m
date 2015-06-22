//
//  ViewController.m
//  MITGrandHack_Monitor
//
//  Created by Boris  on 4/26/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize heartRateLabel,stressLabel, postureLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [PFUser logInWithUsernameInBackground:@"bbanner" password:@"123"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self update];
                                            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
                                            
                                            NSLog(@"logged");
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}

- (void)update {
    
    NSLog(@"Updating...");
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Measures"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            stressLabel.text = [[objects objectAtIndex:0] objectForKey:@"stress"];
            postureLabel.text = [[objects objectAtIndex:0] objectForKey:@"posture"];
            heartRateLabel.text = [[objects objectAtIndex:0] objectForKey:@"heartRate"];
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
