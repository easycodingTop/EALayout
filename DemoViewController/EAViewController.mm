

#import "EAViewController.h"
#import "EATableViewCell.h"

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

@interface EAViewController()

@property (nonatomic, strong) NSMutableDictionary* cacheViews;

@end


@implementation EAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    return self;
}

- (SkinParser*)skinParser
{
    if(!_skinParser)
    {
        if(!_skinFileName.length)
        {
            _skinFileName = NSStringFromClass([self class]);
        }
        SkinParser* skinParser = [SkinParser getParserByName:_skinFileName];
        skinParser.eventTarget = self;
        _skinParser = skinParser;
    }
    return _skinParser;
}

- (void)loadView
{
    [super loadView];
    [self.skinParser parse:EA_selfView view:self.view];
    
    UIView* contentHeaderView = [self.skinParser parse:EA_contentHeaderView];
    if(contentHeaderView)
    {
        [self.view addSubview:contentHeaderView];
    }
    self.contentHeaderLayoutView = contentHeaderView;
    
    UIView* contentView = [self.skinParser parse:EA_contentView];
    if(contentView)
    {
        [self.view addSubview:contentView];
    }
    self.contentLayoutView = contentView;
    
    UIView* bottomView = [self.skinParser parse:EA_bottomView];
    if(bottomView)
    {
        [self.view addSubview:bottomView];
    }
    self.bottomLayoutView = bottomView;
    
    [self updateTitleView:EUpdateAll];
    
    [self createTableView];
}

- (void)viewDidLoad
{
    [self.view spUpdateLayout];
    [self layoutSelfView];
    [self.view spUpdateLayout];
    if (_titleBgView)
    {
        [self.view bringSubviewToFront:_titleBgView];
    }
}

#if DEBUG
- (void)freshSkin
{
#if TARGET_IPHONE_SIMULATOR
    
    self.view = [[UIView alloc] init];
    self.skinParser = nil;
    [self loadView];
    [self viewDidLoad];
    
#else
    //真机上调试界面
    NSString* ipfile = [[NSBundle mainBundle].resourcePath stringByAppendingString:@"/ip"];
    NSString* ipstr = [NSString stringWithContentsOfFile:ipfile encoding:(NSUTF8StringEncoding) error:nil];
    ipstr = [ipstr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    NSString* filepath = [ipstr stringByAppendingFormat:@":8000/%@.json", NSStringFromClass([self class])];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", filepath]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SkinParser* skinParser = [SkinParser getParserByData:received];
            if(skinParser)
            {
                self.skinParser = skinParser;
                [self loadView];
                [self viewDidLoad];
            }
            
            for (EAViewController* childViewControler in self.childViewControllers)
            {
                if ([childViewControler isKindOfClass:[EAViewController class]])
                {
                    [childViewControler freshSkin];
                }
            }
        });
        
    });
#endif
    
}
#endif

- (void)updateTitleView
{
    [self updateTitleView:EUpdateTitle];
}

