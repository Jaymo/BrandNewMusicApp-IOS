//
//  BNMSettingsViewController.m
//  BrandNewMusicApp
//
//

#import "BNMSettingsViewController.h"
#import "BNMSignInViewController.h"
#import "BNMClientApi.h"
#import "NSLayoutConstraint+EvenDistribution.h"


#define  CELLLABELCOLOR [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
#define  TEXTCOLOR [UIColor colorWithRed:43.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]


@interface BNMSettingsViewController (){
    
    __weak IBOutlet UITableView *settingTable;
    MBProgressHUD *progressHud;
    NSMutableDictionary *settingDict;

}

@end

@implementation BNMSettingsViewController

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
    
    
    settingDict = [[NSMutableDictionary alloc] init];
    [self.customTitleLabel setText:NSLocalizedString(@"Settings", nil)];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 5, 30, 30)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 7.5, 1.0, 7.5);
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"back_bttn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(30, 5, 75, 30)];
    [titleButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];

    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.09 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    [self fetchSetting];


    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self saveUserSetting];
    
    
}
-(IBAction)backToPreviousView:(id)sender{
    // Back To Previous View
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchSetting{
    // Fetch Album List
    
    
    NSString *webPath= [NSString stringWithFormat:@"?do=get-settings&email=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"]];
    

    
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];

    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSDictionary *dict= [str objectFromJSONString];
        //NSLog(@"dict %@",dict);
        
        if (![dict valueForKey:@"PAYLOAD"]||[[dict valueForKey:@"PAYLOAD"] isEqual:[NSNull null]]) {
            return ;
        }
        NSArray *tempArtists = [dict valueForKey:@"PAYLOAD"];
        
       NSDictionary *tempDict = [tempArtists objectAtIndex:0];
        [settingDict setObject:[tempDict objectForKey:@"user_notifications_settings"] forKey:@"user_notifications_settings"];
        [settingDict setObject:[tempDict objectForKey:@"user_autosync_settings"] forKey:@"user_autosync_settings"];
        [settingDict setObject:[tempDict objectForKey:@"user_imagecache_settings"] forKey:@"user_imagecache_settings"];
        [settingDict setObject:[tempDict objectForKey:@"user_bnm_version_settings"] forKey:@"user_bnm_version_settings"];
        [settingDict setObject:[tempDict objectForKey:@"user_bnm_rate_settings"] forKey:@"user_bnm_rate_settings"];

        
        //NSLog(@"Setting dict %@",settingDict);
        
       [settingTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }];

}

-(void)saveUserSetting{
    
    
    //[self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];
    
    NSString *webPath= [NSString stringWithFormat:@"?do=set-settings&email=%@&notifications=%d&autosync=%d&imagecache=%d&rate=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"],[[settingDict objectForKey:@"user_notifications_settings"] intValue],[[settingDict objectForKey:@"user_autosync_settings"] intValue],[[settingDict objectForKey:@"user_imagecache_settings"] intValue],[[settingDict objectForKey:@"user_bnm_rate_settings"] intValue]];
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }

    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //[self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if ([str intValue] == 1) {
            //NSLog(@"Setting Updated");
        }
        else{
            //NSLog(@"Setting Not Updated");
        }
        
        
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchChanged:(id)sender{
    UISwitch *tempSwitch=(UISwitch *)sender;

    //NSLog(@"tempSwitch On Off %d",tempSwitch.on);
    
    if (tempSwitch.tag == 0) {
        if (tempSwitch.isOn) {
            [settingDict setObject:@"1" forKey:@"user_notifications_settings"];
        }
        else{
            [settingDict setObject:@"0" forKey:@"user_notifications_settings"];
            
        }

    }
    
    if (tempSwitch.tag == 1) {
        if (tempSwitch.isOn) {
            [settingDict setObject:@"1" forKey:@"user_autosync_settings"];
        }
        else{
            [settingDict setObject:@"0" forKey:@"user_autosync_settings"];
            
        }
        
    }

    if (tempSwitch.tag == 2) {
        if (tempSwitch.isOn) {
            [settingDict setObject:@"1" forKey:@"user_imagecache_settings"];
        }
        else{
            [settingDict setObject:@"0" forKey:@"user_imagecache_settings"];
            
        }
        
    }
    
}

-(void)appRateOption:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    

    UITableViewCell *rateCell = [settingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    
    UIView *tempRateView = (UIView*)rateCell.accessoryView;

    
    for (int i = 10; i <= tempButton.tag; i++) {
        UIButton *selectedButton = (UIButton *)[tempRateView viewWithTag:i];
        [selectedButton setBackgroundImage:[UIImage imageNamed:@"str.png"] forState:UIControlStateNormal];

    }
    for (int i = tempButton.tag +1; i < 16; i++) {
        UIButton *unSelectedButton = (UIButton *)[tempRateView viewWithTag:i];
        [unSelectedButton setBackgroundImage:[UIImage imageNamed:@"str2.png"] forState:UIControlStateNormal];
        
    }
    
    [settingDict setObject:[NSString stringWithFormat:@"%d",tempButton.tag-9] forKey:@"user_bnm_rate_settings"];
    //NSLog(@"Rate %@",[NSString stringWithFormat:@"%d",tempButton.tag-9]);
    

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


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - TableView Data Source methods
// ----------------------------------------------------------------------------

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *tempHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [tempHeaderView setBackgroundColor:[UIColor colorWithRed:239.0/255.09 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]];
    
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 290.0, 22.0)];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    [headerTitleLabel setTextColor:TEXTCOLOR];
    [headerTitleLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:14]];
    [tempHeaderView addSubview:headerTitleLabel];
    
    if (section == 0) {
        [headerTitleLabel setText:NSLocalizedString(@"BNM SETTINGS", nil)];
    }
    if (section == 1) {
        [headerTitleLabel setText:NSLocalizedString(@"BNM VERSION", nil)];
    }
    if (section == 2) {
        [headerTitleLabel setText:NSLocalizedString(@"LOGOUT", nil)];
    }
    
    return tempHeaderView;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
    
}

