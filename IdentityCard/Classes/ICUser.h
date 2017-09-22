//
//  ICUser.h
//  Pods
//
//  Created by 李翔宇 on 15/11/23.
//

#import "ICModel.h"

typedef NS_ENUM(NSUInteger, ICLoginType) {
    ICLoginTypeAccount, //账号密码登录
    ICLoginTypePhone, //手机号验证码登录
    ICLoginTypeUnion, //三方联合登录
};

NS_ASSUME_NONNULL_BEGIN

@class ICUser;

@protocol ICUserModifyProtocol

@required
- (void)ICUserModified:(ICUser *)user;

@end

@interface ICUser : ICModel<NSCoding>

@property (class, nonatomic, strong, readonly) ICUser *currentUser;/**<当前用户*/
@property (nonatomic, assign, getter=isVisitor) BOOL visitor;/**<是否游客*/
@property (nonatomic, copy) NSString *userID;/**<用户ID*/

/**
 *  OAuth模式下使用openID
 *  OAuth模式下userID总是等于openID
 */
@property (nonatomic, copy) NSString *openID;

@property (nonatomic, assign, getter=isLogined) BOOL logined;/**<是否已经登陆*/
@property (nonatomic, assign) NSUInteger loginType;/**<登陆类型*/
@property (nonatomic, assign) NSTimeInterval loginTime;//登录时间戳

/**
 用户权限
 建议使用1011001001类似的二进制来表示权限，方便权限控制
 */
@property (nonatomic, assign) NSUInteger role;

@property (nonatomic, copy) NSString *portrait;/**<头像*/
@property (nonatomic, copy) NSString *smallPortrait;/**<小头像，主要用于IM，通知等*/
@property (nonatomic, copy) NSString *largePortrait;/**<大头像，主要用于详情等*/

@property (nonatomic, copy) NSString *nickname;/**<昵称*/
@property (nonatomic, copy) NSString *realname;/**<真名*/

@property (nonatomic, assign) NSUInteger gender;/**<性别*/

@property (nonatomic, copy) NSString *phone;/**<手机号*/
@property (nonatomic, copy) NSString *tel;/**<电话*/
@property (nonatomic, copy) NSString *email;/**<邮件*/
@property (nonatomic, copy) NSString *address;/**<地址*/
@property (nonatomic, assign) NSTimeInterval birthday;/**<生日时间戳*/

@property (nonatomic, copy) NSString *motto;/**<座右铭*/
@property (nonatomic, copy) NSString *brief;/**<简介*/
@property (nonatomic, copy) NSString *detail;/**<详情*/

/**
 注册监控ICUser变更
 因为ICUser的实现逻辑不可见，使用此接口能保证所有属性都是可被KVO的

 @param observer 观察者
 @param firstKeyPath keyPath
 */
- (void)addObserver:(id<ICUserModifyProtocol>)observer forKeyPath:(NSString *)firstKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

/**
 取消注册监控ICUser变更
 因为ICUser的实现逻辑不可见，使用此接口能保证所有属性都是可被KVO的
 
 @param observer 观察者
 @param firstKeyPath keyPath
 */
- (void)removeObserver:(id<ICUserModifyProtocol>)observer forKeyPath:(NSString *)firstKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
