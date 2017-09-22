//
//  NSMapTable+ICExtension.h
//  IdentityCard
//
//  Created by 李翔宇 on 2017/9/20.
//

#import <Foundation/Foundation.h>

@interface NSMapTable (ICExtension)

- (NSMutableSet<NSString *> *)ic_keyPathsForObject:(id)object;

@end