// custom view for header. will be adjusted to default or specified header height

// Customize the appearance of table view cells...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *tableIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell;// = [settingTable dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:14]];
        cell.textLabel.textColor = TEXTCOLOR;
        cell.detailTextLabel.textColor = TEXTCOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:12]];

        if (indexPath.section == 0) {
            UISwitch *tempSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 52.0, 34)];
            tempSwitch.onTintColor = [UIColor colorWithRed:209.0/255.0 green:59.0/255.0 blue:44.0/255.0 alpha:1.0];
            tempSwitch.tag = indexPath.row;
            [tempSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tempSwitch;
            
            
        }
        
        if (indexPath.section == 1 && indexPath.row == 2) {
            
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(220.0, 0.0, 100.0, 44.0)];
            
            float x = 10.0;
            float y = 16.5;
            for (int i = 0; i < 6; i++) {
                
                UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
                tempButton.tag = i+10;
                [tempButton setFrame:CGRectMake(x, y, 11.0, 11.0)];
                [tempButton setBackgroundImage:[UIImage imageNamed:@"str2.png"] forState:UIControlStateNormal];
                [tempButton addTarget:self action:@selector(appRateOption:) forControlEvents:UIControlEventTouchUpInside];
                [newView addSubview:tempButton];
                x = x+15;
                

            }
            
            cell.accessoryView = newView;

        }
        

    }
    if (indexPath.section == 0) {
        

        
        if (indexPath.row == 0) {
            //NSLog(@"Cell Accessory view %@",cell.contentView.subviews);
            cell.textLabel.text = NSLocalizedString(@"NOTIFICATIONS", nil);
            if ([[settingDict objectForKey:@"user_notifications_settings"] isEqualToString:@"1"]) {
                UISwitch *updatedSwitch = (UISwitch*)cell.accessoryView;
                [updatedSwitch setOn:YES];
            }

            
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"AUTO SYNC", nil);
            if ([[settingDict objectForKey:@"user_autosync_settings"] isEqualToString:@"1"]) {
                UISwitch *updatedSwitch = (UISwitch*)cell.accessoryView;
                [updatedSwitch setOn:YES];
            }



        }
        if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"IMAGE CACHE", nil);
            if ([[settingDict objectForKey:@"user_imagecache_settings"] isEqualToString:@"1"]) {
                UISwitch *updatedSwitch = (UISwitch*)cell.accessoryView;
                [updatedSwitch setOn:YES];
            }
            


        }
    }
    
    if (indexPath.section == 1) {
        

        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"BNM V 3.17 Beta", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"Powered by : bnmapp.com", nil);

        }
        if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"EMAIL FeedBacK", nil);

        }
        if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Rate BNM App", nil);
            
            UIView *tempRateView = (UIView*)cell.accessoryView;

            for (int i = 10; i <= [[settingDict objectForKey:@"user_bnm_rate_settings"] intValue]+10; i++) {
                UIButton *selectedButton = (UIButton *)[tempRateView viewWithTag:i];
                [selectedButton setBackgroundImage:[UIImage imageNamed:@"str.png"] forState:UIControlStateNormal];
                
            }
            for (int i = [[settingDict objectForKey:@"user_bnm_rate_settings"] intValue]+10; i < 16; i++) {
                UIButton *unSelectedButton = (UIButton *)[tempRateView viewWithTag:i];
                [unSelectedButton setBackgroundImage:[UIImage imageNamed:@"str2.png"] forState:UIControlStateNormal];
                
            }

        }
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Logout", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Account : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"]];

        }
    }

  
    return cell;
    
}
// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - TableView Delegate methods
// ----------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            if ([MFMailComposeViewController canSendMail]){
                [self displayMailComposerSheet];
            }
            else{
                UIAlertView *tempAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Message",nil) message:NSLocalizedString(@"Sorry! you can't send mail please setup Email account in Settings",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil];
                [tempAlert show];
                
            }

        }
        
    }
    if (indexPath.section == 2) {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Are you sure you want to logout" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES", nil];
        [logoutAlert show];
    }
}

// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - UIAlertView Delegate
// ----------------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserEmailID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BOOL isSignInExist = NO;
        for (int i = 0; i < self.navigationController.viewControllers.count; i++)
        {
            UIViewController *vc = self.navigationController.viewControllers[i];
            if ([vc isKindOfClass:[BNMSignInViewController class]])
            {
                isSignInExist = YES;
                [self.navigationController popToViewController:vc animated:YES];
                
                break;
            }
        }

        if (!isSignInExist) {
            
            BNMSignInViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMSignInViewController"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark...
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *messageString;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            messageString = NSLocalizedString(@"Result: Mail sending canceled",nil);
            break;
        case MFMailComposeResultSaved:
            
            messageString = NSLocalizedString(@"Result: Mail saved",nil);
            break;
        case MFMailComposeResultSent:
            messageString = NSLocalizedString(@"Result: Mail sent",nil);
            break;
        case MFMailComposeResultFailed:
            
            messageString = NSLocalizedString(@"Result: Mail sending failed",nil);
            break;
        default:
            
            messageString = NSLocalizedString(@"Result: Mail not sent",nil);
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIAlertView *tempAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Message",nil) message:messageString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil];
    [tempAlert show];
    
}

- (void)displayMailComposerSheet
{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:NSLocalizedString(@"BNM FeedBack", nil)];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@bnmapp.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
 
    [self presentViewController:picker animated:YES completion:NULL];
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
