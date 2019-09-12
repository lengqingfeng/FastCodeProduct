//
//  FastCodeView.h
//  FastCodeProduct
//
//  Created by lsr on 2019/9/12.
//  Copyright © 2019 GJNativeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FastCodeDidSelectBlock)(NSString * _Nullable code);

typedef NS_ENUM(NSInteger,kCodeStyle) {
    kCodeStyleWithLine,
    kCodeStyleWithSquare
};

NS_ASSUME_NONNULL_BEGIN
@interface FastCodeView : UIView
/**
 码的个数 默认6位
 */
@property (nonatomic, assign) NSInteger codeNumber;

/**
 显示样式 默认kCodeStyleWithLine
 */
@property (nonatomic, assign) kCodeStyle style;

/**
 底部线的颜色 默认 lightGrayColor
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 高亮颜色 默认 红色
 */
@property (nonatomic, strong) UIColor *lineHighlightColor;

/**
 线的宽度默认 40
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 线的高度度默认 1
 */
@property (nonatomic, assign) CGFloat lineHeight;

/**
 光标顶部距离 默认 15
 */
@property (nonatomic, assign) CGFloat cursorTopPadding;

/**
 光标颜色
 */
@property (nonatomic, strong) UIColor *cursorColor;

/**
 关闭宽度 默认 2
 */
@property (nonatomic, assign) CGFloat cursorWidth;

/**
 码的字体
 */
@property (nonatomic, strong) UIFont *codeFont;

/**
 码的颜色
 */
@property (nonatomic, strong) UIColor *codeColor;

/**
 边框颜色
 */
@property (nonatomic, strong) UIColor *squareBorderColor;

/**
 边框高亮颜色
 */
@property (nonatomic, strong) UIColor *squareBorderHighlightColor;

/**
 边框宽度 默认1
 */
@property (nonatomic, assign) CGFloat squareBorderWidth;

/**
 完成回到

 @param code 返回的码
 */
- (void)didSelectCode:(FastCodeDidSelectBlock)code;

/**
 设置完属性后调用 显示视图
 */
- (void)showCodeView;
@end

NS_ASSUME_NONNULL_END
