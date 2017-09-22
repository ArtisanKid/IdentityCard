//
//  NSMutableDictionary+ICExtension.m
//  IdentityCard
//
//  Created by 李翔宇 on 2017/9/19.
//

#import "NSMutableDictionary+ICExtension.h"

@implementation NSMutableDictionary (ICExtension)

- (NSMutableArray *)ic_keyPathsForObject:(NSObject *)object {
    NSMutableArray *keyPathsM = self[object];
    if(!keyPathsM
       || ![keyPathsM isKindOfClass:[NSMutableArray class]]) {
        keyPathsM = [NSMutableArray array];
        self[@(object.hash)] = keyPathsM;
    }
    return keyPathsM;
}

@end