- (void)updateTitleView:(NSInteger) mask
{
    UIView* newTitleBgView = _titleBgView;
    
    if (EUpdateBg & mask)
    {
        newTitleBgView =  [self createTitleBgView];
        self.topLayoutView = newTitleBgView;
    }
    
    if (!newTitleBgView)
    {
        [_titleBgView removeFromSuperview];
        self.titleBgView = newTitleBgView;
        return;
    }
    
    if (newTitleBgView != _titleBgView)
    {
        if (_titleLeftView)
        {
            [newTitleBgView addSubview:_titleLeftView];
        }
        
        if (_titleMiddleView)
        {
            [newTitleBgView addSubview:_titleMiddleView];
        }
        
        if (_titleRightView)
        {
            [newTitleBgView addSubview:_titleRightView];
        }
        [_titleBgView removeFromSuperview];
        _titleBgView = newTitleBgView;
        [self.view addSubview:newTitleBgView];
    }
    
    if (EUpdateLeft & mask)
    {
        [_titleLeftView removeFromSuperview];
        _titleLeftView = [self createTitleLeftView];
        if (_titleLeftView)
        {
            [newTitleBgView addSubview:_titleLeftView];
        }
    }
    
    if (EUpdateRight & mask)
    {
        [_titleRightView removeFromSuperview];
        _titleRightView = [self createTitleRightView];
        if (_titleRightView)
        {
            [newTitleBgView addSubview:_titleRightView];
        }
    }
    
    if (EUpdateMiddle & mask)
    {
        [_titleMiddleView removeFromSuperview];
        _titleMiddleView = [self createTitleMiddleView];
        if (_titleMiddleView)
        {
            [newTitleBgView addSubview:_titleMiddleView];
        }
        mask |= EUpdateTitle;
    }
    
    if (EUpdateTitle & mask)
    {
        NSString* textTitle = [self getTitle];
        if (textTitle)
        {
            if([_titleMiddleView isKindOfClass:[UILabel class]])
            {
                [(UILabel*)_titleMiddleView setText:textTitle];
            }
        }
        [_titleBgView spUpdateLayout];
    }
}

- (NSString*)getTitle
{
    return self.title;
}

- (UIView*)createTitleBgView
{
    return [self.skinParser parse:EA_titleBgView];
}

- (UIView*)createTitleLeftView
{
    return [self.skinParser parse:EA_titleLeftView];
}

- (UIView*)createTitleMiddleView
{
    return [self.skinParser parse:EA_titleMiddleView];
}

- (UIView*)createTitleRightView
{
    return [self.skinParser parse:EA_titleRightView];
}

//MARK:Layout controller views
- (void)setTopLayoutView:(UIView *)topLayoutView
{
    if(topLayoutView != _topLayoutView)
    {
        _topLayoutView = topLayoutView;
        [self layoutSelfView];
    }
}

- (void)setContentHeaderLayoutView:(UIView *)contentHeaderLayoutView
{
    if(contentHeaderLayoutView != _contentHeaderLayoutView)
    {
        _contentHeaderLayoutView = contentHeaderLayoutView;
        [self layoutSelfView];
    }
}

- (void)setContentLayoutView:(UIView *)contentLayoutView
{
    if(contentLayoutView != _contentLayoutView)
    {
        _contentLayoutView = contentLayoutView;
        [self layoutSelfView];
    }
}

- (void)setBottomLayoutView:(UIView *)bottomLayoutView
{
    if(bottomLayoutView != _bottomLayoutView)
    {
        _bottomLayoutView = bottomLayoutView;
        [self layoutSelfView];
    }
}


