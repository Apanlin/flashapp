//
//  HelpTextViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-4.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HelpTextViewController.h"

@interface HelpTextViewController ()

@end

@implementation HelpTextViewController


@synthesize titleLabel;
@synthesize textLabel;
@synthesize bgImageView;
@synthesize titleText;
@synthesize answerText;


#pragma mark - init & destroy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [titleLabel release];
    [textLabel release];
    [bgImageView release];
    [title release];
    [text release];
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"诊断与帮助";
    bgImageView.image = [[UIImage imageNamed:@"help_triangle_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];

    CGFloat height = 0;
    CGFloat y = 10;
    CGFloat textWidth = 280;
    
    if ( titleText ) {
        titleLabel.text = titleText;
//        titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;

        UIFont* font = [UIFont systemFontOfSize:18];
        CGSize size = [titleText sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
        
        CGRect rect = titleLabel.frame;
        rect.size = size;
        titleLabel.frame = rect;
        y = rect.origin.y + rect.size.height;
        NSLog(@"rect.origin.y= %f rect.size.height = %f",rect.origin.y,rect.size.height);
    }
    
    if ( answerText ) {
        textLabel.text = answerText;
        UIFont* font = [UIFont systemFontOfSize:15];
        CGSize size = [answerText sizeWithFont:font constrainedToSize:CGSizeMake(textWidth, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
        
        height += size.height;
        NSLog(@"height1 = %f",height);
        textLabel.frame = CGRectMake(15, y + 20, textWidth, height +30 );
    }

    bgImageView.frame = CGRectMake(5, y + 5, 300, height + 50);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.titleLabel = nil;
    self.textLabel = nil;
    self.bgImageView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
