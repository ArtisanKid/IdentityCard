//
//  ICModelProtocol.h
//  IdentityCard
//
//  Created by 李翔宇 on 2017/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ICModelProtocol <NSObject>

@required

- (void)cacheSingleton;
- (void)cacheWithSignature:(NSString *)signature;

@end

NS_ASSUME_NONNULL_END
