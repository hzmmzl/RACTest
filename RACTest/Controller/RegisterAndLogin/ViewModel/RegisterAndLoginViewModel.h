//
//  RegisterAndLoginViewModel.h
//  RACTest
//
//  Created by mzl on 2020/2/28.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterAndLoginViewModel : NSObject

@property (nonatomic,strong) UserModel *userModel;

/**注册并登录命令*/
@property (nonatomic, strong) RACCommand *registerCommand;

/**是否允许点击注册按钮信号*/
@property (nonatomic, strong) RACSignal *enableRegisterSignal;

@end

NS_ASSUME_NONNULL_END
