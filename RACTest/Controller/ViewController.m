//
//  ViewController.m
//  RACTest
//
//  Created by mzl on 2020/2/11.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BaseTableViewCell.h"

#import "TestViewController.h"
#import "RACCommandViewController.h"



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    if (self.titleArray.count > indexPath.row) {
        cell.textLabel.text = self.titleArray[indexPath.row];
    } else {
        cell.textLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TestViewController *testVC = [[TestViewController alloc] init];
        [self.navigationController pushViewController:testVC animated:YES];
    } else if (indexPath.row == 1) {
        RACCommandViewController *vc = [[RACCommandViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"TestDelegate",@"RACCommand"];
    }
    return _titleArray;
}

- (void)test3 {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //        subscriber sendNext:<#(nullable id)#>
        return nil;
    }] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    
    NSDictionary *dic = @{@"name":@"mzl",@"age":@18};
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
    
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
}


- (void)saveDataWithCompletion:(void(^)(NSString *editeItem))completion {
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [SSJRecordMakingStore saveChargeWithChargeItem:self.item success:^(SSJBillingChargeCellItem *editeItem){
//            [subscriber sendNext:editeItem];
//            [subscriber sendCompleted];
//        } failure:^(NSError *error){
//            [subscriber sendError:error];
//        }];
        return nil;
    }] flattenMap:^RACSignal *(NSString *editeItem) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:editeItem];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(NSString *editeItem) {
        if (completion) {
            completion(editeItem);
        }
    } error:^(NSError *error) {
//        [CDAutoHideMessageHUD showError:error];
    }];
}


- (void)test {
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 3.发送信号
        [subscriber sendNext:@"ws"];
        // 4.取消信号，如果信号想要被取消，就必须返回一个RACDisposable
        // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候机会自动取消订阅，2.手动取消，
        //block什么时候调用：一旦一个信号被取消订阅就会调用
        //block作用：当信号被取消时用于清空一些资源
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    // 2. 订阅信号
    //subscribeNext
    // 把nextBlock保存到订阅者里面
    // 只要订阅信号就会返回一个取消订阅信号的类
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        // block的调用时刻：只要信号内部发出数据就会调用这个block
        NSLog(@"======%@", x);
    }];
    // 取消订阅
    [disposable dispose];
}

- (void)then {
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return nil;
    }] then:^RACSignal * _Nonnull{
        
        return nil;
    }];
    
    // 模拟先后执行顺序
//    [[[[[self loadCurrentBooksIdSignal] then:^RACSignal *{
//        return [self loadBooksListSignal];
//    }] then:^RACSignal *{
//        return [self loadCurrentSelectBillType];
//    }] then:^RACSignal *{
//        return [self loadBillTypeSignal];
//    }] subscribeError:^(NSError *error) {
//        [self.view ssj_hideLoadingIndicator];
//        [SSJAlertViewAdapter showError:error];
//    } completed:^{
//        [self.view ssj_hideLoadingIndicator];
//    }];
}


