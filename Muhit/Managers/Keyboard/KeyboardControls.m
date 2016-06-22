//
//  KeyboardControls.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "KeyboardControls.h"

@interface KeyboardControls ()
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *leftArrowButton;
@property (nonatomic, strong) UIBarButtonItem *rightArrowButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *segmentedControlItem;
@end

@implementation KeyboardControls


- (BOOL) enableInputClicksWhenVisible {
    return YES;
}


#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    return [self initWithFields:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFields:nil];
}

- (id)initWithFields:(NSArray *)fields
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)])
    {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:self.frame]];
        [self.toolbar setTranslucent:NO];
        [self.toolbar setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth)];
        [self addSubview:self.toolbar];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [self setLeftArrowButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)]];
            [self.leftArrowButton setEnabled:NO];
            [self.rightArrowButton setEnabled:NO];
            [self setRightArrowButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)]];
            
        }
        else {
            [self setBarStyle:UIBarStyleBlackTranslucent];
            
            [self setSegmentedControl:[[UISegmentedControl alloc] initWithItems:@[ LocalizedString(@"keyboard-previous"),
                                                                                   LocalizedString(@"keyboard-next") ]]];
            [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            [self.segmentedControl setMomentary:YES];
            [self.segmentedControl setEnabled:NO forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
            [self.segmentedControl setEnabled:NO forSegmentAtIndex:BSKeyboardControlsDirectionNext];
            [self setSegmentedControlItem:[[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl]];
        }
        
        [self setDoneButton:[[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"ok")
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(doneButtonPressed:)]];
        
        [self setTintColor:CLR_DARK_PUPRPLE];
        [self setVisibleControls:(KeyboardControlPreviousNext | KeyboardControlDone)];
        
        [self setFields:fields];
    }
    
    return self;
}

- (void)dealloc{
    [self setFields:nil];
    [self setBarTintColor:nil];
    [self setDoneTitle:nil];
    [self setDoneTintColor:nil];
    [self setActiveField:nil];
    [self setToolbar:nil];
    [self setRightArrowButton:nil];
    [self setLeftArrowButton:nil];
    [self setSegmentedControl:nil];
    [self setSegmentedControlItem:nil];
    [self setDoneButton:nil];
}

#pragma mark - Public Methods

- (void)setActiveField:(id)activeField
{
    if (activeField != _activeField)
    {
        if (!activeField || [self.fields containsObject:activeField])
        {
            _activeField = activeField;
            
            if (activeField)
            {
                if (![activeField isFirstResponder])
                {
                    [activeField becomeFirstResponder];
                }
                
                [self updatePrevoidNextEnabledStates];
            }
        }
    }
}

- (void)setFields:(NSArray *)fields
{
    if (fields != _fields)
    {
        for (UIView *field in fields)
        {
            if ([field isKindOfClass:[UITextField class]])
            {
                [(UITextField *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[UITextView class]])
            {
                [(UITextView *)field setInputAccessoryView:self];
            }
        }
        
        _fields = fields;
    }
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
    if (barStyle != _barStyle)
    {
        [self.toolbar setBarStyle:barStyle];
        
        _barStyle = barStyle;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (tintColor != _tintColor)
    {
        [self.toolbar setTintColor:tintColor];
        
        _tintColor = tintColor;
        
        [self.doneButton setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:FONT_BOLD size:17],
                                                   NSForegroundColorAttributeName: _tintColor} forState:UIControlStateNormal];
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor{
    if (barTintColor != _barTintColor){
        [self.toolbar setBarTintColor:barTintColor];
        
        _barTintColor = barTintColor;
    }
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor
{
    if (barBackgroundColor != _barBackgroundColor)
    {
        [self.toolbar setBackgroundColor:barBackgroundColor];
        
        _barBackgroundColor = barBackgroundColor;
    }
}

- (void)setDoneTitle:(NSString *)doneTitle
{
    if (![doneTitle isEqualToString:_doneTitle])
    {
        [self.doneButton setTitle:doneTitle];
        
        _doneTitle = doneTitle;
    }
}

- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    if (doneTintColor != _doneTintColor)
    {
        [self.doneButton setTintColor:doneTintColor];
        
        _doneTintColor = doneTintColor;
    }
}

- (void)setVisibleControls:(KeyboardControl)visibleControls
{
    if (visibleControls != _visibleControls)
    {
        _visibleControls = visibleControls;
        
        [self.toolbar setItems:[self toolbarItems]];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)segmentedControlValueChanged:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
    
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case BSKeyboardControlsDirectionPrevious:
            [self selectPreviousField];
            break;
        case BSKeyboardControlsDirectionNext:
            [self selectNextField];
            break;
        default:
            break;
    }
}

- (void)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
    {
        [self.delegate keyboardControlsDonePressed:self];
    }
}

- (void)updatePrevoidNextEnabledStates
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index != NSNotFound)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [self.leftArrowButton setEnabled:(index > 0)];
            [self.rightArrowButton setEnabled:(index < [self.fields count] - 1)];
        } else {
            [self.segmentedControl setEnabled:(index > 0) forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
            [self.segmentedControl setEnabled:(index < [self.fields count] - 1) forSegmentAtIndex:BSKeyboardControlsDirectionNext];
        }
    }
}

- (void)selectPreviousField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index > 0)
    {
        index -= 1;
        UIView *field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:BSKeyboardControlsDirectionPrevious];
        }
    }
}

- (void)selectNextField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index < [self.fields count] - 1)
    {
        index += 1;
        UIView *field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:BSKeyboardControlsDirectionNext];
        }
    }
}

- (NSArray *)toolbarItems
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:3];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        if (self.visibleControls & KeyboardControlPreviousNext)
        {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = 22.0;
            [items addObjectsFromArray:@[self.leftArrowButton,
                                         fixedSpace,
                                         self.rightArrowButton]];
        }
    } else {
        if (self.visibleControls & KeyboardControlPreviousNext)
        {
            [items addObject:self.segmentedControlItem];
        }
    }
    
    if (self.visibleControls & KeyboardControlDone)
    {
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        [items addObject:self.doneButton];
    }
    
    return items;
}

@end
