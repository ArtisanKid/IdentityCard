//
//  ICModel.h
//  Pods
//
//  Created by 李翔宇 on 2016/12/17.
//

#import <Foundation/Foundation.h>
#import "ICModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICModel : NSObject<ICModelProtocol>

- (void)cacheSingleton;
- (void)cacheWithSignature:(NSString *)signature;

+ (id)readSingleton;
+ (id)readWithSignature:(NSString *)signature;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
