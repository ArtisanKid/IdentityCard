//
//  ICUser.m
//  Pods
//
//  Created by 李翔宇 on 15/11/23.
//

#import "ICUser.h"
#import <libkern/OSAtomic.h>
#import "ICCoding.h"
#import "ICModelManager.h"
#import "ICModelProtocol.h"

@interface ICUser ()

@property (nonatomic, strong) NSMapTable *delegateTable;

@end

@implementation ICUser

#pragma mark- 创建锁
static OSSpinLock ICUser_Lock = OS_SPINLOCK_INIT;

+ (ICUser *)currentUser {
    static ICUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!(sharedInstance = [self readSingleton])) {
            sharedInstance = [[super allocWithZone:NULL] init];
        }
        [ICModelManager observe:(id<ICModelProtocol>)self keyPath:@"visitorID", @"userID", @"openID", @"role", @"portrait", @"smallPortrait", @"largePortrait", @"nickName", @"realName", @"gender", @"mobile", @"tel", @"email", @"address", @"brief", @"detail", @"loginType", @"logined", nil];
    });
    return sharedInstance;
}

ICCoding

#pragma mark- 私有方法
- (NSMapTable *)delegateTable {
    static NSMapTable<id, NSMutableArray<void(^)(id target, BOOL isLogined)> *> *registerTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registerTable = [NSMapTable weakToStrongObjectsMapTable];
    });
    return registerTable;
}

#pragma mark- 协议方法
- (NSString *)userID {
    if(!_userID.length) {
        return self.openID;
    }
    return _userID;
}

- (void)setLogined:(BOOL)logined {
    if(_logined == logined) {
        return;
    }
    
    //[self willChangeValueForKey:@"logined"];
    _logined = logined;
    //[self didChangeValueForKey:@"logined"];
    
    if(!_logined) {
        [self reset];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSpinLockLock(&ICUser_Lock);
        NSEnumerator *enumerator = self.delegateTable.keyEnumerator;
        id target = nil;
        while ((target = enumerator.nextObject)) {
            NSArray *blocksI = [[self.delegateTable objectForKey:target] copy];
            [blocksI enumerateObjectsUsingBlock:^(void (^ _Nonnull block)(id, BOOL), NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) {
                        block(target, _logined);
                    }
                });
            }];
        }
        OSSpinLockUnlock(&ICUser_Lock);
    });
}

+ (void)registerDelegate:(id)target loginStateChanged:(void(^)(id target, BOOL isLogined))block {
    if(!target || !block) {
        return;
    }
    OSSpinLockLock(&ICUser_Lock);
    
    NSMutableArray *blocksM = [self.currentUser.delegateTable objectForKey:target];
    if(!blocksM) {
        blocksM = NSMutableArray.array;
        [self.currentUser.delegateTable setObject:blocksM forKey:target];
    }
    [blocksM addObject:block];
    
    OSSpinLockUnlock(&ICUser_Lock);
}

@end
