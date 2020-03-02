//
//  RegisterAndLoginViewModel.m
//  RACTest
//
//  Created by mzl on 2020/2/28.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "RegisterAndLoginViewModel.h"

@implementation RegisterAndLoginViewModel


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

- (UserModel *)userModel {
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
    }
    return _userModel;
}
@end
