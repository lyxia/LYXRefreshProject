//
//  RefreshFooter.m
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import "RefreshFooter.h"

@implementation RefreshFooter

- (void)pepare {
    CGRect frame = self.frame;
    frame.size.height = RefreshFooterHeight;
    self.frame = frame;
    
    self.backgroundColor = [UIColor blueColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview: newSuperview];
    
    [self contentSizeChange];
}

- (void)contentSizeChange {

    CGFloat contentHeight = self.scrollView.contentSize.height;
    CGFloat scrollHeight = self.scrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    
    CGFloat y = MAX(contentHeight, scrollHeight);
    
    // 设置位置和尺寸
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
    NSLog(@"scrollHeight: %f", y);
}

- (void)contentOffsetChange {
    // 如果正在刷新，直接返回
    if (self.state == MJRefreshStateRefreshing) return;
    
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    NSLog(@"offsetChange %f", self.scrollViewOriginalInset.bottom);
    
    CGFloat happenOffsetY = [self happenOffsetY];
    CGFloat offsetY = self.scrollView.contentOffset.y;
    if (offsetY > happenOffsetY) {
        if (self.scrollView.dragging) {
            CGFloat normal2pullingOffsetY = happenOffsetY + self.frame.size.height;
            if (self.state == MJRefreshStateIdle && offsetY > normal2pullingOffsetY) {
                self.state = MJRefreshStatePulling;
            } else if (self.state == MJRefreshStatePulling && offsetY <= normal2pullingOffsetY) {
                self.state = MJRefreshStateIdle;
            }
        } else {
            if (self.state == MJRefreshStatePulling) {
                [self beganRefresh];
            }
        }
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshState oldState = self.state;
    if (state == oldState) return;
    [super setState:state];
    
    if (state == MJRefreshStateRefreshing) {
        [UIView animateWithDuration:RefreshFastAnimalDuring animations:^{
            CGFloat bottom = self.frame.size.height + self.scrollViewOriginalInset.bottom;
            
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            
            CGPoint offset = self.scrollView.contentOffset;
            offset.y = [self happenOffsetY] + self.frame.size.height;
            self.scrollView.contentOffset = offset;
            
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.bottom = bottom;
            self.scrollView.contentInset = inset;
        } completion:^(BOOL finished) {
            //回调
        }];
    } else if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            [UIView animateWithDuration:RefreshFastAnimalDuring animations:^{
                CGFloat bottom = self.scrollViewOriginalInset.bottom;
                NSLog(@"idle to refreshing %f", bottom);
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = [self happenOffsetY] + self.frame.size.height;
                self.scrollView.contentOffset = offset;
                
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.bottom = bottom;
                self.scrollView.contentInset = inset;
            } completion:^(BOOL finished) {
                //回调
            }];
        }
    }
}

- (void)setScrollViewOriginalInset:(UIEdgeInsets)scrollViewOriginalInset {
    [super setScrollViewOriginalInset:scrollViewOriginalInset];
    
    NSLog(@"修改 -- %f", scrollViewOriginalInset.bottom);
    if (scrollViewOriginalInset.bottom > 90) {
        NSLog(@"---");
    }
}

- (CGFloat)heightForContentBreakView {
    CGFloat scrollHeight = self.scrollView.frame.size.height;
    CGFloat showHeight = scrollHeight - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    CGFloat scrollContentHeight = self.scrollView.contentSize.height;
    CGFloat deltaH = scrollContentHeight - showHeight;
    return deltaH;
}

- (CGFloat)happenOffsetY {
    CGFloat deltaH = [self heightForContentBreakView];
    CGFloat happenOffsetY;
    if (deltaH > 0) {
        happenOffsetY = deltaH - self.scrollViewOriginalInset.top;
    } else {
        happenOffsetY = -self.scrollViewOriginalInset.top;
    }
    return happenOffsetY;
}

@end
