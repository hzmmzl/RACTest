//
//  RACCommandViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/13.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "RACCommandViewController.h"


@interface RACCommandViewController ()

@end

@implementation RACCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testCommand];
}

- (void)testCommand {
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        NSLog(@"执行命令");
        
        // 创建空信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    
    // 3.执行命令
    [command execute:@1];
    
    // 4.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
        
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
//    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
    
    // 5.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
//    [[command.executing skip:1] subscribeNext:^(id x) {
//        
//        if ([x boolValue] == YES) {
//            // 正在执行
//            NSLog(@"正在执行");
//            
//        }else{
//            // 执行完成
//            NSLog(@"执行完成");
//        }
//        
//    }];
    
}



@end
