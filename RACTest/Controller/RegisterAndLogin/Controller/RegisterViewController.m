//
//  RegisterViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/20.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController()

@property (nonatomic, strong) UIButton *forgetPassWordButton; // 忘记密码按钮

@property (nonatomic, strong) UIButton *loginButton; // 登录按钮

@property (nonatomic, strong) UIButton *registerButton; // 注册按钮

@property (nonatomic,strong) UITextField *phoneTF; // 手机号

@property (nonatomic,strong) UITextField *pwdTF; // 密码

@property (nonatomic, strong) UIButton *agreeButton; // 同意协议按钮

@property (nonatomic, strong) UIButton *protocolButton; // 协议

@end

@implementation RegisterViewController




#pragma mark - Lazy

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.selected = YES;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        @weakify(self);
        [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
        }];
    }
    return _loginButton;
}


- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        _registerButton.selected = NO;
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        @weakify(self);
        [[_registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
        }];
    }
    return _registerButton;
}


- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.selected = YES;
        [_agreeButton setImage:nil forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"register_agreement"] forState:UIControlStateSelected];
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
            btn.selected = !btn.selected;
        }];
    }
    return _agreeButton;
}

- (UIButton *)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _protocolButton.titleLabel.font = [UIFont  systemFontOfSize:12];
        NSString *oldStr = @"我已阅读并同意用户协定";
        [_protocolButton setTitle:oldStr forState:(UIControlStateNormal)];
        @weakify(self);
        [[_protocolButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }
    return _protocolButton;
}

@end
