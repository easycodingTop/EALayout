

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LayoutTypeDef.h"

@interface BaseLayouter : UIView

/*
 Layouter里的所有views
 */
@property (nonatomic, strong) NSMutableArray* layoutViews;
/*
 Layouter所在父view顺序位置
 */
@property (nonatomic, readonly) NSInteger indexOfSubview;

/*
 在解析皮肤时，会按皮肤里定义顺序添加view
 */
-(void)addSubview:(UIView*)view;

/*
 在普通layout开始前调用
 */
-(void)willLayoutView:(UIView*)view;

/*
 在布局时会顺序调用该方法，通常在view与 layoutViews.lastObject相等时，便可以开始进行最终布局
 */
-(BOOL)didLayoutView:(UIView*)view;

@end