- (void)layoutSelfView
{
    CGRect bound = self.view.bounds;
    CGRect topFrame = CGRectZero;
    if(_topLayoutView)
    {
        topFrame = _topLayoutView.frame;
        topFrame.origin.y = 0;
        _topLayoutView.frame = topFrame;
        ViewLayoutDes* layoutDes = [_topLayoutView createViewLayoutDesIfNil];
        [layoutDes setTop:0 forTag:0];
    }
    
    CGRect contentHeaderFrame = CGRectZero;
    if (_contentHeaderLayoutView)
    {
        contentHeaderFrame = _contentHeaderLayoutView.frame;
        contentHeaderFrame.origin.y = CGRectGetMaxY(topFrame);
        ViewLayoutDes* layoutDes = [_contentHeaderLayoutView createViewLayoutDesIfNil];
        
        if ([layoutDes styleTypeByTag:0 ] & ELayoutTop)
        {
            contentHeaderFrame.origin.y = [layoutDes topByTag:0];
        }
        else
        {
            [layoutDes setTop:contentHeaderFrame.origin.y forTag: 0];
        }
        _contentHeaderLayoutView.frame = contentHeaderFrame;
    }
    
    CGRect bottomFrame = CGRectZero;
    if (_bottomLayoutView)
    {
        [_bottomLayoutView calcHeight];
        bottomFrame = _bottomLayoutView.frame;
        bottomFrame.origin.y = CGRectGetHeight(bound) - CGRectGetHeight(bottomFrame);
        _bottomLayoutView.frame = bottomFrame;
        ViewLayoutDes* layoutDes = [_bottomLayoutView createViewLayoutDesIfNil];
        [layoutDes setBottom:0 forTag: 0];
    }
    
    CGRect contentFrame = CGRectZero;
    if (_contentLayoutView)
    {
        contentFrame = _contentLayoutView.frame;
        contentFrame.origin.y = CGRectGetMaxY(topFrame) + CGRectGetHeight(contentHeaderFrame);
        contentFrame.size.height =
        CGRectGetHeight(bound) - CGRectGetHeight(topFrame) - CGRectGetHeight(bottomFrame) - CGRectGetHeight(contentHeaderFrame);
        
        ViewLayoutDes* layoutDes = [_contentLayoutView createViewLayoutDesIfNil];
        
        if ([layoutDes styleTypeByTag:0] & ELayoutTop)
        {
            contentFrame.origin.y = [layoutDes topByTag:0];
        }
        else
        {
            [layoutDes setTop:contentFrame.origin.y forTag: 0];
        }
        
        if ([layoutDes styleTypeByTag:0] & ELayoutBottom)
        {
            contentFrame.size.height = CGRectGetHeight(bound) - [layoutDes topByTag:0] - [layoutDes bottomByTag:0];
        }
        _contentLayoutView.frame = contentFrame;
    }
    
    
    for (EAViewController* childViewControler in self.childViewControllers)
    {
        if ([childViewControler isKindOfClass:[EAViewController class]])
        {
            [childViewControler layoutSelfView];
        }
    }
}

- (NSMutableDictionary*)cacheViews
{
    if(!_cacheViews)
    {
        _cacheViews = [NSMutableDictionary dictionary];
    }
    return _cacheViews;
}

- (UITableView*) createTableView
{
    _tableView = (UITableView*)[self.skinParser parse:EA_tableView];
    [self.contentLayoutView removeFromSuperview];
    self.contentLayoutView = _tableView;
    if(_tableView)
    {
        [self.view addSubview:_tableView];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView* headerView = [self.skinParser parse:EA_tableHeaderView];
    [self resetTableHeaderView:headerView];
    return _tableView;
}

- (void)resetTableHeaderView:(UIView*)tableHeaderView
{
    CGRect rect = self.view.frame;
    tableHeaderView.frame = rect;
    [tableHeaderView spUpdateLayout];
    [tableHeaderView calcHeight];
    [tableHeaderView spUpdateLayout];
    _tableView.tableHeaderView = nil;
    _tableView.tableHeaderView = tableHeaderView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self createCell:@"cell"];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)createCell:(NSString*)identifier
{
    return [self createCell:identifier created:nil];
}

- (UITableViewCell*)createCell:(NSString*)identifier created:(void (^)(UITableViewCell* cell)) created
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[EATableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.skinParser parse:identifier view:cell];
        if(created)
        {
            created(cell);
        }
    }
    return cell;
}

- (UITableViewCell*)createCacheCell:(NSString*)identifier
{
    NSString* dentifier_cache = [identifier stringByAppendingString:@"_cache"];
    UITableViewCell* cacheView = (UITableViewCell*)self.cacheViews[dentifier_cache];
    
    if (!cacheView)
    {
        cacheView = [_tableView dequeueReusableCellWithIdentifier:(NSString*)dentifier_cache];
        if (!cacheView)
        {
            cacheView = [[EATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifier_cache];
            [self.skinParser parse:identifier view:cacheView];
        }
        cacheView.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cacheViews[dentifier_cache] = cacheView;
    }
    return cacheView;
}

@end
