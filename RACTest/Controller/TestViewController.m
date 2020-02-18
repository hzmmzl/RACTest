//
//  TestViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/13.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "TestViewController.h"
#import "TestDelegateView.h"
#import <ReactiveObjC.h>
#import <UIKit/UIKit.h>

@interface TestViewController ()
@property (nonatomic,strong) TestDelegateView *deleView;
@property (nonatomic,copy) NSString *valueA;
@property (nonatomic,copy) NSString *valueB;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.deleView];
    
    self.deleView.frame = CGRectMake(100, 200, 300, 50);
    
//    self.deleView rac_valuesForKeyPath:<#(nonnull NSString *)#> observer:<#(NSObject * _Nonnull __weak)#>
//    self.deleView rac_valuesAndChangesForKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> observer:<#(NSObject * _Nonnull __weak)#>
}

- (TestDelegateView *)deleView {
    if (!_deleView) {
        _deleView = [[TestDelegateView alloc] init];
        _deleView.delegateSignal = [RACSubject subject];
        [_deleView.delegateSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"======");
        }];
        
//        或者?
        [[_deleView rac_signalForSelector:@selector(btnClicked)] subscribeNext:^(RACTuple * _Nullable x) {
            NSLog(@"@@@@@@@@");
        }];
    }
    return _deleView;
}

- (void)test {
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(dosomething) withSignalsFromArray:@[request1,request2]];
}

- (void)test2 {
    RACChannelTerminal *channelA = RACChannelTo(self, valueA);
    RACChannelTerminal *channelB = RACChannelTo(self, valueB);
    [[channelA map:^id(NSString *value) {
        if ([value isEqualToString:@"西"]) {
            return @"东";
        }
        return value;
    }] subscribe:channelB];
    [[channelB map:^id(NSString *value) {
        if ([value isEqualToString:@"左"]) {
            return @"右";
        }
        return value;
    }] subscribe:channelA];
    
    [[RACObserve(self, valueA) filter:^BOOL(id value) {
        return value ? YES : NO;
    }] subscribeNext:^(NSString *x) {
        NSLog(@"你向%@", x);
    }];
    [[RACObserve(self, valueB) filter:^BOOL(id value) {
        return value ? YES : NO;
    }] subscribeNext:^(NSString *x) {
        NSLog(@"他向%@", x);
    }];
    self.valueA = @"西";
    self.valueB = @"左";
 
}
@end
