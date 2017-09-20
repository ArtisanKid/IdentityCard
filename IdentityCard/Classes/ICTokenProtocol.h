//
//  ICTokenProtocol.h
//  Pods
//
//  Created by 李翔宇 on 16/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ICTokenProtocol

@required

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;

@property (nonatomic, assign) NSTimeInterval expiredTime;/**<过期时间*/
@property (nonatomic, assign, getter=isValid) BOOL valid;/**<数据是否有效*/
@property (nonatomic, assign, getter=isUnexpired) BOOL unexpired;/**<是否过期*/

@end

NS_ASSUME_NONNULL_END
