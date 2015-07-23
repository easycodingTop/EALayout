


/********************** 绑定基本数据到对象 *********************************/

//MARK: 绑定view最常用数据 UIView(bindData)

@interface UIView(bindData)

-(void)bindData:(id)data;

-(void)bindForUILabel:(id)data;

-(void)bindForUIImageView:(id)data;

-(void)bindForUIButton:(id)data;

-(UIView*)bindByTag:(NSInteger)tag data:(id)data;

-(UIView*)bindByStrTag:(NSString*)tag data:(id)data;

@end



