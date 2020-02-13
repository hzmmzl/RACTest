//
//  TestDelegate.m
//  RACTest
//
//  Created by mzl on 2020/2/13.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "TestDelegateView.h"

#import <ReactiveObjC.h>

@interface TestDelegateView ()
@property (nonatomic,strong) UIButton *btn;

@end


@implementation TestDelegateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.btn];
        self.btn.frame = CGRectMake(0, 0, 300, 50);
        self.btn.backgroundColor = [UIColor cyanColor];
    }
    return self;
}


- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        @weakify(self);
        [[_btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.delegateSignal) {
                [self.delegateSignal sendNext:nil];
            }
        }];
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btn;
}

- (void)btnClicked {
    
}

@end
