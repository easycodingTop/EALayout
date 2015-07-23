

#import "EAViewController.h"

NSString* EA_selfView               = @"selfView";
NSString* EA_tableView              = @"tableView";
NSString* EA_tableHeaderView        = @"tableHeaderView";
NSString* EA_contentView            = @"contentView";
NSString* EA_contentHeaderView      = @"contentHeaderView";
NSString* EA_bottomView             = @"bottomView";
NSString* EA_titleBgView            = @"titleBgView";
NSString* EA_titleLeftView          = @"titleLeftView";
NSString* EA_titleMiddleView        = @"titleMiddleView";
NSString* EA_titleRightView         = @"titleRightView";


@implementation EAViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ){
        _skinParser = [SkinParser getParserByName:NSStringFromClass([self class])];
        _skinParser.eventTarget = self;
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    [_skinParser parse:EA_selfView view:self.view];
    
    UIView* contentHeaderView = [_skinParser parse:EA_contentHeaderView];
    if(contentHeaderView) {
        [self.view addSubview:contentHeaderView];
    }
    self.contentHeaderLayoutView = contentHeaderView;
    
    UIView* contentView = [_skinParser parse:EA_contentView];
    if(contentView) {
        [self.view addSubview:contentView];
    }
    self.contentLayoutView = contentView;
    
    UIView* bottomView = [_skinParser parse:EA_bottomView];
    if(bottomView) {
        [self.view addSubview:bottomView];
    }
    self.bottomLayoutView = bottomView;
    
    [self updateTitleView:EUpdateAll];
}

-(void)viewDidLoad {
    [self.view spUpdateLayout];
    [self layoutSelfView];
    [self.view spUpdateLayout];
    if (_titleBgView) {
        [self.view bringSubviewToFront:_titleBgView];
    }
}

#if DEBUG
-(void)freshSkin{
    
#if TARGET_IPHONE_SIMULATOR
    
    self.view = [[UIView alloc] init];
    _skinParser = [SkinParser getParserByName:NSStringFromClass([self class])];
    _skinParser.eventTarget = self;
    [self loadView];
    [self viewDidLoad];
    
#else
    //真机上调试界面
    //            var ipfile = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("ip")
    //            var ipstr = NSString(contentsOfFile: ipfile, encoding: NSUTF8StringEncoding, error: nil)
    //            ipstr = ipstr?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\n "))
    //            var filepath = ipstr?.stringByAppendingFormat(":8000/%@.json", NSStringFromClass(self.classForCoder).componentsSeparatedByString(".").last!)
    //            var http = CurlHttp.get(filepath as! String, param: nil, cacheSec: 0)
    //            http.start(true, res: { (err, http, data) -> Void in
    //                if CURLE_OK.value == err.value && data != nil {
    //                    self.view = UIView()
    //                    self._skinParser = SkinParser.getParserByData(data)
    //                    self.loadView()
    //                    self.viewDidLoad()
    //                }
    //            })
    
#endif
    
}
#endif

-(void)updateTitleView {
    [self updateTitleView:EUpdateTitle];
}

-(void)updateTitleView:(NSInteger) mask {
    
    UIView* newTitleBgView = _titleBgView;
    
    if (EUpdateBg & mask) {
        newTitleBgView =  [self createTitleBgView];
        self.topLayoutView = newTitleBgView;
    }
    
    if (!newTitleBgView) {
        [_titleBgView removeFromSuperview];
        self.titleBgView = newTitleBgView;
        return;
    }
    
    if (newTitleBgView != _titleBgView) {
        if (_titleLeftView) {
            [newTitleBgView addSubview:_titleLeftView];
        }
        if (_titleMiddleView) {
            [newTitleBgView addSubview:_titleMiddleView];
        }
        if (_titleRightView) {
            [newTitleBgView addSubview:_titleRightView];
        }
        [_titleBgView removeFromSuperview];
        _titleBgView = newTitleBgView;
        [self.view addSubview:newTitleBgView];
    }
    
    if (EUpdateLeft & mask) {
        [_titleLeftView removeFromSuperview];
        _titleLeftView = [self createTitleLeftView];
        if (_titleLeftView) {
            [newTitleBgView addSubview:_titleLeftView];
        }
    }
    
    if (EUpdateRight & mask) {
        [_titleRightView removeFromSuperview];
        _titleRightView = [self createTitleRightView];
        if (_titleRightView) {
            [newTitleBgView addSubview:_titleRightView];
        }
    }
    
    if (EUpdateMiddle & mask) {
        [_titleMiddleView removeFromSuperview];
        _titleMiddleView = [self createTitleMiddleView];
        if (_titleMiddleView) {
            [newTitleBgView addSubview:_titleMiddleView];
        }
        mask |= EUpdateTitle;
    }
    
    if (EUpdateTitle & mask) {
        NSString* textTitle = [self getTitle];
        if (textTitle) {
            if([_titleMiddleView isKindOfClass:[UILabel class]]){
                [(UILabel*)_titleMiddleView setText:textTitle];
            }
        }
        [_titleBgView spUpdateLayout];
    }
}

