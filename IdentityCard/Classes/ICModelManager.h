//
//  ICModelManager.h
//  IdentityCard
//
//  Created by 李翔宇 on 2017/9/19.
//

#import <Foundation/Foundation.h>
#import "ICModelProtocol.h"

@interface ICModelManager : NSObject

/**
 监听对象属性

 @param target 目标对象
 @param firstKeyPath 监听路径
 */
+ (void)observe:(id<ICModelProtocol>)target keyPath:(NSString *)firstKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

/**
 解除监听对象属性
 
 @param target 目标对象
 @param firstKeyPath 监听路径
 */
+ (void)ignore:(id<ICModelProtocol>)target keyPath:(NSString *)firstKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

/**
 暂停监听对象

 @param target 目标对象
 */
+ (void)pause:(id<ICModelProtocol>)target;

/**
 恢复监听对象
 
 @param target 目标对象
 */
+ (void)resume:(id<ICModelProtocol>)target;

/**
 移除监听对象

 @param target 目标对象
 */
+ (void)remove:(id)target;

@end
