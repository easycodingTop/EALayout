

#import <UIKit/UIKit.h>

@class ViewLayoutDes;

@interface UIView(UIView_Layout)

/*********************** 布局对象 **************************************/
/**
 *  @param layouter 布局描述对象
 */
-(void)setViewLayoutDes:(ViewLayoutDes*)viewLayoutDes;

/**
 *  @param 获取对象描述对象
 */
-(ViewLayoutDes*)getViewLayoutDes;

/**
 * @brief 获取layoutDes, 没有就创建
 */
-(ViewLayoutDes*)createViewLayoutDesIfNil;


@end

@interface UIView(SPAutoLayout)

/**
 *  @brief 重新布局当前view的 subviews. 因此修改某view,应该当调用该view的superview些方法
        在修改了控件某属性后，需要调用该控件，
        对于cell, 则通过重写 layoutSubviews来自动调用该方法
 */
-(void)spUpdateLayout;

/**
 * 自动计算宽度，需要提供最大宽度，会自动计算一个合理的宽度
 */
-(void)calcWidth : (CGFloat (^)())getMaxWidth;

/**
 * 自动计算高度
 */
-(void)calcHeight;

@end


