//
//  BNMSignInViewController.m
//  BrandNewMusicApp
//
//

#import "BNMSignInViewController.h"
#import "BNMClientApi.h"
#import "CustomIOS7AlertView.h"
#import "BNMHomeViewController.h"


#define PLACEHOLDERCOLOR [UIColor colorWithRed:87.0/255.0 green:81.0/255.0 blue:93.0/255.0 alpha:1.0]

@interface BNMSignInViewController ()<CustomIOS7AlertViewDelegate,UITextFieldDelegate>{
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
    
    MBProgressHUD *progressHud;
    CustomIOS7AlertView *forgotPasswordAlertView;
    UIView *customAlertView;
    
    __weak IBOutlet UIScrollView *scrollView;


}

@end

@implementation BNMSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    
    [scrollView setContentSize:CGSizeMake(0.0,400.0)];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0  blue:240.0/255.0  alpha:1.0];

    [self.customTitleLabel setText:NSLocalizedString(@"BNM Login", nil)];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 5, 30, 30)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 7.5, 1.0, 7.5);
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"back_bttn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(30, 5, 90, 30)];
    [titleButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];

    
    
    UILabel *tempLabel = (UILabel *)[self.view viewWithTag:20];
    [tempLabel setText:NSLocalizedString(@"Enter your BNM Credentials to continue", nil)];
    tempLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:13];
    
    
    UIImageView *emailBorder = (UIImageView *)[self.view viewWithTag:22];
    UIImage *emailImage = [UIImage imageNamed:@"inputbgerror.png"];
    
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 3.0f;
    edgeInsets.top = 0.0f;
    edgeInsets.right = 3.0; //Assume 5px will be the constant portion in your image
    edgeInsets.bottom = 0.0f;
    emailImage = [emailImage resizableImageWithCapInsets:edgeInsets];
    [emailBorder setImage:emailImage];
    
    
    UIImageView *passwordBorder = (UIImageView *)[self.view viewWithTag:24];
    UIImage *passwordImage = [UIImage imageNamed:@"inputbg.png"];
    passwordImage = [passwordImage resizableImageWithCapInsets:edgeInsets];
    
    [passwordBorder setImage:passwordImage];

//    UILabel *emailTextLabel = (UILabel *)[self.view viewWithTag:22];
//    [emailTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbgerror.png"]]];
//    
//    UILabel *passwordTextLabel = (UILabel *)[self.view viewWithTag:24];
//    [passwordTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];
//    


    
    //Swiss 721 Bold BT_1
    
    UIButton *tempForgotButton = (UIButton *)[self.view viewWithTag:25];
    [tempForgotButton setTitle:NSLocalizedString(@"Forgot Password ? Tap Here", nil) forState:UIControlStateNormal];
    tempForgotButton.titleLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];
    tempForgotButton.tag = 12;
    [tempForgotButton addTarget:self action:@selector(signInOption:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *tempSignInButton = (UIButton *)[self.view viewWithTag:26];
    [tempSignInButton setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    tempSignInButton.titleLabel.font = [UIFont fontWithName:@"News701 BT" size:14.0];
    
    
    
    
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
    // Default login
//    emailTextField.text = @"ankul@xicom.biz";
//    passwordTextField.text =@"123456";
    
    [emailTextField setFont:[UIFont fontWithName:@"Swis721 BT" size:14.0]];
    
    [passwordTextField setFont:[UIFont fontWithName:@"Swis721 BT" size:14.0]];

    
    tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapRecognizer_ setDelegate:self];
    
    
    
    forgotPasswordTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordGestureClicked)];
    [forgotPasswordTapGesture setDelegate:self];

    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)tapped{
    
    [self.view removeGestureRecognizer:tapRecognizer_];
    if ([emailTextField isFirstResponder]) {
        [emailTextField resignFirstResponder];
    }
    if ([passwordTextField isFirstResponder]) {
        [passwordTextField resignFirstResponder];

    }
    
}

-(void)forgotPasswordGestureClicked{
    
    UITextField *tempEmailField = (UITextField *)[customAlertView viewWithTag:1001];
    if ([tempEmailField isFirstResponder]) {
        [tempEmailField resignFirstResponder];
    }

    CGPoint point = [forgotPasswordTapGesture locationInView:self.view];
    NSLog(@"tap gsture %@",NSStringFromCGPoint(point));

    if (IS_IPHONE_5) {
        if (((point.x >34.0 && point.x <286.0) && (point.y >131.5) && (point.y <436.5))) {
            return;
        }
        
    }else{
        
        if (((point.x >34.0 && point.x <286.0) && (point.y >87.5) && (point.y <392.5))) {
            return;
        }

    }

    if (forgotPasswordAlertView) {
        [forgotPasswordAlertView close];
    }
    [self.view removeGestureRecognizer:tapRecognizer_];
    [self.view removeGestureRecognizer:forgotPasswordTapGesture];
    [forgotPasswordAlertView removeGestureRecognizer:forgotPasswordTapGesture];


}

