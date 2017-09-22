//
//  ICCookie.m
//  Pods
//
//  Created by 李翔宇 on 16/8/17.
//

#import "ICCookie.h"
#import "ICCoding.h"
#import "ICModelManager.h"
#import "ICModelProtocol.h"

@implementation ICCookie

+ (ICCookie *)currentCookie {
    static ICCookie *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!(sharedInstance = [self readSingleton])) {
            sharedInstance = [[super allocWithZone:NULL] init];
        }
        [ICModelManager observe:(id<ICModelProtocol>)sharedInstance keyPath:@"identifier", @"expiredTime", @"valid", @"unexpired", nil];
    });
    return sharedInstance;
}

ICCoding

#pragma mark- Protocol Method

@synthesize valid = _valid;

- (void)setValid:(BOOL)valid {
    if(_valid == valid) {
        return;
    }
    
    _valid = valid;
    
    if(!_valid) {
        [self reset];
    }
}

- (BOOL)isValid {
    //数据缺失情况下认为是不合法
    if (!self.identifier.length ||
        !self.expiredTime) {
        _valid = NO;
    }
    return _valid;
}

@synthesize unexpired = _unexpired;

- (BOOL)isUnexpired {
    if (self.expiredTime < [NSDate date].timeIntervalSince1970) {
        _unexpired = NO;
    }
    return _unexpired;
}

@end
