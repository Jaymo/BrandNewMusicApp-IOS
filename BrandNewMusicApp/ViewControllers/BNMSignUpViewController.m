//
//  BNMSignUpViewController.m
//  BrandNewMusicApp
//
//

#import "BNMSignUpViewController.h"

#import "BNMClientApi.h"

@interface BNMSignUpViewController ()<UIGestureRecognizerDelegate>{
    
    UITapGestureRecognizer *tapRecognizer_;

    
    __weak IBOutlet UIScrollView *signUpScrollView;
    
    __weak IBOutlet UITextField *firstNameField;
    __weak IBOutlet UITextField *lastNameField;
    __weak IBOutlet UITextField *emailField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *confirmPasswordField;
    __weak IBOutlet UITextField *securityQuestionField;
    __weak IBOutlet UITextField *securityAnswerField;
    
    MBProgressHUD *progressHud;

}

@end

@implementation BNMSignUpViewController

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
    
    [signUpScrollView setContentSize:CGSizeMake(0.0,700.0)];
    //[signUpScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.customTitleLabel setText:NSLocalizedString(@"BNM Registration", nil)];

    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 5, 30, 30)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 7.5, 1.0, 7.5);
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"back_bttn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(30, 5, 130, 30)];
    [titleButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];

    
    
    UILabel *firstNameLabel = (UILabel *)[self.view viewWithTag:10];
    [firstNameLabel setText:NSLocalizedString(@"FIRST NAME", nil)];
    firstNameLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];

    
    UILabel *lastNameLabel = (UILabel *)[self.view viewWithTag:20];
    [lastNameLabel setText:NSLocalizedString(@"LAST NAME", nil)];
    lastNameLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];


    UILabel *emailLabel = (UILabel *)[self.view viewWithTag:30];
    [emailLabel setText:NSLocalizedString(@"EMAIL", nil)];
    emailLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];

    
    UILabel *passwordLabel = (UILabel *)[self.view viewWithTag:40];
    [passwordLabel setText:NSLocalizedString(@"PASSWORD", nil)];
    passwordLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];


    UILabel *confirmPasswordLabel = (UILabel *)[self.view viewWithTag:50];
    [confirmPasswordLabel setText:NSLocalizedString(@"CONFIRM PASSWORD", nil)];
    confirmPasswordLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];

    
    UILabel *securityLabel = (UILabel *)[self.view viewWithTag:60];
    [securityLabel setText:NSLocalizedString(@"PROVIDE SECURITY QUESTION", nil)];
    securityLabel.font = [UIFont fontWithName:@"Swiss721BT-Bold" size:14.0];


    UIColor *color = [UIColor colorWithRed:87.0/255.0 green:81.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    firstNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"FIRST NAME", nil) attributes:@{NSForegroundColorAttributeName: color}];
    lastNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LAST NAME",nil) attributes:@{NSForegroundColorAttributeName: color}];
    
    emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"e.g johndeo@emai.com",nil) attributes:@{NSForegroundColorAttributeName: color}];
    passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Minimum 6 Characters",nil) attributes:@{NSForegroundColorAttributeName: color}];
    confirmPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Repeat Password",nil) attributes:@{NSForegroundColorAttributeName: color}];
    securityQuestionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Security Question",nil) attributes:@{NSForegroundColorAttributeName: color}];
    securityAnswerField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Answer",nil) attributes:@{NSForegroundColorAttributeName: color}];
    
    
    
    for (UITextField *textField in signUpScrollView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setFont:[UIFont fontWithName:@"Swis721 BT" size:14.0]];
            
        }
    }
    

    
    
    
    UIImage *firstResponderImage = [UIImage imageNamed:@"inputbgerror.png"];
    
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 3.0f;
    edgeInsets.top = 0.0f;
    edgeInsets.right = 3.0; //Assume 5px will be the constant portion in your image
    edgeInsets.bottom = 0.0f;
    firstResponderImage = [firstResponderImage resizableImageWithCapInsets:edgeInsets];
    
    UIImage *otherImage = [UIImage imageNamed:@"inputbg.png"];
    otherImage = [otherImage resizableImageWithCapInsets:edgeInsets];

    UIImageView *firstNameBorder = (UIImageView *)[self.view viewWithTag:12];
    [firstNameBorder setImage:firstResponderImage];

    
    UIImageView *lastNameBorder = (UIImageView *)[self.view viewWithTag:22];
    [lastNameBorder setImage:otherImage];
    
    UIImageView *emailBorder = (UIImageView *)[self.view viewWithTag:32];
    [emailBorder setImage:otherImage];
    
    UIImageView *passwordBorder = (UIImageView *)[self.view viewWithTag:42];
    [passwordBorder setImage:otherImage];
    
    
    UIImageView *confirmPasswordBorder = (UIImageView *)[self.view viewWithTag:52];
    [confirmPasswordBorder setImage:otherImage];
    
    UIImageView *questionBorder = (UIImageView *)[self.view viewWithTag:62];
    [questionBorder setImage:otherImage];
    
    UIImageView *answerBorder = (UIImageView *)[self.view viewWithTag:64];
    [answerBorder setImage:otherImage];






    
