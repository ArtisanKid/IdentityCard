//
//  ICToken.h
//  Pods
//
//  Created by 李翔宇 on 16/6/12.
//

#import "ICModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICToken : ICModel<NSCoding>

@property (class, nonatomic, strong, readonly) ICToken *currentToken;/**<当前token*/

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, assign) NSTimeInterval expiredTime;/**<过期时间*/
@property (nonatomic, assign, getter=isValid) BOOL valid;/**<是否有效*/
@property (nonatomic, assign, getter=isUnexpired) BOOL unexpired;/**<是否未过期*/

@end

NS_ASSUME_NONNULL_END
