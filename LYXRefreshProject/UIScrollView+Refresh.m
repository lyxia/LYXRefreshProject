//
//  UIScrollView+Refresh.m
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)

static const char RefreshHeaderKey = '\0';
- (void)setRe_header:(RefreshComponent *)re_header {
    if (self.re_header != re_header) {
        [self.re_header removeFromSuperview];
        [self insertSubview:re_header atIndex:0];
        
        objc_setAssociatedObject(self, &RefreshHeaderKey, re_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshComponent *)re_header {
    return objc_getAssociatedObject(self, &RefreshHeaderKey);
}

static const char RefreshFooterKey = '\0';
- (void)setRe_footer:(RefreshComponent *)re_footer{
    if (self.re_footer != re_footer) {
        [self.re_footer removeFromSuperview];
        [self insertSubview:re_footer atIndex:0];
        
        objc_setAssociatedObject(self, &RefreshFooterKey, re_footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshComponent *)re_footer {
    return objc_getAssociatedObject(self, &RefreshFooterKey);
}

@end
