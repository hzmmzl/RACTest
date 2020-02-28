//
//  UserModel.h
//  RACTest
//
//  Created by mzl on 2020/2/27.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *userId; // id

@property (nonatomic,copy) NSString *userName; // 用户名

@property (nonatomic,copy) NSString *phoneNo; // s手机号

@property (nonatomic,copy) NSString *passWord; // 密码

@property (nonatomic,copy) NSString *verificationCode; // 验证码

// 用户性别
@property (nonatomic,strong) NSString *userGender;

@property (nonatomic,assign) BOOL agreeProtocol; //同意协议


- (void)saveUserItem:(UserModel *)item;


@end

NS_ASSUME_NONNULL_END