-(IBAction)signInOption:(id)sender{
    
    UIButton *actionButton = (UIButton *)sender;
    if (actionButton.tag == 12) {
        // Show reset password screen...
        
        [self.view removeGestureRecognizer:tapRecognizer_];
        if ([emailTextField isFirstResponder]) {
            [emailTextField resignFirstResponder];
        }
        if ([passwordTextField isFirstResponder]) {
            [passwordTextField resignFirstResponder];
            
        }

        [self showForgotPasswordView];
    }
    else {
        // Sign in web services...
        [self signIn];
    }
}
-(void)showForgotPasswordView {
        forgotPasswordAlertView = [[CustomIOS7AlertView alloc] init];
        forgotPasswordAlertView.tag = 11;
        
        // Add some custom content to the alert view
        [forgotPasswordAlertView setContainerView:[self createPasswordAlertView]];
        
        // Modify the parameters
        [forgotPasswordAlertView setButtonTitles:[NSMutableArray arrayWithObjects: nil]];
        [forgotPasswordAlertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [forgotPasswordAlertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            //[alertView close];
        }];
        
        [forgotPasswordAlertView setUseMotionEffects:true];
        
        // And launch the dialog
        [forgotPasswordAlertView show];
    
        [forgotPasswordAlertView addGestureRecognizer:forgotPasswordTapGesture];
    
}

-(UIView *)createPasswordAlertView{
    
        customAlertView = [[UIView alloc] init];
        [customAlertView setFrame:CGRectMake(0, 0, 252.0, 305.0)];
        
        UILabel *alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 222.0, 30.0)];
        [alertTitleLabel setBackgroundColor:[UIColor clearColor]];
        [alertTitleLabel setTextColor:[UIColor colorWithRed:34.0/255.0 green:176.0/255.0 blue:207.0/255.0 alpha:1.0]];
        alertTitleLabel.font = [UIFont fontWithName:@"Swis721 BT" size:20.0];
        alertTitleLabel.text = @"Reset Password";
        [customAlertView addSubview:alertTitleLabel];

        UILabel *alertTitleFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 252.0, 3.5)];
        [alertTitleFooterLabel setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:176.0/255.0 blue:207.0/255.0 alpha:1.0]];
        [customAlertView addSubview:alertTitleFooterLabel];
    
    
        UILabel *emailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 70.0, 222.0, 15.0)];
        [emailTitleLabel setBackgroundColor:[UIColor clearColor]];
        [emailTitleLabel setText:NSLocalizedString(@"Enter email registered to continue reset", nil)];
        emailTitleLabel.font = [UIFont fontWithName:@"Swis721 BT" size:12.0];
        [emailTitleLabel setTextColor:[UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [customAlertView addSubview:emailTitleLabel];

        UITextField *emailField = [[UITextField alloc] init];
        emailField.tag = 1001;
        [emailField setFrame:CGRectMake(20.0, 100, 212.0, 15.0)];
        [emailField setBorderStyle:UITextBorderStyleNone];
         emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        [emailField setDelegate:self];
        [emailField setFont:[UIFont fontWithName:@"Swis721 BT" size:14.0]];
        [emailField setPlaceholder:@"Email"];
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
        [customAlertView addSubview:emailField];
    
        UILabel *emailFieldFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 115.0, 222.0, 5.0)];
        [emailFieldFooterLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg2.png"]]];
        [customAlertView addSubview:emailFieldFooterLabel];
    
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(142, 125.0, 110.0, 140.0)];
        [logoImageView setImage:[UIImage imageNamed:@"resetIcon.png"]];
        [customAlertView addSubview:logoImageView];
    
   


        UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetButton setFrame:CGRectMake(8.0, 145.0, 236.0, 36.0)];
        [resetButton setTitle:NSLocalizedString(@"RESET", nil) forState:UIControlStateNormal];
        [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        resetButton.titleLabel.font = [UIFont fontWithName:@"News701 BT" size:20.0];
        [resetButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(restetAction:) forControlEvents:UIControlEventTouchUpInside];
        [customAlertView addSubview:resetButton];
    
    
        return customAlertView;
    
}

