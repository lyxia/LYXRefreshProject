//
//  RefreshHeader.m
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import "RefreshHeader.h"

@interface RefreshHeader()

@end

@implementation RefreshHeader

- (void)pepare {
    CGRect frame = self.frame;
    frame.size.height = RefreshHeaderHeight;
    self.frame = frame;
    
    [self setBackgroundColor:[UIColor redColor]];
}

- (void)placeSubViews {
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    self.frame = frame;
}

- (void)contentOffsetChange {
    if (self.state == MJRefreshStateRefreshing) {
        CGFloat insetT = - self.scrollView.contentOffset.y > self.scrollViewOriginalInset.top ? - self.scrollView.contentOffset.y : self.scrollViewOriginalInset.top;
        insetT = insetT > self.frame.size.height + self.scrollViewOriginalInset.top ? self.frame.size.height + self.scrollViewOriginalInset.top : insetT;
        
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = insetT;
        self.scrollView.contentInset = inset;
        return;
    }
    
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    if (offsetY < happenOffsetY) {
        CGFloat height = self.frame.size.height;
        CGFloat normal2pullingOffsetY = happenOffsetY - height;
        if (self.scrollView.isDragging) {
            if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
                self.state = MJRefreshStatePulling;
            } else if(self.state == MJRefreshStatePulling && offsetY > normal2pullingOffsetY) {
                self.state = MJRefreshStateIdle;
            }
        } else if (self.state == MJRefreshStatePulling){
            [self beganRefresh];
        }
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshState oldState = self.state;
    if (state == oldState) return;
    [super setState:state];
    
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            //取消悬浮
            CGFloat insetTop = self.scrollViewOriginalInset.top;
            [UIView animateWithDuration:RefreshFastAnimalDuring animations:^{
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.top = insetTop;
                self.scrollView.contentInset = inset;
                [self.scrollView setContentOffset:CGPointMake(0, -insetTop) animated:NO];
            } completion:^(BOOL finished) {
                //回调
            }];
        }
    } else if (state == MJRefreshStateRefreshing) {
        //悬浮
        CGFloat insetTop = self.scrollViewOriginalInset.top + self.frame.size.height;
        [UIView animateWithDuration:RefreshFastAnimalDuring animations:^{
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top = insetTop;
            self.scrollView.contentInset = inset;
            [self.scrollView setContentOffset:CGPointMake(0, -insetTop) animated:NO];
        } completion:^(BOOL finished) {
            //执行回调
        }];
    }
}

@end
