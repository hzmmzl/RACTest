//
//  RegisterViewController.h
//  RACTest
//
//  Created by mzl on 2020/2/20.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
/*
 在MVVM 中，view 和 view controller正式联系在一起，我们把它们视为一个组件
 view 和 view controller 都不能直接引用model，而是引用视图模型（viewModel）
 viewModel 是一个放置用户输入验证逻辑，视图显示逻辑，发起网络请求和其他代码的地方
 view 引用viewModel ，但反过来不行（即不要在viewModel中引入#import UIKit.h，任何视图本身的引用都不应该放在viewModel中）
 */

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : BaseViewController

@end

NS_ASSUME_NONNULL_END