//    UILabel *firstTextLabel = (UILabel *)[self.view viewWithTag:12];
//    [firstTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbgerror.png"]]];
//    
//    UILabel *lastTextLabel = (UILabel *)[self.view viewWithTag:22];
//    [lastTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];
//    
//    UILabel *emailTextLabel = (UILabel *)[self.view viewWithTag:32];
//    [emailTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];
//    
//    UILabel *passwordTextLabel = (UILabel *)[self.view viewWithTag:42];
//    [passwordTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];
//    
//    UILabel *confirmPasswordTextLabel = (UILabel *)[self.view viewWithTag:52];
//    [confirmPasswordTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];
//    
//    UILabel *securityQuestionTextLabel = (UILabel *)[self.view viewWithTag:62];
//    [securityQuestionTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];
//    
//    UILabel *securityAnswerTextLabel = (UILabel *)[self.view viewWithTag:64];
//    [securityAnswerTextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbg.png"]]];

    
    //Swiss 721 Bold BT_1
    
    
    
    UIButton *tempSignInButton = (UIButton *)[self.view viewWithTag:65];
    [tempSignInButton setTitle:NSLocalizedString(@"SIGN UP", nil) forState:UIControlStateNormal];
    tempSignInButton.titleLabel.font = [UIFont fontWithName:@"News701 BT" size:20.0];
    
    
    
    
    
    tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapRecognizer_ setDelegate:self];
    
    
    
    
    UILabel *termsAndPolicyLabel = (UILabel *)[self.view viewWithTag:66];
    termsAndPolicyLabel.font = [UIFont fontWithName:@"Swis721 BT" size:12.0];

    
    
    
    // Do any additional setup after loading the view.
}

-(void)tapped{
    
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    [confirmPasswordField resignFirstResponder];
    [securityQuestionField resignFirstResponder];
    [securityAnswerField resignFirstResponder];
    
    [signUpScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];


}

-(IBAction)signUpButtonsAction:(id)sender{
    UIButton *tempButton = (UIButton *)sender;
    if (tempButton.tag == 65) {
        // sign up
        [self userSignUp];
    }
    if (tempButton.tag == 67 ||tempButton.tag == 68) {
        // terms of services
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
    }
    
    if (tempButton.tag == 69) {
        // privacy policy
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.yahoo.com"]];

    }


}