- (RACSignal *)merge {
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            RACSignal *sg_1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                [SSJBooksTypeStore queryForBooksListWithSuccess:^(NSMutableArray<SSJBooksTypeItem *> *bookList) {
//                    [subscriber sendNext:bookList];
//                    [subscriber sendCompleted];
//                } failure:^(NSError *error) {
//                    [subscriber sendError:error];
//                }];
//                return nil;
//            }];
//
//            RACSignal *sg_2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                [SSJBooksTypeStore queryForShareBooksListWithSuccess:^(NSMutableArray<SSJShareBookItem *> *result) {
//                    [subscriber sendNext:result];
//                    [subscriber sendCompleted];
//                } failure:^(NSError *error) {
//                    [SSJAlertViewAdapter showError:error];
//                }];
//                return nil;
//            }];
//
//            [self.booksItems removeAllObjects];
//            [[RACSignal merge:@[sg_1, sg_2]] subscribeNext:^(NSArray *booksItems) {
//                [self.booksItems addObjectsFromArray:booksItems];
//            } completed:^{
//                NSInteger selectedIndex = -1;
//                NSMutableArray *bookItems = [[NSMutableArray alloc] initWithCapacity:self.booksItems.count];
//                BOOL isSharedBook = NO;
//                for (int i = 0; i < self.booksItems.count; i ++) {
//                    NSObject<SSJBooksItemProtocol> *item = self.booksItems[i];
//                    NSString *iconName = nil;
//                    if ([item isKindOfClass:[SSJBooksTypeItem class]]) {
//                        iconName = @"record_making_private_book";
//                    } else if ([item isKindOfClass:[SSJShareBookItem class]]) {
//                        iconName = @"record_making_shared_book";
//                    }
//                    [bookItems addObject:[SSJRecordMakingCustomNavigationBarBookItem itemWithTitle:item.booksName iconName:iconName]];
//                    if ([item.booksId isEqualToString:self.item.booksId]) {
//                        selectedIndex = i;
//                        isSharedBook = [item isKindOfClass:[SSJShareBookItem class]];
//                    }
//                }
//
//                self.accessoryView.memberBtn.hidden = isSharedBook;
//                self.customNaviBar.bookItems = bookItems;
//                self.customNaviBar.selectedTitleIndex = selectedIndex;
//                if ((isSharedBook && self.chargeId.length)
//                    || bookItems.count <= 1) {
//                    self.customNaviBar.canSelectTitle = NO;
//                } else {
//                    self.customNaviBar.canSelectTitle = YES;
//                }
//                [subscriber sendNext:nil];
//                [subscriber sendCompleted];
//            }];
//
//            return nil;
//        }];
    
    
    
//    RACSignal *sg1 = RACObserve(self.operation, isReady);
//    RACSignal *sg2 = RACObserve(self.operation, isExecuting);
//    RACSignal *sg3 = RACObserve(self.operation, isFinished);
//    RACSignal *sg4 = RACObserve(self.operation, isCancelled);
//    @weakify(self);
//    [[RACSignal merge:@[sg1, sg2, sg3, sg4]] subscribeNext:^(id x) {
//        @strongify(self);
//        [self updateState];
//    }];
    
    return nil;
}


/**
 宏
 */
- (void)test2 {
//    [RACObserve(task, state) subscribeNext:^(id x) {
//        @strongify(self);
//        if ([x integerValue] == SSJDatabaseSequenceTaskStateFinished
//            || [x integerValue] == SSJDatabaseSequenceTaskStateCanceled) {
//            [self.lock lock];
//            [self.innerTasks removeObject:task];
//            [self.lock unlock];
//        }
//    }];
}

/// cell中调用多次问题rac_prepareForReuseSignal
///
//- (void)setCellItem:(__kindof SSJBaseCellItem *)cellItem {
//    if (![cellItem isKindOfClass:[SSJBaseCellItem class]]) {
//        return;
//    }
//
//    _cellItem = cellItem;
//
//    if ((NSInteger)cellItem.selectionStyle == SSJCellSelectionStyleUndefined) {
//        cellItem.selectionStyle = self.selectionStyle;
//    }
//    RAC(self, selectionStyle) = [RACObserve(cellItem, selectionStyle) takeUntil:self.rac_prepareForReuseSignal];
//
//    if ((NSInteger)cellItem.customAccessoryType == SSJTableViewCellAccessoryUndefined) {
//        cellItem.customAccessoryType = self.customAccessoryType;
//    }
//    RAC(self, customAccessoryType) = [RACObserve(cellItem, customAccessoryType) takeUntil:self.rac_prepareForReuseSignal];



//[[[cell.exchangeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
//
//}];

//}
//

/// cell中
//- (id)init {
//    if (self = [super init]) {
//        @weakify(self);
//        [RACObserve(self, viewModel) subscribeNext:^(HBItemViewModel *viewModel) {             @strongify(self);
//            self.username.text = viewModel.item.text;
//            [self.avatarImageView setImageWithURL: viewModel.item.avatarURL];
//            }];
//}             // 其他的一些设置

//RACSignal *imageAvailableSignal = [RACObserve(self, imageView.image) map:id^(id x){return x ? @YES : @NO}]; self.shareButton.rac_command = [[RACCommand alloc] initWithEnabled:imageAvailableSignal signalBlock:^RACSignal *(id input) {     // do share logic
//
//}];


//_twitterLoginCommand = [[RACCommand alloc] initWithSignalBlock:^(id _) {
//    @strongify(self);
//    return [[self twitterSignInSignal] takeUntil:self.cancelCommand.executionSignals];
//
//}];
//RAC(self.authenticatedUser) = [self.twitterLoginCommand.executionSignals switchToLatest];



/////////////////////////////////////////////////////////////////////////////////////////////////

//takeUntil:someSignal 的作用是当someSignal sendNext时，当前的signal就sendCompleted
//
//[[[cell.detailButton rac_signalForControlEvents:UIControlEventTouchUpInside]     takeUntil:cell.rac_prepareForReuseSignal]     subscribeNext:^(id x) {
//
//}];

//如果不加takeUntil:cell.rac_prepareForReuseSignal，那么每次Cell被重用时，该button都会被addTarget:selector。









//替换Delegate
//
//出现这种需求，通常是因为需要对Delegate的多个方法做统一的处理，这时就可以造一个signal出来，每次该Delegate的某些方法被触发时，该signal就会sendNext。
- (RACSignal *)rac_isActiveSignal {
//    self.delegate = self;
//    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
//    if (signal != nil) return signal;
//    /* Create two signals and merge them */
//    RACSignal *didBeginEditing = [[self rac_signalForSelector:@selector(searchDisplayControllerDidBeginSearch:)                                          fromProtocol:@protocol(UISearchDisplayDelegate)] mapReplace:@YES];
//    RACSignal *didEndEditing = [[self rac_signalForSelector:@selector(searchDisplayControllerDidEndSearch:)                                        fromProtocol:@protocol(UISearchDisplayDelegate)] mapReplace:@NO];     signal = [RACSignal merge:@[didBeginEditing, didEndEditing]];
//    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    return signal;
//
    return nil;
}



//[self.viewModel.testCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//    //x为网络请求的回调结果,可以在这里对x做处理,修改UI
//    NSLog(@"json = %@",x);
//}];

//distinctUntilChanged



@end







//弊端
//1、有时，我们想对selector的返回值做一些处理，但很遗憾RAC不支持，如果真的有需要的话，可以使用Aspects

//因为RAC很多操作都是在Block中完成的，这块最常见的问题就是在block直接把self拿来用，造成block和self的retain cycle。所以需要通过@strongify和@weakify来消除循环引用。
//
//2、有些地方很容易被忽略，比如RACObserve(thing, keypath)，看上去并没有引用self，所以在subscribeNext时就忘记了weakify/strongify。但事实上RACObserve总是会引用self，即使target不是self，所以只要有RACObserve的地方都要使用weakify/strongify。







//http://www.cocoachina.com/articles/8737

//坑
//https://www.cnblogs.com/guoxiaoqian/p/4691035.html

