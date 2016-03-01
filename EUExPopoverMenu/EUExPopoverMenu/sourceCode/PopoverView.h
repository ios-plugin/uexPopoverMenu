//
//  PopoverView.h
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//



#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, Direction) {
    LeftTop,//0
    RightTop,//1
    LeftBottom,//2
    RightBottom//3
    
};
@interface PopoverView : UIView

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images Direction:(Direction)direction textSize:(CGFloat)textSize backgroundColor:(UIColor *)bgColor
      dividerColor:(UIColor *)dividerColor textColor:(UIColor *)textColor;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);
@property (nonatomic,strong) UIImageView* imageView;
@property(nonatomic,assign) Direction direction;
@end
