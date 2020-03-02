//
//  LoginViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/20.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "LoginViewController.h"
#import "Header.h"
#import "UIImage+Addition.h"
#import "UIColor+SSJAddition.h"
#import "RegisterAndLoginViewModel.h"
#import "ResultViewController.h"

@interface LoginViewController()
@property (nonatomic, strong) UIButton *loginButton; // 登录按钮

@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UITextField *phoneTF; // 手机号

@property (nonatomic,strong) UILabel *pwdL;
@property (nonatomic,strong) UITextField *pwdTF; // 密码

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    [self.view addSubview:self.phoneL];
    [self.view addSubview:self.pwdL];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.pwdTF];
    [self.view addSubview:self.loginButton];
}

#pragma mark - Lazy

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneL.frame), 200, 200, 44)];
        _phoneTF.borderStyle = UITextBorderStyleLine;
        _phoneTF.placeholder = @"请输入手机号";
    }
    return _phoneTF;
}

- (UITextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneL.frame), CGRectGetMaxY(self.phoneTF.frame) + 30, 200, 44)];
        _pwdTF.placeholder = @"请输入密码";
        _pwdTF.secureTextEntry = YES;
        _pwdTF.borderStyle = UITextBorderStyleLine;
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
        _pwdL = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.phoneL.frame) + 30, 100, 44)];
        _pwdL.text = @"密    码:";
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
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"f9cbd0"] size:_loginButton.frame.size] forState:UIControlStateDisabled];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"ea4a64"] size:_loginButton.frame.size] forState:UIControlStateNormal];
        @weakify(self);
        [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }
    return _loginButton;
}
@end
