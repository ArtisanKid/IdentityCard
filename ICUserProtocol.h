//
//  ICUserProtocol.h
//  Pods
//
//  Created by 李翔宇 on 15/11/25.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ICUserProtocol

@required

@property (class, nonatomic, strong, readonly) id<ICUserProtocol> currentUser;/**<当前用户*/
@property (nonatomic, copy) NSString *visitorID;/**<游客ID*/
@property (nonatomic, copy) NSString *userID;/**<用户ID*/

/**
 *  OAuth模式下使用openID
 *  OAuth模式下userID总是等于openID
 */
@property (nonatomic, copy) NSString *openID;

@property (nonatomic, assign, getter=isLogined) BOOL logined;/**<是否已经登陆*/

@property (nonatomic, assign) NSUInteger role;/**<用户权限*/

@property (nonatomic, copy) NSString *portrait;/**<头像*/
@property (nonatomic, copy) NSString *smallPortrait;/**<小头像，主要用于IM，通知等*/
@property (nonatomic, copy) NSString *largePortrait;/**<大头像*/

@property (nonatomic, copy) NSString *nickname;/**<昵称*/
@property (nonatomic, copy) NSString *realname;/**<真名*/

@property (nonatomic, assign) NSUInteger gender;/**<性别*/

@property (nonatomic, copy) NSString *mobile;/**<手机号*/
@property (nonatomic, copy) NSString *tel;/**<电话*/
@property (nonatomic, copy) NSString *email;/**<邮件*/
@property (nonatomic, copy) NSString *address;/**<地址*/

@property (nonatomic, copy) NSString *brief;/**<简介*/
@property (nonatomic, copy) NSString *detail;/**<详情*/

@property (nonatomic, assign) NSUInteger loginType;/**<登陆类型*/

/**
 *  注册Log状态
 *  内部使用NSMapTable(weIC->strong)来管理(target，blocks)，使用此方法的原因是，无需主动释放target。根据文档说明，当key释放的时候，NSMapTable中对应的value也会释放(延迟的)。
 但是需要注意的是，因为blocks是strong类型，调用self仍然会发生循环引用(User->NSMapTable->blocks->self)。
 解决方法
 (1)weICfy,strongfy
 (2)使用block中的target
 *
 *  @param target id
 *  @param block  void(^)(BOOL isLogined)
 */
+ (void)registerDelegate:(id)target loginStateChanged:(void(^)(id target, BOOL isLogined))block;

@end

NS_ASSUME_NONNULL_END
