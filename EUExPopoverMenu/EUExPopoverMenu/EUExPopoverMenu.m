//
//  EUExPopoverMenu.m
//  EUExPopoverMenu
//
//  Created by 杨广 on 16/1/19.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExPopoverMenu.h"
#import <UIKit/UIKit.h>
#import "EUtility.h"
#import "JSON.h"
#import "PopoverView.h"
@interface EUExPopoverMenu()
@property(nonatomic,strong) UIButton *containerButton;
@property (nonatomic, copy) UIColor *borderColor;


@end
@implementation EUExPopoverMenu
-(id)initWithBrwView:(EBrowserView *) eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        
    }
    return self;
}


-(void)openPopoverMenu:(NSMutableArray *)inArguments {
    
    
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr JSONValue];//将JSON类型的字符串转化为可变字典
        
    }else{
        return;
    }
    float x = [[self.jsonDict objectForKey:@"x"] floatValue];
    float y = [[self.jsonDict objectForKey:@"y"] floatValue];
    float direction = [[self.jsonDict objectForKey:@"direction"] floatValue];
    
    float textSize ;
    if (self.jsonDict[@"textSize"] == nil) {
        textSize = [EUtility screenWidth]*0.042;
    }else{
        textSize = [self.jsonDict[@"textSize"] floatValue];
    }
    
    UIColor *bgColor;
    if (self.jsonDict[@"bgColor"] == nil) {
        bgColor = [EUtility ColorFromString:@"#393A3F"];
    }else{
        bgColor = [EUtility ColorFromString:self.jsonDict[@"bgColor"]];
    }
    
    UIColor *dividerColor;
    if (self.jsonDict[@"dividerColor"] == nil) {
        dividerColor = [EUtility ColorFromString:@"#191B1D"];
    }else{
        dividerColor = [EUtility ColorFromString:self.jsonDict[@"dividerColor"]];
    }
    
    UIColor *textColor;
    if (self.jsonDict[@"textColor"] == nil) {
        textColor = [EUtility ColorFromString:@"#FFFFFF"];
    }else{
        textColor = [EUtility ColorFromString:self.jsonDict[@"textColor"]];
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    NSArray *itemsArr = [self.jsonDict objectForKey:@"data"];
    for (NSDictionary *dic in itemsArr) {
        [titles addObject:dic[@"text"]];
        if (dic[@"icon"]) {
            NSString *imagePath = [EUtility getAbsPath:meBrwView path:dic[@"icon"]];
            [images addObject:imagePath];
        }else{
            images = nil;
        }
    }
    
    PopoverView *pop = [[PopoverView alloc]initWithPoint:CGPointMake(x, y) titles:titles images:images Direction:direction textSize:textSize backgroundColor:bgColor dividerColor:dividerColor textColor:textColor];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%ld", (long)index);
        NSString *str = [NSString stringWithFormat:@"%ld",index];
        NSString *jsString = [NSString stringWithFormat:@"uexPopoverMenu.cbOpenPopoverMenu('%@');",str];
        [EUtility brwView:meBrwView evaluateScript:jsString];
    };
    [pop show];
    
}

@end
