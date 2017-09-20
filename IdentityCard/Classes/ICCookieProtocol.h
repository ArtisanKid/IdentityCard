//
//  ICCookieProtocol.h
//  Pods
//
//  Created by 李翔宇 on 16/8/17.
//

#import <Foundation/Foundation.h>

@protocol ICCookieProtocol

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSTimeInterval expiredTime;/**<过期时间*/
@property (nonatomic, assign, getter=isValid) BOOL valid;/**<数据是否有效*/
@property (nonatomic, assign, getter=isUnexpired) BOOL unexpired;/**<是否过期*/

@end
