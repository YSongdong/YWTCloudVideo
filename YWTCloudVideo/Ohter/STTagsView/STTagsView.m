//
//  STTagsView.m
//  STTagsViewDemo
//
//  Created by StriVever on 2017/9/19.
//  Copyright © 2017年 StriVever. All rights reserved.
//

#import "STTagsView.h"
#import "STTagFrame.h"
#import "STTagLayout.h"
#import "STMarginLabel.h"
@interface STTagsView ()

/**
 按钮 数组
 */
@property (nonatomic, strong) NSMutableArray <UILabel *> * labelArray;
@property (nonatomic, strong) NSMutableArray * visibleLabelArray;
@property (nonatomic, strong) STTagFrame * tagFrame;
@property (nonatomic, strong) NSMutableArray *tagColorArray;
/**
 标签内边距
 */
@property (nonatomic, assign) UIEdgeInsets labelInsets;
@end
@implementation STTagsView

+ (instancetype)tagViewWithFrame:(CGRect)frame tagsArray:(NSArray *)tagsArray textColor:(UIColor *)textColor textFont:(UIFont *)font normalTagBackgroundColor:(UIColor *)normalBackgroundColor tagBorderColor:(UIColor *)borderColor contentInsets:(UIEdgeInsets)contentInset labelContentInsets:(UIEdgeInsets)labelContentInsets labelHorizontalSpacing:(CGFloat)horizontalSpacing labelVerticalSpacing:(CGFloat)verticalSpacing{
    STTagsView * tagView = [[STTagsView alloc]initWithFrame:frame];
    tagView.labelArray = [NSMutableArray array];
    tagView.textColor = textColor;
    tagView.textFont = font;
    tagView.labelInsets = labelContentInsets;
    tagView.tagsList = tagsArray.mutableCopy;
   
    STTagFrame * tagFrame = [STTagFrame tagFrameWithContentInsets:contentInset labelContentInsets:labelContentInsets horizontalSpacing:horizontalSpacing verticalSpacing:verticalSpacing textFont:font tagArray:[NSMutableArray arrayWithArray:tagsArray]];
    tagView.tagFrame = tagFrame;
    return tagView;
}
- (void)setupViews{
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    if (self.labelArray.count >= self.tagsList.count) {
        //可用按钮多于 需要使用的按钮
        NSArray * tempArray = self.labelArray.copy;
        self.visibleLabelArray = [NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(0, self.tagsList.count)]];
    }else{
        //可用按钮少于需要使用的按钮
        self.visibleLabelArray = [NSMutableArray arrayWithArray:self.labelArray];
        NSInteger visibleCount = self.labelArray.count;
        NSInteger needCount = self.tagsList.count;
        for (int i = 0; i < needCount - visibleCount; i ++) {
            STMarginLabel * tagLabel = [self marginLabel];
            [self addSubview:tagLabel];
            [self.labelArray addObject:tagLabel];
            [self.visibleLabelArray addObject:tagLabel];
        }
    }
    
    [self.visibleLabelArray enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO;
        obj.text = self.tagsList[idx];
    }];
}
- (STMarginLabel *)taskMarginLabel{
    STMarginLabel * tagLabel = [[STMarginLabel alloc]init];
    UIColor  *taskTextColor = self.tagColorArray[1];
    tagLabel.textColor = taskTextColor;
    tagLabel.font = self.textFont;
    tagLabel.numberOfLines = 0;
    tagLabel.textInsets = self.labelInsets;
    tagLabel.layer.masksToBounds = YES;
    tagLabel.backgroundColor = [UIColor colorTextWhiteColor];
    tagLabel.layer.borderColor = taskTextColor.CGColor;
    tagLabel.layer.borderWidth = .8;
    return tagLabel;
}

- (STMarginLabel *)marginLabel{
    STMarginLabel * tagLabel = [[STMarginLabel alloc]init];
    tagLabel.textColor = self.textColor;
    tagLabel.font = self.textFont;
    tagLabel.numberOfLines = 0;
    tagLabel.textInsets = self.labelInsets;
    tagLabel.layer.masksToBounds = YES;
    tagLabel.backgroundColor = [UIColor  colorWithHexString:@"#31a2f9"];
    tagLabel.layer.borderColor = [UIColor colorWithHexString:@"#31a2f9"].CGColor;
    tagLabel.layer.borderWidth = .8;
    return tagLabel;
}
#pragma mark ---setter
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self.visibleLabelArray enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = self.textColor;
    }];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self.visibleLabelArray enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderColor = self.borderColor.CGColor;
    }];
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    [self.visibleLabelArray enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = self.textFont;
    }];
    self.tagFrame.font = _textFont;
    [self.tagFrame refreshLayout];
    [self layoutSubviews];
}

- (void)addTag:(NSString *)text{
    [self.tagsList addObject:text];
    [self setupViews];
    [self.tagFrame addTagWithContent:text];
    [self layoutSubviews];
}
- (void)removeTagAtIndex:(NSInteger)idx{
    [self.tagsList removeObjectAtIndex:idx];
    [self setupViews];
    [self.tagFrame removeTagWithIndex:idx];
    [self layoutSubviews];
}

- (void)setTagsList:(NSMutableArray *)tagsList{
    _tagsList = tagsList;
    self.tagFrame.tagsArray = [NSMutableArray arrayWithArray:tagsList];
    [self setupViews];
}
-(NSMutableArray *)tagColorArray{
    if (!_tagColorArray) {
        _tagColorArray = [NSMutableArray array];
        [_tagColorArray addObject:[UIColor colorWithHexString:@"#7b96fe"]];
        [_tagColorArray addObject:[UIColor colorWithHexString:@"#00cef0"]];
        [_tagColorArray addObject:[UIColor colorWithHexString:@"#bc79fc"]];
        [_tagColorArray addObject:[UIColor colorWithHexString:@"#13cfa9"]];
        [_tagColorArray addObject:[UIColor colorWithHexString:@"#ff9a5d"]];
        [_tagColorArray addObject:[UIColor colorWithHexString:@"#7b96fe"]];
    }
    return _tagColorArray;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.tagFrame.width = self.frame.size.width;
    [self.visibleLabelArray enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STTagLayout * layout = self.tagFrame.layouts[idx];
        obj.frame = layout.frame;
        obj.layer.cornerRadius = layout.height/2.0;
    }];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tagFrame.height);
}
@end
