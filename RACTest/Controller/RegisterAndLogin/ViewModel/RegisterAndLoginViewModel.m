//
//  RegisterAndLoginViewModel.m
//  RACTest
//
//  Created by mzl on 2020/2/28.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "RegisterAndLoginViewModel.h"
#import "NetworkService.h"

@implementation RegisterAndLoginViewModel

#pragma mark - Private

/**
 验证手机号请求
 
 @param phoneNum 手机号
 @param subscriber 订阅者
 */
- (void)verityPhoneNumWithPhone:(NSString *)phoneNum subscriber:(id<RACSubscriber>) subscriber {

}

- (void)verityPhoneNumWithPhone:(NSString *)phoneNum
                        success:(nullable void(^)(NetworkService *))success
                        failure:(nullable void(^)(void))failure  {
    
}

- (void)login:(NSString *)phoneNum
                        success:(nullable void(^)(NetworkService *))success
                        failure:(nullable void(^)(void))failure  {
    
}

/**
 获取验证码
 
 @return <#return value description#>
 */
- (RACCommand *)getVerificationCodeCommand {
    if (!_getVerificationCodeCommand) {
        _getVerificationCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                if (self.userModel.phoneNo.length > 11) {
                    self.userModel.phoneNo = [self.userModel.phoneNo substringToIndex:11];
                }
//                if (![self.userModel.phoneNum validPhoneNum]) {
//                    [subscriber sendError:[NSError errorWithDomain:SSJErrorDomain code:@"www.baidu.com" userInfo:@{NSLocalizedDescriptionKey:@"请输入正确的手机号"}]];
//                }
                [self verityPhoneNumWithPhone:self.userModel.phoneNo success:^(__kindof NetworkService *service) {
                            if ([service.returnCode isEqualToString:@"1"]) {
                                [subscriber sendError:[NSError errorWithDomain:@"" code:10086 userInfo:@{NSLocalizedDescriptionKey:@"该帐号已注册"}]];
                            } else if ([service.returnCode isEqualToString:@"0"]) {//@"该帐号未注册"
                                [subscriber sendNext:@{}];
                                [subscriber sendCompleted];
                            } else {
                                [subscriber sendError:[NSError errorWithDomain:@"" code:100086 userInfo:@{NSLocalizedDescriptionKey:@""}]];
                            }
                    
                } failure:^{
                    [subscriber sendError:[NSError errorWithDomain:@"" code:10086 userInfo:@{NSLocalizedDescriptionKey:@"该帐号已注册"}]];
                }];
                return nil;
            }] flattenMap:^__kindof RACSignal * (NSDictionary *result) {
                return [RACSignal empty];
            }];
        }];
    }
    return _getVerificationCodeCommand;
}



#pragma mark - Lazy

- (RACCommand *)registerCommand {
    if (!_registerCommand) {
        _registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if (0) {//验证手机号
                    // 如果手机号有误  sendError不需要[subscriber sendCompleted];
                    [subscriber sendError:[NSError errorWithDomain:@"www.baidu.com" code:10086 userInfo:@{NSLocalizedDescriptionKey:@"请输入正确手机号"}]];
                    return nil;
                }
                
                // 发送请求
                sleep(0.5);
                [subscriber sendNext:@{}];
                
                // 这里一定要写不然信号一直未结束下次点击按钮将不执行
                [subscriber sendCompleted];
                
                return nil;
            }] map:^id _Nullable(NSDictionary *result) {
//                    flattenMap:^__kindof RACSignal * _Nullable(NSDictionary *result) {
//                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                    // 保持用户数据
//                // 发送注册成功通知
//
//                    return nil;
//                }];
                return result;
            }];
        }];
    }
    return _registerCommand;
}

/**
 // 注册按钮可点击逻辑
 1, 手机号验证
 2，密码验证
 3，验证码验证
 4, 同意协议
 */
- (RACSignal *)enableRegisterSignal {
    if (!_enableRegisterSignal) {
        
        _enableRegisterSignal = [RACSignal combineLatest:@[RACObserve(self.userModel, phoneNo), RACObserve(self.userModel, passWord), RACObserve(self.userModel, verificationCode), RACObserve(self.userModel, agreeProtocol)] reduce:^id(NSString *phoneNo, NSString *password, NSString *verCode, NSNumber *agreeProtocol){
            return @(phoneNo.length == 11 && password.length >= 6 && verCode.length == 6 && agreeProtocol.boolValue == YES);
        }];
    }
    return _enableRegisterSignal;
}


- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @weakify(self);
            return [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                // 1、判断手机号是否正确
                // 2、判断手机号是否注册过
                // 3、登录成功保存数据，发送通知
                [self verityPhoneNumWithPhone:self.userModel.phoneNo success:^(__kindof NetworkService *service) {
                    if ([service.returnCode isEqualToString:@"0"]) {
                        [subscriber sendError:[NSError errorWithDomain:@"www.baidu.com" code:10086 userInfo:@{NSLocalizedDescriptionKey:@"该帐号未注册"}]];
                    } else {
                        [subscriber sendCompleted];
                    }
                } failure:^{
                    [subscriber sendError:[NSError errorWithDomain:@"www.baidu.com" code:10086 userInfo:@{NSLocalizedDescriptionKey:@"该帐号未注册"}]];
                }];
                return nil;
            }] then:^RACSignal * _Nonnull{
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    // 发送登录请求
                    [self login:self.userModel.phoneNo success:^(NetworkService *service) {
                        [subscriber sendNext:service.result]; // 返回登录信息
                        [subscriber sendCompleted];
                    } failure:^{
                        [subscriber sendError:[NSError errorWithDomain:@"www.baidu.com" code:10086 userInfo:@{NSLocalizedDescriptionKey:@"登录失败"}]];
                    }];
                    return nil;
                }];
            }] map:^id _Nullable(NSDictionary *value) { // 转成字典
                return value;
            }];
        }];
    }
    return _loginCommand;
}

- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
    }
    return _userModel;
}
@end
