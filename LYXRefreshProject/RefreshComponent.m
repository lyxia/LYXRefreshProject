//
//  RefreshComponent.m
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import "RefreshComponent.h"
#import <Masonry/Masonry.h>

@interface RefreshComponent()
@property (weak, nonatomic, readwrite) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *stateTf;
@property (nonatomic, strong) UIButton *end;
@end

@implementation RefreshComponent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.state = MJRefreshStateIdle;
        
        if ([self conformsToProtocol:@protocol(Refresh)]) {
            self.child = (id<Refresh>)self;
        }
        
        [self originalPepare];
    }
    return self;
}

- (void)originalPepare {
    
    [self addSubview:self.stateTf];
    [self.stateTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.end];
    [self.end mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    if ([self.child respondsToSelector:@selector(pepare)]) {
        [self.child pepare];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self removeObserver];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollViewOriginalInset = self.scrollView.contentInset;
        
        CGRect frame = self.frame;
        frame.size.width = newSuperview.frame.size.width;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addObserver];
    }
}

- (void)layoutSubviews {
    [self originalplaceSubViews];
    [super layoutSubviews];
}

- (void)originalplaceSubViews {
    if ([self.child respondsToSelector:@selector(placeSubViews)]) {
        [self.child placeSubViews];
    }
}

- (void)removeObserver {
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:RefreshKeyPathContentOffset];
        [self.scrollView removeObserver:self forKeyPath:RefreshKeyPathContentSize];
    }
}

- (void)addObserver {
    if (self.scrollView) {
        [self.scrollView addObserver:self forKeyPath:RefreshKeyPathContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.scrollView addObserver:self forKeyPath:RefreshKeyPathContentSize options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:RefreshKeyPathContentOffset]) {
        [self observeContentOffsetChange];
    }
    else if ([keyPath isEqualToString:RefreshKeyPathContentSize]) {
        [self observeContentSizeChange];
    }
}

- (void)observeContentOffsetChange {
    if ([self.child respondsToSelector:@selector(contentOffsetChange)]) {
        [self.child contentOffsetChange];
    }
}

- (void)observeContentSizeChange {
    if ([self.child respondsToSelector:@selector(contentSizeChange)]) {
        [self.child contentSizeChange];
    }
}

- (void)beganRefresh {
    if (self.window) {
        self.state = MJRefreshStateRefreshing;
    } else {
        self.state = MJRefreshStateWillRefresh;
    }
}

- (void)endRefresh {
    self.state = MJRefreshStateIdle;
}

- (void)setState:(MJRefreshState)state {
    _state = state;
    switch (state) {
        case MJRefreshStateIdle:
            self.stateTf.text = @"Idle";
            break;
        case MJRefreshStatePulling:
            self.stateTf.text = @"Pulling";
            break;
        case MJRefreshStateNoMoreData:
            self.stateTf.text = @"NoMoreData";
            break;
        case MJRefreshStateRefreshing:
            self.stateTf.text = @"Refreshing";
            break;
        case MJRefreshStateWillRefresh:
            self.stateTf.text = @"WillRefresh";
            break;
    }
}

- (UILabel *)stateTf {
    if (!_stateTf) {
        _stateTf = [[UILabel alloc] init];
        _stateTf.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stateTf;
}

- (UIButton *)end {
    if (!_end) {
        _end = [[UIButton alloc] init];
        _end.translatesAutoresizingMaskIntoConstraints = NO;
        [_end addTarget:self action:@selector(endRefresh) forControlEvents:UIControlEventTouchUpInside];
        [_end setTitle:@"endRefresh" forState:UIControlStateNormal];
    }
    return _end;
}

@end
