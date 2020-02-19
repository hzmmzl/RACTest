//
//  TwoViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/18.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@property (nonatomic,copy) NSArray *testArray;

@property (nonatomic,strong) NSMutableArray *mutableArray;

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITextField *passwordtextField;
@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.passwordtextField];
    [self.view addSubview:self.loginBtn];
    [self test];
}


- (void)test {
    // 1.map 把源信号的值映射成一个新的值
//    [[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return [NSString stringWithFormat:@"值：%@",value];
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"map后的值为：%@",x);
//    }];
    
    // 1.map 把源信号的值映射成一个新的值
    RACSubject *mapSignal = [RACSubject subject];
    [[mapSignal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"map：%@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"map:%@",x);
    }];
    [mapSignal sendNext:@"abc"];
    
    
    // 2.filtermap
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];

    [[signalOfsignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id x) {
            // 只有signalOfsignals的signal发出信号才会调用
            NSLog(@"%@aaa",x); // 1
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];
    // 信号发送内容
    [signal sendNext:@1];
    
    // 3.concat
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活
    [[signalA concat:signalB] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    // 4. then
  // 功能和const相似
    [[signal then:^RACSignal * _Nonnull{
        return signalB;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    // 5. merge
    [[signalA merge:signalB] subscribeNext:^(id  _Nullable x) {
        // 任意一个信号发送内容都会来这个block
    }];

    // 6.zipWith
    // 压缩成一个信号
    // zipWith:当一个界面多个请求的时候,要等所有请求完成才能更新UI
    // zipWith:等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [[signalA zipWith:signalB] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    // 7.combineLatest,reduce
    RACSignal *comineSiganl = [RACSignal combineLatest:@[self.textField.rac_textSignal,self.passwordtextField.rac_textSignal] reduce:^id(NSString *account,NSString *pwd){
        // block:只要源信号发送内容就会调用,组合成新一个值
        NSLog(@"%@ %@",account,pwd);
        // 聚合的值就是组合信号的内容
        
        return @(account.length && pwd.length);
    }];
    
    // 订阅组合信号
    //    [comineSiganl subscribeNext:^(id x) {
    //        _loginBtn.enabled = [x boolValue];
    //    }];
    
    RAC(self.loginBtn,enabled) = comineSiganl;
    

    // 8.filter
    NSArray *tempArr = [self.testArray.rac_sequence filter:^BOOL(NSString *value) {
        return value.integerValue > 4;
    }];
    
    [[RACObserve(self, mutableArray) filter:^BOOL(NSMutableArray *value) {
        return value.count > 3;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];

    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        // 只有当输入字数大于3的时候才触发
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        
    }];
}


#pragma mark - Lazy

- (NSArray *)testArray {
    if (!_testArray) {
        _testArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    }
    return _testArray;
}

- (NSMutableArray *)mutableArray {
    if (!_mutableArray) {
        _mutableArray = [@[@"1a",@"2a",@"3a",@"4a",@"5a",@"6a",@"7a",@"8a",@"9a"] mutableCopy];
    }
    return _mutableArray;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
        _textField.backgroundColor = [UIColor cyanColor];
    }
    return _textField;
}

- (UITextField *)passwordtextField {
    if (!_passwordtextField) {
        _passwordtextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
        _passwordtextField.backgroundColor = [UIColor cyanColor];

    }
    return _passwordtextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 300, 100, 44)];
        _loginBtn.enabled = NO;
        [_loginBtn setTitle:@"sure" forState:(UIControlStateNormal)];
        [_loginBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_loginBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateDisabled)];
    }
    return _loginBtn;
}

@end
