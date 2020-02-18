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


@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textField];
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
    }
    return _textField;
}

@end
