//
//  MonthSliderView.m
//  flashapp
//
//  Created by 李 电森 on 11-12-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DatastatsMonthSliderView.h"

@implementation DatastatsMonthSliderView

@synthesize delegate;
@synthesize text;


#pragma mark - init & destroy methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
        
        textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:25];
        //textLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:25];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        
        leftButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        leftButton.frame = CGRectMake(5, frame.size.height / 2 - 12, 50, 25);
        [leftButton setImage:[UIImage imageNamed:@"right_triangle.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(pressLeftButton) forControlEvents:UIControlEventTouchUpInside];
        leftButton.hidden = YES;

        UIEdgeInsets imageInsets1;
        imageInsets1.top = 0;
        imageInsets1.left = 0;
        imageInsets1.right = 34;
        imageInsets1.bottom = 0;
        leftButton.imageEdgeInsets = imageInsets1;
        
        [self addSubview:leftButton];
        
        rightButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        rightButton.frame = CGRectMake( 260, frame.size.height / 2 - 12, 50, 25);
        [rightButton setImage:[UIImage imageNamed:@"left_triangle.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(pressRightButton) forControlEvents:UIControlEventTouchUpInside];
        rightButton.hidden = YES;
        
        UIEdgeInsets imageInsets2;
        imageInsets2.top = 0;
        imageInsets2.left = 34;
        imageInsets2.right = 0;
        imageInsets2.bottom = 0;
        rightButton.imageEdgeInsets = imageInsets2;
        
        [self addSubview:rightButton];
        
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 4, frame.size.width, 4)];
        image.image = [[UIImage imageNamed:@"grayLine.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [self addSubview:image];
        [image release];

        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(230, frame.size.height / 2 - 10, 20, 20);
        [self addSubview:activityView];
    }
    
    return self;
}


- (void) dealloc
{
    [textLabel release];
    [leftButton release];
    [rightButton release];
    [activityView release];
    [super dealloc];
}


#pragma mark - setter

- (void) setText:(NSString*)t
{
    textLabel.text = t;
}


#pragma mark - delegate methods

- (void) pressLeftButton
{
    if ( [delegate respondsToSelector:@selector(monthSliderPrev)] ) {
        [activityView startAnimating];
        [delegate performSelector:@selector(monthSliderPrev)];
        [activityView stopAnimating];
    }
}


- (void) pressRightButton
{
    if ( [delegate respondsToSelector:@selector(monthSliderNext)] ) {
        [activityView startAnimating];
        [delegate performSelector:@selector(monthSliderNext)];
        [activityView stopAnimating];
    }
}


- (void) setDelegate:(id)d
{
    if ( delegate ) [delegate release];
    delegate = [d retain];
    
    if ( [delegate respondsToSelector:@selector(hasPrevMonth)] ) {
        NSNumber* r = (NSNumber*) [delegate performSelector:@selector(hasPrevMonth)];
        int b = [r intValue];
        if ( b ) {
            leftButton.hidden = NO;
        }
        else {
            leftButton.hidden = YES;
        }
    }
    else {
        leftButton.hidden = YES;
    }
    
    if ( [delegate respondsToSelector:@selector(hasNextMonth)] ) {
        NSNumber* r = (NSNumber*) [delegate performSelector:@selector(hasNextMonth)];
        int b = [r intValue];
        if ( b ) {
            rightButton.hidden = NO;
        }
        else {
            rightButton.hidden = YES;
        }
    }
    else {
        rightButton.hidden = YES;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
