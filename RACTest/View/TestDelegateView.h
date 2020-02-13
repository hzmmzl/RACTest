//
//  TestDelegate.h
//  RACTest
//
//  Created by mzl on 2020/2/13.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;

NS_ASSUME_NONNULL_BEGIN

@interface TestDelegateView : UIView

@property (nonatomic, strong) RACSubject *delegateSignal;

- (void)btnClicked;
@end

NS_ASSUME_NONNULL_END
