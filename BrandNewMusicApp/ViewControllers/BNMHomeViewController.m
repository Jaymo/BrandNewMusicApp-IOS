//
//  BNMHomeViewController.m
//  BrandNewMusicApp
//
//

#import "BNMHomeViewController.h"
#import "BNMSignInViewController.h"
#import "BNMSignUpViewController.h"


@interface BNMHomeViewController (){
    __weak IBOutlet UIScrollView *scrollView;
}

@end

@implementation BNMHomeViewController

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
    
    
    NSLog(@"User Email ID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"] ) {
        [self performSegueWithIdentifier:@"HOMETOTAB" sender:self];

    }
    else{

    }
      self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0  blue:240.0/255.0  alpha:1.0];
    
    UIButton *tempSignInButton = (UIButton *)[self.view viewWithTag:10];
    [tempSignInButton setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    tempSignInButton.titleLabel.font = [UIFont fontWithName:@"News701 BT" size:15.0];

    UIButton *tempSignUpButton = (UIButton *)[self.view viewWithTag:11];
    [tempSignUpButton setTitle:NSLocalizedString(@"SIGN UP", nil) forState:UIControlStateNormal];
    tempSignUpButton.titleLabel.font = [UIFont fontWithName:@"News701 BT" size:15.0];
    // News701 BT
    
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews
{
    
    [scrollView setContentSize:CGSizeMake(0.0,500.0)];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)homeButtonsAction:(id)sender{
    UIButton *clickedButton = (UIButton *)sender;
    if (clickedButton.tag == 10) {
        //  SignIn
        
        //BNMSignInViewController *signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMSignInViewController"];
        //[self.navigationController pushViewController:signInViewController animated:YES];

        
        [self performSegueWithIdentifier:@"HOMETOSIGNIN" sender:self];
    }
    else{
        // Sign UP
        
        //BNMSignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMSignUpViewController"];
        //[self.navigationController pushViewController:signUpViewController animated:YES];

        [self performSegueWithIdentifier:@"HOMETOSIGNUP" sender:self];
    }
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
