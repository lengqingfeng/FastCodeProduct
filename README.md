# FastCodeProduct
验证码填充

## Installation
 pod 'FastCodeView' 
 
## Usage
  ~~~
    CGRect codeFrame = CGRectMake(15, 160,self.view.frame.size.width - 30, 60);
    FastCodeView *codeView = [[FastCodeView alloc] initWithFrame:codeFrame];
    [codeView showCodeView];
    [codeView didSelectCode:^(NSString * _Nullable code) {
        NSLog(@"code======%@",code);
    }];
   ~~~
![](http://wx1.sinaimg.cn/mw690/006Fw6Kwly1g6wvvnu6pfj30j404qglo.jpg)


![](http://wx3.sinaimg.cn/mw690/006Fw6Kwly1g6wvy142mfj30j6066jrn.jpg)