-(NSString*)getTitle {
    return self.title;
}

-(UIView*)createTitleBgView {
    return [_skinParser parse:EA_titleBgView];
}

-(UIView*)createTitleLeftView {
    return [_skinParser parse:EA_titleLeftView];
}

-(UIView*)createTitleMiddleView {
    return [_skinParser parse:EA_titleMiddleView];
}

-(UIView*)createTitleRightView {
    return [_skinParser parse:EA_titleRightView];
}


//MARK:Layout controller views
-(void)setTopLayoutView:(UIView *)topLayoutView {
    if(topLayoutView != _topLayoutView) {
        _topLayoutView = topLayoutView;
        [self layoutSelfView];
    }
}

-(void)setContentHeaderLayoutView:(UIView *)contentHeaderLayoutView {
    if(contentHeaderLayoutView != _contentHeaderLayoutView) {
        _contentHeaderLayoutView = contentHeaderLayoutView;
        [self layoutSelfView];
    }
}

-(void)setContentLayoutView:(UIView *)contentLayoutView {
    if(contentLayoutView != _contentLayoutView) {
        _contentLayoutView = contentLayoutView;
        [self layoutSelfView];
    }
}

-(void)setBottomLayoutView:(UIView *)bottomLayoutView {
    if(bottomLayoutView != _bottomLayoutView) {
        _bottomLayoutView = bottomLayoutView;
        [self layoutSelfView];
    }
}


-(void)layoutSelfView {
    CGRect bound = self.view.bounds;
    CGRect topFrame = CGRectZero;
    if(_topLayoutView) {
        topFrame = _topLayoutView.frame;
        topFrame.origin.y = 0;
        _topLayoutView.frame = topFrame;
        ViewLayoutDes* layoutDes = [_topLayoutView createViewLayoutDesIfNil];
        [layoutDes setTop:0 forTag:0];
    }
    
    CGRect contentHeaderFrame = CGRectZero;
    if (_contentHeaderLayoutView) {
        contentHeaderFrame = _contentHeaderLayoutView.frame;
        contentHeaderFrame.origin.y = CGRectGetMaxY(topFrame);
        ViewLayoutDes* layoutDes = [_contentHeaderLayoutView createViewLayoutDesIfNil];
        
        if ([layoutDes styleTypeByTag:0 ] & ELayoutTop) {
            contentHeaderFrame.origin.y = [layoutDes topByTag:0];
        } else {
            [layoutDes setTop:contentHeaderFrame.origin.y forTag: 0];
        }
        _contentHeaderLayoutView.frame = contentHeaderFrame;
    }
    
    CGRect bottomFrame = CGRectZero;
    if (_bottomLayoutView) {
        [_bottomLayoutView calcHeight];
        bottomFrame = _bottomLayoutView.frame;
        bottomFrame.origin.y = CGRectGetHeight(bound) - CGRectGetHeight(bottomFrame);
        _bottomLayoutView.frame = bottomFrame;
        ViewLayoutDes* layoutDes = [_bottomLayoutView createViewLayoutDesIfNil];
        [layoutDes setBottom:0 forTag: 0];
    }
    
    CGRect contentFrame = CGRectZero;
    if (_contentLayoutView) {
        contentFrame = _contentLayoutView.frame;
        contentFrame.origin.y = CGRectGetMaxY(topFrame) + CGRectGetHeight(contentHeaderFrame);
        contentFrame.size.height =
        CGRectGetHeight(bound) - CGRectGetHeight(topFrame) - CGRectGetHeight(bottomFrame) - CGRectGetHeight(contentHeaderFrame);
        
        ViewLayoutDes* layoutDes = [_contentLayoutView createViewLayoutDesIfNil];
        
        if ([layoutDes styleTypeByTag:0] & ELayoutTop) {
            contentFrame.origin.y = [layoutDes topByTag:0];
        } else {
            [layoutDes setTop:contentFrame.origin.y forTag: 0];
        }
        
        if ([layoutDes styleTypeByTag:0] & ELayoutBottom) {
            contentFrame.size.height = CGRectGetHeight(bound) - [layoutDes topByTag:0] - [layoutDes bottomByTag:0];
        }
        _contentLayoutView.frame = contentFrame;
    }
    
    
    for (EAViewController* childViewControler in self.childViewControllers){
        if ([childViewControler isKindOfClass:[EAViewController class]]) {
            [childViewControler layoutSelfView];
        }
    }
}
@end







