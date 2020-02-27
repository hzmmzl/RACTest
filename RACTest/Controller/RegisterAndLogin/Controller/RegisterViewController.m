//
//  RegisterViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/20.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "RegisterViewController.h"
#import "Header.h"


@interface RegisterViewController()

@property (nonatomic, strong) UIButton *forgetPassWordButton; // 忘记密码按钮

@property (nonatomic, strong) UIButton *loginButton; // 登录按钮

@property (nonatomic, strong) UIButton *registerButton; // 注册按钮

@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UITextField *phoneTF; // 手机号

@property (nonatomic,strong) UILabel *pwdL;
@property (nonatomic,strong) UITextField *pwdTF; // 密码

@property (nonatomic, strong) UIButton *agreeButton; // 同意协议按钮

@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self.view addSubview:self.phoneL];
    [self.view addSubview:self.pwdL];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.pwdTF];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.agreeButton];
}



#pragma mark - Layout

#pragma mark - Lazy

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneL.frame), 200, 200, 44)];
    }
    return _phoneTF;
}

- (UITextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pwdL.frame), 200, 200, 44)];
    }
    return _pwdTF;
}

- (UILabel *)phoneL {
    if (!_phoneL) {
        _phoneL = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 100, 44)];
        _phoneL.text = @"手机号:";
    }
    return _phoneL;
}

- (UILabel *)pwdL {
    if (!_pwdL) {
        _pwdL = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.phoneL.frame), 100, 44)];
        _pwdL.text = @"密  码:";
    }
    return _pwdL;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.pwdL.frame) + 50, SCREENWITH - 200, 44)];
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
        _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loginButton.frame), CGRectGetMaxY(self.loginButton.frame), 200, 20)];
        _agreeButton.selected = YES;
        [_agreeButton setImage:nil forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"register_agreement"] forState:UIControlStateSelected];
        NSString *oldStr = @"我已阅读并同意用户协定";
        [_agreeButton setTitle:oldStr forState:(UIControlStateNormal)];
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
            btn.selected = !btn.selected;
        }];
    }
    return _agreeButton;
}
//
//- (UIButton *)protocolButton {
//    if (!_protocolButton) {
//        _protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _protocolButton.titleLabel.font = [UIFont  systemFontOfSize:12];
//        NSString *oldStr = @"我已阅读并同意用户协定";
//        [_protocolButton setTitle:oldStr forState:(UIControlStateNormal)];
//        @weakify(self);
//        [[_protocolButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
//
//        }];
//    }
//    return _protocolButton;
//}


@end
