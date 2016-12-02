//
//  UIScrollView+Refresh.h
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshComponent.h"

@interface UIScrollView (Refresh)

@property (nonatomic, strong) RefreshComponent *re_header;
@property (nonatomic, strong) RefreshComponent *re_footer;

@end
