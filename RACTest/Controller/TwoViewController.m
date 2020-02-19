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
    [self testCategory];
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

    // ignore:忽略一些值
    //    注意，这里忽略的既可以是地址相同的对象，也可以是- isEqual:结果相同的值，也就是说自己写的Model对象可以通过重写- isEqual:方法来使- ignore:生效。
    [[self.textField.rac_textSignal ignore:@"3a"] subscribeNext:^(NSString * _Nullable x) {
        
    }];
    
    // ignoreValues:忽略所有的值
    RACSubject *subject = [RACSubject subject];
    // 2.忽略一些
    RACSignal *ignoreSignal = [subject ignoreValues];
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"13"];
    [subject sendNext:@"2"];
    [subject sendNext:@"44"];
//    这个比较极端，忽略所有值，只关心Signal结束，也就是只取Comletion和Error两个消息，中间所有值都丢弃。
//    注意，这个操作应该出现在Signal有终止条件的的情况下，如rac_textSignal这样除dealloc外没有终止条件的Signal上就不太可能用到。

    // distinctUntilChanged
//    当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
    [[self.textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {  NSLog(@"%@",x);}];

    RACSubject *subject1 = [RACSubject subject];
    
    [[subject1 distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject1 sendNext:@"1"];
    [subject1 sendNext:@"2"];
    [subject1 sendNext:@"2"];//不会被订阅到
    
    // take
    RACSubject *subjectTake = [RACSubject subject];
    
    RACSubject *signalTake = [RACSubject subject];
    
    // take:取前面几个值,从开始一共取N次的next值，不包括Competion和Error

    // takeLast:取后面多少个值.必须要发送完成
    // takeUntil:只要传入信号发送完成或者发送任意数据,就不能在接收源信号的内容
    [[subjectTake takeUntil:signalTake] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subjectTake sendNext:@"1"];
    
    //    [signalTake sendNext:@1];
    //    [signalTake sendCompleted];
    [signalTake sendError:nil];
    
    [subjectTake sendNext:@"2"];
    [subjectTake sendNext:@"3"];


    [[subjectTake takeLast:2] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }] take:2] subscribeNext:^(id x) {
        NSLog(@"only 1 and 2 will be print: %@", x);
    }];
    
//    takeUntilBlock
//    对于每个next值，运行block，当block返回YES时停止取值
    [[self.textField.rac_textSignal takeUntilBlock:^BOOL(NSString *value) {
        return [value isEqualToString:@"stop"];
    }] subscribeNext:^(NSString *value) {
    }];

//    takeWhileBlock
//    和takeUntilBlock相反  对于每个next值，block返回 YES时才取值

    
    // doNext: 执行Next之前，会先执行这个Block
    // doCompleted: 执行sendCompleted之前，会先执行这个Block
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // timeout
//    可以让一个信号在一定的时间后，自动报错
    RACSignal *signalTime = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(88)];
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signalTime subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"%@",error);
    }];
    
    // interval :定时器
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
    }];
    
    // delay
    [[signal delay:1] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    // retry只要失败，就会重新执行创建信号中的block,直到成功.
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@1];
        } else{
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        
    }];
    
    
    // replay
    // 和RACReplaySubject功能相同
    RACSignal *replaySignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [replaySignal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [replaySignal subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
        
    }];
    
    // throttle
//    节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[signal throttle:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}


- (void)testCategory {
    
//    [[[cell.detailButton
//       rac_signalForControlEvents:UIControlEventTouchUpInside]
//      takeUntil:cell.rac_prepareForReuseSignal]
//     subscribeNext:^(id x) {
//     }];
    // 如果不加takeUntil:cell.rac_prepareForReuseSignal，那么每次Cell被重用时，该button都会被addTarget:sele
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber * _Nullable x) {
        
    }];
    
    NSData *date = [NSData data];


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