-(IBAction)restetAction:(id)sender{
    // Reset password action
    
    UITextField *tempEmailField = (UITextField *)[customAlertView viewWithTag:1001];
    [tempEmailField resignFirstResponder];
    if ([tempEmailField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Plaese enter email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        
        return ;
        
    }
    else {
        // validate to email id..
        BOOL isValid = [self validateEmail:tempEmailField.text];
        if (!isValid) {
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Pleese enter valid email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
            return ;
            
        }
        
    }
    
    
    
    NSString *resetPasswordPath = [NSString stringWithFormat:@"?do=reset&email=%@",tempEmailField.text];
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];


    [[BNMClientApi sharedInsatance] getPath:resetPasswordPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if ([str isEqualToString:@"1"]) {
            
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sent a password reset link to the email address", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
            
        }
        else{
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! invalid email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }
        
    }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
            
        }];

    

}
-(void)signIn {
    [emailTextField resignFirstResponder];
    if ([emailTextField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Plaese enter email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        
        return ;
        
    }
    else {
        // validate to email id..
        BOOL isValid = [self validateEmail:emailTextField.text];
        if (!isValid) {
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Pleese enter valid email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
            return ;
            
        }
        
    }
    
    [passwordTextField resignFirstResponder];
    if ([passwordTextField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return ;
        
    }
    
    // Do Login
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {

        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];

        return;
    }
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];
    
    NSString *signUpPath = [NSString stringWithFormat:@"?do=login&email=%@&password=%@",emailTextField.text,passwordTextField.text];
    
    [[BNMClientApi sharedInsatance] getPath:signUpPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if ([str isEqualToString:@"1"]) {
            
            
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"UserEmailID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Send Device token on server ....

            if (TARGET_IPHONE_SIMULATOR) {
                
            }else{
                
                if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"UPDATEDDEVICETOKEN"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"]]) {
                    [self sendDeviceToken];

                }

            }
            
    
            
//            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"You have logged in successfully", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
//            [tempAlert show];
            
            [self performSegueWithIdentifier:@"SIGNINTOTABS" sender:self];

            
        }
        else{
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! invalid email/password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }
        
    }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
            
        }];

}


-(void)sendDeviceToken {
    
    NSString *webPath= [NSString stringWithFormat:@"?do=set-device-token&token=%@&email=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"],emailTextField.text];
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }

    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if ([str intValue] == 1) {
            NSLog(@"Device Token Updated");
            [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"] forKey:@"UPDATEDDEVICETOKEN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            NSLog(@"Device Token Not Updated");
        }
        
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }];

}

- (BOOL)validateEmail:(NSString *)inputText {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText]) {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        int indexOfDot = (int)aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
        }
    }
    return FALSE;
}

-(IBAction)backToPreviousView:(id)sender{
    // Back To Previous View
    
    for (int i = 0; i < self.navigationController.viewControllers.count; i++)
    {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:[BNMHomeViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            
            break;
        }
    }

    //NSLog(@"self.navigation Controllers %@",self.navigationController.viewControllers);
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - CustomIOS7AlertViewDelegate
// ---------------------------------------------------------------------

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
}

#pragma mark
#pragma mark MBProgressMethods

- (void) startAnimator {
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = NSLocalizedString(@"Please wait...", @"Title of activity indicator, to wait some time.");
}
- (void) stopAnimator {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    progressHud = nil;
}

#pragma mark
#pragma mark UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.view addGestureRecognizer:tapRecognizer_];
    
    UIImageView *emailBorder = (UIImageView *)[self.view viewWithTag:22];
    UIImageView *passwordBorder = (UIImageView *)[self.view viewWithTag:24];



    UIImage *emailImage;
    UIImage *passwordImage;
    
    if (textField == emailTextField) {
         emailImage = [UIImage imageNamed:@"inputbgerror.png"];
         passwordImage = [UIImage imageNamed:@"inputbg.png"];
    }
    else{
        emailImage = [UIImage imageNamed:@"inputbg.png"];
        passwordImage = [UIImage imageNamed:@"inputbgerror.png"];
    }
    
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 3.0f;
    edgeInsets.top = 0.0f;
    edgeInsets.right = 3.0; //Assume 5px will be the constant portion in your image
    edgeInsets.bottom = 0.0f;
    emailImage = [emailImage resizableImageWithCapInsets:edgeInsets];
    
    [emailBorder setImage:emailImage];
    
    passwordImage = [passwordImage resizableImageWithCapInsets:edgeInsets];
    
    [passwordBorder setImage:passwordImage];

}
- (void)textFieldDidEndEditing:(UITextField *)textField  {
    [self.view removeGestureRecognizer:tapRecognizer_];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([emailTextField isFirstResponder]) {
        [passwordTextField becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return  YES;
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
