//
//  ICToken.m
//  Pods
//
//  Created by 李翔宇 on 16/6/12.
//

#import "ICToken.h"
#import "ICCoding.h"
#import "ICModelManager.h"
#import "ICModelProtocol.h"

@implementation ICToken

+ (ICToken *)currentToken {
    static ICToken *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!(sharedInstance = [self readSingleton])) {
            sharedInstance = [[super allocWithZone:NULL] init];
        }
        [ICModelManager observe:(id<ICModelProtocol>)self keyPath:@"accessToken", @"refreshToken", @"expiredTime", @"valid", @"unexpired", nil];
    });
    return sharedInstance;
}

ICCoding

#pragma mark- 协议方法
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
    if (!self.accessToken.length || 
        !self.refreshToken.length || 
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
