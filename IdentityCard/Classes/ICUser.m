//
//  ICUser.m
//  Pods
//
//  Created by 李翔宇 on 15/11/23.
//

#import "ICUser.h"
#import <libkern/OSAtomic.h>
#import "ICCoding.h"
#import "IdentityCardMacros.h"
#import "ICModelManager.h"
#import "ICModelProtocol.h"
#import "NSMapTable+ICExtension.h"

@interface ICUser ()

@property (nonatomic, strong, readonly) NSMapTable *delegateTable;

@end

@implementation ICUser

+ (ICUser *)currentUser {
    static ICUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!(sharedInstance = [self readSingleton])) {
            sharedInstance = [[super allocWithZone:NULL] init];
        }
        
        [ICModelManager observe:(id<ICModelProtocol>)sharedInstance keyPath:@"visitor", @"userID", @"openID", @"role", @"portrait", @"smallPortrait", @"largePortrait", @"nickName", @"realName", @"gender", @"phone", @"tel", @"email", @"address", @"brief", @"detail", @"loginType", @"logined", nil];
        
        [sharedInstance observeKeyPath:@"visitor", @"userID", @"openID", @"role", @"portrait", @"smallPortrait", @"largePortrait", @"nickName", @"realName", @"gender", @"phone", @"tel", @"email", @"address", @"brief", @"detail", @"loginType", @"logined", nil];
    });
    return sharedInstance;
}

ICCoding

#pragma mark - 重载方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //IdentityCardLog(@"%@ 变更属性 %@，%@ -> %@", object, keyPath, change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            NSEnumerator *enumerator = self.delegateTable.keyEnumerator;
            id<ICUserModifyProtocol> observer = nil;
            while ((observer = enumerator.nextObject)) {
                NSSet<NSString *> *keyPaths = [[self.delegateTable ic_keyPathsForObject:observer] copy];
                if(![keyPaths containsObject:keyPath]) {
                    continue;
                }
                [observer ICUserModified:self];
            }
        }
    });
}

#pragma mark- Public Method

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

    _logined = logined;
    
    if(!_logined) {
        [self reset];
    }
}

- (void)addObserver:(id<ICUserModifyProtocol>)observer forKeyPath:(NSString *)firstKeyPath, ... {
    if(!observer
       || !firstKeyPath) {
        return;
    }
    
    NSString *keyPath = firstKeyPath;
    va_list argList;
    va_start(argList, firstKeyPath);
    do {
        if(![keyPath isKindOfClass:[NSString class]]
           || !keyPath.length) {
            continue;
        }
        
        NSMutableSet<NSString *> *keyPathsM = [self.delegateTable ic_keyPathsForObject:observer];
        [keyPathsM addObject:keyPath];
    } while ((keyPath = va_arg(argList, id)));
    va_end(argList);
}

- (void)removeObserver:(id<ICUserModifyProtocol>)observer forKeyPath:(NSString *)firstKeyPath, ... {
    if(!observer) {
        return;
    }
    
    if(!firstKeyPath) {
        [self.delegateTable removeObjectForKey:observer];
        return;
    }
    
    NSString *keyPath = firstKeyPath;
    va_list argList;
    va_start(argList, firstKeyPath);
    do {
        if(![keyPath isKindOfClass:[NSString class]]
           || !keyPath.length) {
            continue;
        }
        
        NSMutableSet<NSString *> *keyPathsM = [self.delegateTable ic_keyPathsForObject:observer];
        [keyPathsM removeObject:keyPath];
    } while ((keyPath = va_arg(argList, id)));
    va_end(argList);
}

#pragma mark - Property Method

- (NSMapTable *)delegateTable {
    static NSMapTable<id, NSMutableArray<NSString *> *> *registerTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registerTable = [NSMapTable weakToStrongObjectsMapTable];
    });
    return registerTable;
}

- (void)observeKeyPath:(NSString *)firstKeyPath, ... {
    if(!firstKeyPath) {
        return;
    }
    
    NSString *keyPath = firstKeyPath;
    va_list argList;
    va_start(argList, firstKeyPath);
    do {
        if(![keyPath isKindOfClass:[NSString class]]
           || !keyPath.length) {
            continue;
        }
        
        [self addObserver:(NSObject *)self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    } while ((keyPath = va_arg(argList, id)));
    va_end(argList);
}

@end
