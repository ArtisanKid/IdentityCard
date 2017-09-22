//
//  ICViewController.m
//  IdentityCard
//
//  Created by freud on 09/19/2017.
//  Copyright (c) 2017 freud. All rights reserved.
//

#import "ICViewController.h"

@import IdentityCard;

@interface ICViewController ()<ICUserModifyProtocol>

@end

@implementation ICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [ICUser.currentUser addObserver:self forKeyPath:@"logined", nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for(NSUInteger i = 0; i < 10000; i++) {
            ICUser.currentUser.userID = [NSString stringWithFormat:@"%@", @(i)];
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for(NSUInteger i = 0; i < 10000; i++) {
            ICCookie.currentCookie.identifier = [NSString stringWithFormat:@"%@", @(i)];
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for(NSUInteger i = 0; i < 10000; i++) {
            ICToken.currentToken.accessToken = [NSString stringWithFormat:@"%@", @(i)];
        }
    });
}

- (void)ICUserModified:(ICUser *)user {
    if(user.isLogined) {
        NSLog(@"登录");
    } else {
        NSLog(@"退出登录");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
