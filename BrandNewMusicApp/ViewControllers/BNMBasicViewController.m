//
//  BNMBasicViewController.m
//  BrandNewMusicApp
//
//

#import "BNMBasicViewController.h"

@interface BNMBasicViewController ()

@end

@implementation BNMBasicViewController
@synthesize topView;
@synthesize customTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0  blue:240.0/255.0  alpha:1.0];

    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topstrip.png"]];
    
    self.customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0, 5.0, 200.0, 30.0)];
    self.customTitleLabel.backgroundColor = [UIColor clearColor];
    [self.customTitleLabel setFont:[UIFont fontWithName:@"Swis721 BT" size:15.0]];

    [self.topView addSubview:self.customTitleLabel];
    
    [self.topView setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    [self.view addSubview:self.topView];
    
    [self setupConstraints];
    

    
    
    // Do any additional setup after loading the view.
}

- (void)setupConstraints {
    
    // Width constraint
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
//                                                     attribute:NSLayoutAttributeWidth
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.topView
//                                                     attribute:NSLayoutAttributeWidth
//                                                    multiplier:0.5
//                                                      constant:0]];
//    
//    // Height constraint
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
//                                                     attribute:NSLayoutAttributeHeight
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.topView
//                                                     attribute:NSLayoutAttributeHeight
//                                                    multiplier:0.5
//                                                      constant:0]];
    
    // Center horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.topView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    // Center vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.topView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
