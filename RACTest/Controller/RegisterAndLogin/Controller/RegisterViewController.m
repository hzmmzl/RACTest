//
//  RegisterViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/20.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "RegisterViewController.h"
#import "Header.h"
#import "UIImage+Addition.h"
#import "UIColor+SSJAddition.h"
#import "RegisterAndLoginViewModel.h"
#import "ResultViewController.h"


@interface RegisterViewController()

@property (nonatomic,strong) RegisterAndLoginViewModel *viewModel;

@property (nonatomic, strong) UIButton *registerButton; // 注册按钮

@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UITextField *phoneTF; // 手机号
@property (nonatomic,strong) UIButton *verCodeBtn;

@property (nonatomic,strong) UILabel *pwdL;
@property (nonatomic,strong) UITextField *pwdTF; // 密码

@property (nonatomic,strong) UILabel *verificationCodeL;
@property (nonatomic,strong) UITextField *verificationCodeTF; // 验证码

@property (nonatomic, strong) UIButton *agreeButton; // 同意协议按钮
@property (nonatomic,strong) UILabel *protocolL;

@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self.view addSubview:self.phoneL];
    [self.view addSubview:self.pwdL];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.pwdTF];
    [self.view addSubview:self.verificationCodeL];
    [self.view addSubview:self.verificationCodeTF];
    [self.view addSubview:self.verCodeBtn];
    
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.agreeButton];
    [self.view addSubview:self.protocolL];
    
    [self initialBind];
}



#pragma mark - Bind

/**
 信号绑定
 */
- (void)initialBind {
//    RAC(self.viewModel.userModel, phoneNo) = self.phoneTF.rac_textSignal;
    RAC(self.viewModel.userModel, passWord) = self.pwdTF.rac_textSignal;
    RAC(self.viewModel.userModel, verificationCode) = self.verificationCodeTF.rac_textSignal;
    RAC(self.viewModel.userModel, agreeProtocol) = RACObserve(self.agreeButton, selected);
    
    /// 限制输入位数
    @weakify(self);
    [[self.phoneTF.rac_textSignal filter:^BOOL(NSString * phone) {
        if (phone.length > 11) {
            self.phoneTF.text = [phone substringToIndex:11];
        }
        return phone.length <= 11; // 只有当输入位数小于11位的时候才触发
    }] subscribeNext:^(NSString * phoneNo) {
        @strongify(self);
        self.viewModel.userModel.phoneNo = phoneNo;
    }];
    
    // 注册按钮可点击逻辑
    /*
     1,手机号验证 11位
     2，密码验证  大于6位
     3，验证码验证 6位数字
     */
    
    RAC(self.registerButton, enabled) = self.viewModel.enableRegisterSignal;
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

- (UITextField *)verificationCodeTF {
    if (!_verificationCodeTF) {
        _verificationCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneTF.frame.origin.x, CGRectGetMaxY(self.pwdTF.frame)+ 30, 200, 44)];
        _verificationCodeTF.placeholder = @"请输入验证码";
        _verificationCodeTF.borderStyle = UITextBorderStyleLine;
    }
    return _verificationCodeTF;
}

- (UILabel *)verificationCodeL {
    if (!_verificationCodeL) {
        _verificationCodeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.phoneL.frame), CGRectGetMaxY(self.pwdTF.frame)+ 30, 100, 44)];
        _verificationCodeL.text = @"验证码:";
    }
    return _verificationCodeL;
}

- (UIButton *)verCodeBtn {
    if (!_verCodeBtn) {
        _verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneTF.frame), CGRectGetMinY(self.phoneTF.frame), 70, 44)];
        [_verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verCodeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _verCodeBtn.backgroundColor = [UIColor colorWithHex:@"ea4a64"];
        _verCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        @weakify(self);
        [[_verCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            //发送验证码
            [[self.viewModel.getVerificationCodeCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
            }];
        }];
    }
    return _verCodeBtn;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.verificationCodeTF.frame) + 50, SCREENWITH - 200, 44)];
        _registerButton.selected = NO;
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"f9cbd0"] size:_registerButton.frame.size] forState:UIControlStateDisabled];
        [_registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"ea4a64"] size:_registerButton.frame.size] forState:UIControlStateNormal];

        @weakify(self);
        [[_registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
            // 点击
//            [[self.viewModel.registerCommand execute:nil] subscribeError:^(NSError * _Nullable error) {
//                // 失败
//            } completed:^{
//                // 成功 刷新页面
//                ResultViewController *vc = [[ResultViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }];
            [[self.viewModel.registerCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                // 成功 刷新页面
                ResultViewController *vc = [[ResultViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            // 当信号正在处理时发送信号，处理界面其他问题
            [[[self.viewModel.registerCommand.executing skip:1] distinctUntilChanged] subscribeNext:^(NSNumber * _Nullable x) {
                if ([x boolValue]) { // 正在执行（发送请求等等）
                    self.pwdTF.userInteractionEnabled = NO;
                } else {
                    self.pwdTF.userInteractionEnabled = YES;
                }
            }];
        }];
    }
    return _registerButton;
}


- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.registerButton.frame), CGRectGetMaxY(self.registerButton.frame) +10, 18, 18)];
        _agreeButton.selected = YES;
        [_agreeButton setImage:[UIImage imageNamed:@"data_export_unselected"] forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"data_export_selected"] forState:UIControlStateSelected];
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
            btn.selected = !btn.selected;
        }];
    }
    return _agreeButton;
}

- (UIButton *)protocolL {
    if (!_protocolL) {
        _protocolL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.agreeButton.frame), CGRectGetMinY(self.agreeButton.frame) - 10, 200, 38)];
        _protocolL.font = [UIFont  systemFontOfSize:12];
        _protocolL.text = @"我已阅读并同意用户协定";
    }
    return _protocolL;
}

- (RegisterAndLoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RegisterAndLoginViewModel alloc] init];
    }
    return _viewModel;
}

@end
