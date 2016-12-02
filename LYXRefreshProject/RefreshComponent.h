//
//  RefreshComponent.h
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshConfig.h"

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, MJRefreshState) {
    /** 普通闲置状态 */
    MJRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    MJRefreshStatePulling,
    /** 正在刷新中的状态 */
    MJRefreshStateRefreshing,
    /** 即将刷新的状态 */
    MJRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    MJRefreshStateNoMoreData
};

@protocol Refresh <NSObject>

@optional
- (void)pepare;
- (void)contentOffsetChange;
- (void)contentSizeChange;
- (void)placeSubViews;

@end

@interface RefreshComponent : UIView

@property (nonatomic, weak) NSObject<Refresh> *child;
@property (assign, nonatomic) MJRefreshState state;

@property (weak, nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

- (void)beganRefresh;
- (void)endRefresh;

@end
