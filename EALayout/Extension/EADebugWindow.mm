
//  此文件只是用于DEBUG，主要是用来控制实时刷新的开关操作。

#if DEBUG

#import "EADebugWindow.h"
#import "EAViewController.h"

@implementation EADebugWindow
{
    NSTimer* timer;
    BOOL _debugSkin;
}

+ (instancetype)createDebugWindow
{
    static dispatch_once_t pred = 0;
    static EADebugWindow *debugWindow = nil;
    dispatch_once(&pred, ^{
        debugWindow = [[EADebugWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    });
    return debugWindow;
}

- (void)setSkinPath:(NSString*)relativePath absolutePath:(NSString*)absolutePath
{
    NSString* skinPath = [absolutePath stringByAppendingPathComponent:relativePath];
    [SkinMgr sharedInstance].rootPath = skinPath;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)])
    {
        UIViewController* vc = [UIViewController new];
        self.rootViewController = vc;
        
        UIButton* button = [[UIButton alloc] initWithFrame:self.bounds];
        [button addTarget:self action:@selector(switchSkinDebug:) forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:button];
        button.tag = 8001;
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.userInteractionEnabled = true;
        self.windowLevel = 2000;
        
        UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        [button1 setTitle:@"自动刷新" forState:(UIControlStateNormal)];
        [button1 setTitle:@"关闭刷新" forState:(UIControlStateSelected)];
        [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button1 addTarget:self action:@selector(switchRefresh:) forControlEvents:UIControlEventTouchUpInside];
        button1.backgroundColor = [UIColor greenColor];
        [button addSubview:button1];
        button1.hidden = true;
        button1.tag = 81001;
        
        UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 80, 20)];
        [button2 setTitle:@"刷一下" forState:(UIControlStateNormal)];
        [button2 addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        button2.backgroundColor = [UIColor blueColor];
        [button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button addSubview:button2];
        button2.hidden = true;
        button2.tag = 81002;
        
        UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
        [vc.view addSubview:label];
        label.textColor = [UIColor blackColor];
        label.text = @"1";
        label.tag = 7001;
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentRight;
        timer = nil;
        button.selected = YES;
        [self switchSkinDebug:button];
    }
    return self;
}

- (void)switchRefresh:(UIButton*)button
{
    button.selected = !button.selected;
    if(button.selected) {
        _debugSkin = YES;
        [self autoRefresh];
        [self viewWithTag:81002].hidden = YES;
    } else {
        _debugSkin = NO;
        [self autoRefresh];
        [self viewWithTag:81002].hidden = NO;
    }
}

- (void)refresh:(UIButton*)button
{
    button.selected = !button.selected;
    _debugSkin = button.selected;
    [self tick];
    UILabel* label = (UILabel*)[self viewWithTag:7001];
    NSInteger value = label.text.integerValue + 1;
    label.text = @(value).stringValue;
}

- (void)switchSkinDebug:(UIButton*)button
{
    button.selected = !button.selected;
    if(button.selected)
    {
        self.backgroundColor = [UIColor yellowColor];
        [button viewWithTag:81001].hidden = NO;
        [button viewWithTag:81002].hidden = NO;
        [self viewWithTag:7001].hidden = NO;
    }
    else
    {
        self.backgroundColor = nil;
        [button viewWithTag:81001].hidden = YES;
        [button viewWithTag:81002].hidden = YES;
        ((UIButton*)[button viewWithTag:81001]).selected = NO;
        [self viewWithTag:7001].hidden = YES;
    }
    _debugSkin = NO;
    [self autoRefresh];
}

- (void)autoRefresh
{
    if ( _debugSkin )
    {
        if (nil == timer)
        {
            NSTimeInterval ds = 1;
            timer = [NSTimer scheduledTimerWithTimeInterval:ds target:self selector:@selector(tick) userInfo:nil repeats:YES];
        }
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)tick
{
    if ( _debugSkin )
    {
        UIViewController* rootVC = [[UIApplication sharedApplication].windows[0] rootViewController];
        if( [rootVC isKindOfClass:[UINavigationController class]])
        {
            [[((UINavigationController*)rootVC) topViewController] performSelector:@selector(freshSkin)];
        }
        else
        {
            [rootVC  performSelector:@selector(freshSkin)];
        }
    }
}

@end

#endif //DEBUG

