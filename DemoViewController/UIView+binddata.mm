


/********************** 绑定基本数据到对象 *********************************/

//MARK: 绑定view最常用数据 UIView(bindData)

#import "UIView+binddata.h"
#import <EALayout/EALayout.h>

@implementation UIView(bindData)


-(void)bindData:(id)data {
    if( [self isKindOfClass:[UILabel class]] ){
        [self bindForUILabel:data];
    } else if( [self isKindOfClass:[UIImageView class]] ){
        [self bindForUIImageView:data];
    } else if( [self isKindOfClass:[UIButton class]] ){
        [self bindForUIButton:data];
    }
}

-(void)bindForUILabel:(id)data {
    data = data ?: @"";
    if ( [data isKindOfClass:[NSString class]] ){
        [(UILabel*)self setText:(NSString*)data];
    }
}

-(void)bindForUIImageView:(id)data {
    if (!data || [data isKindOfClass:[UIImage class]] ){
        [(UIImageView*)self setImage:(UIImage*)data];
    }
}

-(void)bindForUIButton:(id)data {
    if( [data isKindOfClass:[NSString class]] ){
        [(UIButton*)self setTitle:(NSString*)data forState:UIControlStateNormal];
    } else if(!data || [data isKindOfClass:[UIImage class]] ){
        [(UIButton*)self setImage:(UIImage*)data forState:UIControlStateNormal];
    }
}

-(UIView*)bindByTag:(NSInteger)tag data:(id)data {
    UIView* subView = [self viewWithTag:tag];
    [subView bindData:data];
    return subView;
}

-(UIView*)bindByStrTag:(NSString*)tag data:(id)data {
    UIView* subView = [self viewWithStrTag:tag];
    [subView bindData:data];
    return subView;
}

@end
