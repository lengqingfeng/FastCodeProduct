//
//  FastCodeView.m
//  FastCodeProduct
//
//  Created by lsr on 2019/9/12.
//  Copyright © 2019 GJNativeTeam. All rights reserved.
//

#import "FastCodeView.h"
@interface FastCodeView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *lineViews;
@property (nonatomic, strong) NSMutableArray *cursorLines;
@property (nonatomic, strong) NSMutableArray *codeLabels;
@property (nonatomic, assign) BOOL isInputOver;
@property (nonatomic, copy) FastCodeDidSelectBlock selectCodeBlock;
@end

@implementation FastCodeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.isInputOver = NO;
    self.codeNumber = 6;
    self.style = kCodeStyleWithLine;
    self.squareBorderColor = [UIColor lightGrayColor];
    self.squareBorderWidth = 1;
    self.squareBorderHighlightColor = [UIColor redColor];
    self.lineWidth = 40;
    self.lineColor = [UIColor lightGrayColor];
    self.lineHighlightColor = [UIColor redColor];
    self.lineHeight = 1;
    self.codeFont = [UIFont systemFontOfSize:30];
    self.codeColor = [UIColor blackColor];
    self.cursorTopPadding = 15;
    self.cursorColor = [UIColor darkGrayColor];
    self.cursorWidth = 2;
}

- (void)showCodeView {
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:self.textField];
    [self beginEdit];
    [self setupInputUILayout];
}

//设置外观样式
- (void)setupInputUILayout {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = (width - self.lineWidth * self.codeNumber) / (self.codeNumber - 1);
    for (NSInteger i = 0; i < self.codeNumber; i++) {
        UIView *contentView = [[UIView alloc] init];
        CGFloat x = 0;
        if (i > 0) {
            x = (padding + self.lineWidth) * i;
        }
        contentView.frame = CGRectMake(x, 0, self.lineWidth, height);
        contentView.userInteractionEnabled = NO;
        contentView.tag = 100 + 1;
        [self addSubview:contentView];
      
        if (self.style == kCodeStyleWithLine) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, height - self.lineHeight, self.lineWidth, self.lineHeight);
            lineView.backgroundColor = self.lineColor;
            lineView.tag = 200 + 1;
            [contentView addSubview:lineView];
            [self.lineViews addObject:lineView];
        } else {
            contentView.layer.borderColor = self.squareBorderColor.CGColor;
            contentView.layer.borderWidth = self.squareBorderWidth;
            [self.lineViews addObject:contentView];
        }

        //显示code label
        UILabel *codeLabel = [[UILabel alloc] init];
        codeLabel.textColor = self.codeColor;
        codeLabel.frame = CGRectMake(0, 0, self.lineWidth, height);
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.font = self.codeFont;
        [contentView addSubview:codeLabel];
        [self.codeLabels addObject:codeLabel];
        
        //光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.lineWidth / self.cursorWidth, self.cursorTopPadding,self.cursorWidth, height - self.cursorTopPadding * 2)];
        CAShapeLayer *cursorLine = [CAShapeLayer layer];
        cursorLine.path = path.CGPath;
        cursorLine.fillColor = self.codeColor.CGColor;
        [contentView.layer addSublayer:cursorLine];
        if (i == 0) {
            [cursorLine addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            cursorLine.hidden = NO;
        } else {
            cursorLine.hidden = YES;
        }
        [self.cursorLines addObject:cursorLine];
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = [UIColor clearColor];
        [_textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventAllEvents];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.selectCodeBlock) {
        self.selectCodeBlock(textField.text);
    }
}

//监听文本变化
- (void)textFieldDidChange:(UITextField *)textField {
    NSString *textString = textField.text;
    if (textString.length > self.codeNumber) {
        textField.text = [textField.text substringToIndex:self.codeNumber];
    }
    //大于等于最大值时, 结束编辑
    if (textString.length >= self.codeNumber && !self.isInputOver) {
        self.isInputOver = YES;
        [self endEdit];
    }
    
    if (textString.length < self.codeNumber) {
        self.isInputOver = NO;
    }
    
    for (int i = 0; i < self.codeNumber; i++) {
        UIView *linView = self.lineViews[i];
        UILabel *codeLabel = self.codeLabels[i];
        if (i < textString.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            codeLabel.text = [textString substringWithRange:NSMakeRange(i, 1)];
            if (self.style == kCodeStyleWithLine) {
                linView.backgroundColor = self.lineHighlightColor;
            } else {
                linView.layer.borderColor = self.squareBorderHighlightColor.CGColor;
            }
        } else {
            [self changeViewLayerIndex:i linesHidden:i == textString.length ? NO : YES];
            if (!textString && textString.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            codeLabel.text = @"";
            if (self.style == kCodeStyleWithLine) {
                linView.backgroundColor = self.lineColor;
            } else {
                linView.layer.borderColor = self.squareBorderColor.CGColor;
            }

        }
    }
}

//开始编辑
- (void)beginEdit {
    [self.textField becomeFirstResponder];
}

//结束编辑
- (void)endEdit {
    [self.textField resignFirstResponder];
}

- (void)didSelectCode:(FastCodeDidSelectBlock)code {
    self.selectCodeBlock = code;
}

//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}

//设置光标动画
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    CAShapeLayer *line = self.cursorLines[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    } else {
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}

- (NSMutableArray *)lineViews {
    if (!_lineViews) {
        _lineViews = [NSMutableArray array];
    }
    return _lineViews;
}

- (NSMutableArray *)cursorLines {
    if (!_cursorLines) {
        _cursorLines = [NSMutableArray array];
    }
    return _cursorLines;
}

- (NSMutableArray *)codeLabels {
    if (!_codeLabels) {
        _codeLabels = [NSMutableArray array];
    }
    return _codeLabels;
}
@end
