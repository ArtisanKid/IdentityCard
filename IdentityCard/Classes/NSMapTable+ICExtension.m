//
//  NSMapTable+ICExtension.m
//  IdentityCard
//
//  Created by 李翔宇 on 2017/9/20.
//

#import "NSMapTable+ICExtension.h"

@implementation NSMapTable (ICExtension)

- (NSMutableSet<NSString *> *)ic_keyPathsForObject:(id)object {
    NSMutableSet *keyPathsM = [self objectForKey:object];
    if(!keyPathsM
       || ![keyPathsM isKindOfClass:[NSMutableSet class]]) {
        keyPathsM = [NSMutableSet set];
        [self setObject:keyPathsM forKey:object];
    }
    return keyPathsM;
}

@end
