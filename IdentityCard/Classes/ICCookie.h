//
//  ICCookie.h
//  Pods
//
//  Created by 李翔宇 on 16/8/17.
//

#import "ICModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICCookie : ICModel<NSCoding>

@property (class, nonatomic, strong, readonly) ICCookie *currentCookie;/**<当前cookie*/

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSTimeInterval expiredTime;/**<过期时间*/
@property (nonatomic, assign, getter=isValid) BOOL valid;/**<是否有效*/
@property (nonatomic, assign, getter=isUnexpired) BOOL unexpired;/**<是否过期*/

@end

NS_ASSUME_NONNULL_END