-(void)userSignUp{
    
    
    [firstNameField resignFirstResponder];
    if ([firstNameField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter first name", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        return ;
        
    }
    
    [lastNameField resignFirstResponder];
    if ([lastNameField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter last name", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        return ;
        
    }

    [emailField resignFirstResponder];
    if ([emailField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Plaese enter email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        
        return ;
        
    }
    else {
        // validate to email id..
        BOOL isValid = [self validateEmail:emailField.text];
        if (!isValid) {
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Pleese enter valid email id", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
                       return ;
            
        }
        
    }

    [passwordField resignFirstResponder];
    if ([passwordField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return ;
        
    }

    if ([passwordField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length <6) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Password should be minimum 6 charcters", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return ;
        
    }
    
    [confirmPasswordField resignFirstResponder];
    if ([confirmPasswordField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter confirm password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return ;
        
    }
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Password and confirm password are not same", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];

        return ;
        
    }
    
    [securityQuestionField resignFirstResponder];

    if ([securityQuestionField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter security question", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return ;
        
    }
    
    if ([securityAnswerField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Please enter security answer", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return ;
        
    }
    
    // Do Sign up
    
    
    NSString *signUpPath = [NSString stringWithFormat:@"?do=register&username=%@%@&email=%@&password=%@",firstNameField.text,lastNameField.text,emailField.text,passwordField.text];
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];


    [[BNMClientApi sharedInsatance] getPath:signUpPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];



        
        if ([str isEqualToString:@"1"]) {
        
            [[NSUserDefaults standardUserDefaults] setObject:emailField.text forKey:@"UserEmailID"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"You have signed up successfully", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AppTourDone"] == YES) {
                [self performSegueWithIdentifier:@"SIGNUPTOTABS" sender:self];
            }
            else{
                [self performSegueWithIdentifier:@"SIGNUPTOAPPGUIDE" sender:self];
            }
            


        }
        else{
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! Account exist already", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }
        
    }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    float y = 0.0;
//    float iPhone4Margin = 0.0;
//    if (!IS_IPHONE_5) {
//        iPhone4Margin = 68.0;
//    }

    
    UIImage *firstResponderImage = [UIImage imageNamed:@"inputbgerror.png"];
    
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 3.0f;
    edgeInsets.top = 0.0f;
    edgeInsets.right = 3.0; //Assume 5px will be the constant portion in your image
    edgeInsets.bottom = 0.0f;
    firstResponderImage = [firstResponderImage resizableImageWithCapInsets:edgeInsets];
    
    UIImage *otherImage = [UIImage imageNamed:@"inputbg.png"];
    otherImage = [otherImage resizableImageWithCapInsets:edgeInsets];
    
    UIImageView *firstNameBorder = (UIImageView *)[self.view viewWithTag:12];
    [firstNameBorder setImage:otherImage];
    
    
    UIImageView *lastNameBorder = (UIImageView *)[self.view viewWithTag:22];
    [lastNameBorder setImage:otherImage];
    
    UIImageView *emailBorder = (UIImageView *)[self.view viewWithTag:32];
    [emailBorder setImage:otherImage];
    
    UIImageView *passwordBorder = (UIImageView *)[self.view viewWithTag:42];
    [passwordBorder setImage:otherImage];
    
    
    UIImageView *confirmPasswordBorder = (UIImageView *)[self.view viewWithTag:52];
    [confirmPasswordBorder setImage:otherImage];
    
    UIImageView *questionBorder = (UIImageView *)[self.view viewWithTag:62];
    [questionBorder setImage:otherImage];
    
    UIImageView *answerBorder = (UIImageView *)[self.view viewWithTag:64];
    [answerBorder setImage:otherImage];

    
    
    
    if (textField == firstNameField) {
        [firstNameBorder setImage:firstResponderImage];
    }
    if (textField == lastNameField) {
        [lastNameBorder setImage:firstResponderImage];

    }
    if (textField == emailField) {
        [emailBorder setImage:firstResponderImage];
        
    }
    if (textField == passwordField) {
        //y = y+iPhone4Margin;
        [passwordBorder setImage:firstResponderImage];
        
    }
    if (textField == confirmPasswordField) {
        //y = 50.0+iPhone4Margin;
        [confirmPasswordBorder setImage:firstResponderImage];
        
    }
    if (textField == securityQuestionField) {
        //y = 100.0+iPhone4Margin;

        [questionBorder setImage:firstResponderImage];
        
    }
    if (textField == securityAnswerField) {
        //y = 150.0+iPhone4Margin;
        [answerBorder setImage:firstResponderImage];
        
    }
    
//    [UIView animateWithDuration:0.0f animations:^{
//        CGPoint bottomOffset = CGPointMake(0,  y);
//        [signUpScrollView setContentOffset:bottomOffset animated:YES];
//        
//    }];


}
- (void)textFieldDidEndEditing:(UITextField *)textField  {
    
//    float y = 0.0;
//    
//    float iPhone4Margin = 0.0;
//    if (!IS_IPHONE_5) {
//        iPhone4Margin = 68.0;
//    }
//
//    if (textField == firstNameField) {
//    }
//    if (textField == lastNameField) {
//        
//    }
//    if (textField == emailField) {
//        
//    }
//    if (textField == passwordField) {
//        y = 0.0 +iPhone4Margin;
//        
//    }
//    if (textField == confirmPasswordField) {
//        y = 50.0 + iPhone4Margin;
//        
//    }
//    if (textField == securityQuestionField) {
//        y = 100.0 + iPhone4Margin;
//    }
//    if (textField == securityAnswerField) {
//        y = 150.0 + iPhone4Margin;
//    }
//    
//    [UIView animateWithDuration:0.0f animations:^{
//        CGPoint bottomOffset = CGPointMake(0,  -y);
//        [signUpScrollView setContentOffset:bottomOffset animated:YES];
//        
//    }];

    [self.view removeGestureRecognizer:tapRecognizer_];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([firstNameField isFirstResponder]) {
        [lastNameField becomeFirstResponder];
        return  YES;
    }
    if ([lastNameField isFirstResponder]) {
        [emailField becomeFirstResponder];
        return  YES;

    }
    if ([emailField isFirstResponder]) {
        [passwordField becomeFirstResponder];
        return  YES;

    }
    if ([passwordField isFirstResponder]) {
        [confirmPasswordField becomeFirstResponder];
        return  YES;

    }
    if ([confirmPasswordField isFirstResponder]) {
        [securityQuestionField becomeFirstResponder];
        return  YES;

    }
    if ([securityQuestionField isFirstResponder]) {
        [securityAnswerField becomeFirstResponder];
        return  YES;

    }

    [textField resignFirstResponder];

    [signUpScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

    
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
