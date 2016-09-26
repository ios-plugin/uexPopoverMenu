//
//  PopoverView.m
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//



#import "PopoverView.h"
#import <Masonry/Masonry.h>
#define kArrowHeight 0.f



@interface PopoverView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong)  NSDictionary *dic;
@property (nonatomic) CGPoint showPoint;
@property(nonatomic) CGFloat textSize;
@property(nonatomic) CGFloat textSizeHight;
@property(nonatomic) CGFloat textSizeWidth;
@property(nonatomic) CGFloat row_HEIGHT;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *dividerColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIButton *handerView;

@end

@implementation PopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images Direction:(Direction)direction  textSize:(CGFloat)textSize backgroundColor:(UIColor *)bgColor dividerColor:(UIColor *)dividerColor textColor:(UIColor *)textColor

{
    self = [super init];
    if (self) {
        _direction = direction;
        self.bgColor = bgColor;
        self.dividerColor = dividerColor;
        self.textColor = textColor;
        self.titleArray = titles;
        self.imageArray = images;
        self.textSize = textSize;
        self.dic = @{NSFontAttributeName: [UIFont systemFontOfSize:self.textSize], NSForegroundColorAttributeName: [UIColor blackColor]};
        CGRect strRect = CGRectZero;
        NSMutableArray *widthArr = [NSMutableArray array];
        for (int i = 0; i < self.titleArray.count; i++) {
            strRect =[self.titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.dic context:nil];
             NSLog(@"%f",strRect.size.width);
            [widthArr addObject:[NSNumber numberWithFloat:strRect.size.width]];
            NSLog(@"%f",strRect.size.height);
        }
        float maxWidth = [widthArr[0] floatValue];
        for (int i = 1; i < self.titleArray.count; i++)
        {
            if (maxWidth < [widthArr[i] floatValue])
            {
                maxWidth = [widthArr[i] floatValue];
            }
        }

        self.textSizeWidth = maxWidth;
        self.textSizeHight = strRect.size.height;
        self.row_HEIGHT = self.textSizeHight *1.5;
        self.showPoint = point;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        
       
    }
    return self;
}



-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        switch (_direction) {
            case LeftTop:
                make.left.mas_equalTo(self.showPoint.x);
                make.top.mas_equalTo(self.showPoint.y);
                break;
            case RightTop:
                make.right.mas_equalTo(-self.showPoint.x);
                make.top.mas_equalTo(self.showPoint.y);
                break;
            case LeftBottom:
                make.left.mas_equalTo(self.showPoint.x);
                make.bottom.mas_equalTo(-self.showPoint.y);
                break;
            case RightBottom:
                make.right.mas_equalTo(-self.showPoint.x);
                make.bottom.mas_equalTo(-self.showPoint.y);
                break;
            default:
                break;
        }

        if ([_imageArray count] == [_titleArray count]) {
             make.size.mas_equalTo( CGSizeMake(10 + self.row_HEIGHT + 8 + self.textSizeWidth +10,self.titleArray.count * self.row_HEIGHT));
            
        } else {
             make.size.mas_equalTo( CGSizeMake(10+ self.textSizeWidth +10,self.titleArray.count * self.row_HEIGHT));
        }
       
       
    }];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    [_handerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];


    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);

    [UIView animateWithDuration:0.001f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}


#pragma mark - UITableView

-(UITableView *)tableView
{
    if (!_tableView) {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = self.dividerColor;
}
    return _tableView;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor :self.bgColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_imageArray count] == [_titleArray count]) {
        self.imageView = (UIImageView *)[cell.contentView viewWithTag:1001];
        if (self.imageView == nil) {
            self.imageView = [[UIImageView alloc]init];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.imageView.tag = 1001;
            [cell.contentView addSubview:self.imageView];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(self.row_HEIGHT, self.row_HEIGHT));
                make.centerY.mas_equalTo(0);
            }];
        }
        self.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    }
    
   
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1002];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:self.textSize];
        //label.backgroundColor = [UIColor redColor];
        label.textColor = self.textColor;
        label.tag = 1002;
        // 能够直接向contentView中添加子视图
        // 是因为系统默认创建了内容视图这个容器的实例
        [cell.contentView addSubview:label];
       
        NSLog(@"22222");
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([_imageArray count] == [_titleArray count]) {
                 make.left.mas_equalTo(self.imageView.mas_right).mas_equalTo(8);
            }else{
                make.left.mas_equalTo(10);
            }
            make.right.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    label.text = [_titleArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.row_HEIGHT;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}


@end
