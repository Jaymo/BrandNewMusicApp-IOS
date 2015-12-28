//
//  BNMTabsViewController.m
//  BrandNewMusicApp
//
//

#import "BNMTabsViewController.h"
#import "BNMHomeTableViewCell.h"
#import "BNMTopTenTableViewCell.h"
#import "BNMGenreTableViewCell.h"
#import "BNMArtistTableViewCell.h"
#import "BNMMyArtist.h"
#import "BNMTrack.h"
#import "BNMGenre.h"
#import "BNMArtist.h"

#import "BNMAlbumsViewController.h"
#import "BNMTracksViewController.h"
#import "BNMArtistProfileViewController.h"
#import "BNMPlayerViewController.h"
#import "BNMSettingsViewController.h"

#import "BNMClientApi.h"

#define CELLLABELCOLOR [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
#define PLACEHOLDERCOLOR [UIColor colorWithRed:87.0/255.0 green:81.0/255.0 blue:93.0/255.0 alpha:1.0]

#import "EGORefreshTableHeaderView.h"



@interface BNMTabsViewController ()<UITextFieldDelegate,EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UITableView *listTableView;
    
    MBProgressHUD *progressHud;
    NSMutableArray *myList;
    NSMutableArray *searchedList;
    
    __weak IBOutlet UIView *searchView;
     __weak IBOutlet UITextField *searchTextField;
    NSString *selectedId;

    BNMArtist *profileArtist;
    
    // Pull To Refresh
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

    
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end

@implementation BNMTabsViewController

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
    
    
    currentMusicListType = MusicListTypeHome;
    
    UILabel *selectedLabel = (UILabel *)[self.view viewWithTag:5];
    [selectedLabel setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0]];
    
    for (UILabel *tempLabel in self.view.subviews) {
        if ([tempLabel isKindOfClass:[UILabel class]]) {
            if (tempLabel.tag == 6 || tempLabel.tag == 7 ||tempLabel.tag == 8) {
                [tempLabel setBackgroundColor:[UIColor clearColor]];
            }
        }
    }

    
    myList = [[NSMutableArray alloc] init];
    searchedList = [[NSMutableArray alloc] init];
    

    [self.customTitleLabel setText:NSLocalizedString(@"BRAND NEW MUSIC", nil)];

    
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setFrame:CGRectMake(0, 5, 30, 30)];
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(8.0, 11.0, 8.0, 11.0);
//    [backButton setShowsTouchWhenHighlighted:YES];
//    [backButton setImage:[UIImage imageNamed:@"back_bttn.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
    
    for (UIButton *tempButton in self.view.subviews) {
        if ([tempButton isKindOfClass:[UIButton class]]) {
            if (tempButton.tag == 1 || tempButton.tag == 2||tempButton.tag == 3||tempButton.tag == 4) {
                [tempButton setBackgroundColor:[UIColor clearColor]];
                [tempButton setTitleColor:[UIColor colorWithRed:43.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [tempButton.titleLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:12.0]];
            }
        }
    }
    
    for (UILabel *tempLabel in self.view.subviews) {
        if ([tempLabel isKindOfClass:[UILabel class]]) {
            if (tempLabel.tag == 6 || tempLabel.tag == 7 ||tempLabel.tag == 8) {
                [tempLabel setBackgroundColor:[UIColor clearColor]];
            }
        }
    }

//    
//    UILabel *menuLabel = (UILabel *)[self.view viewWithTag:200];
//    [menuLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menubg.png"]]];
    
    
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchButton setFrame:CGRectMake(250, 5, 30, 30)];
//     searchButton.imageEdgeInsets = UIEdgeInsetsMake(3.0, 6.0, 3.0, 6.0);
//    [searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(searchOption:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:searchButton];
    
    
    // Center vertically
    
    
    
    


    
    
//    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [menuButton setFrame:CGRectMake(290, 0, 40, 40)];
//    menuButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 25.0);
//    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
//    [menuButton addTarget:self action:@selector(menuOption:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:menuButton];


    
    //searchView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 270.0, 40.0)];
    //searchView.backgroundColor = [UIColor greenColor];
    searchView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    searchView.hidden = YES;
    [self.view addSubview:searchView];
    
    

    

    
    
    
//    searchTextField = [[UITextField alloc] init];
//    [searchTextField setFrame:CGRectMake(5.0, 5.0, 230.0, 20.0)];
    [searchTextField setBorderStyle:UITextBorderStyleNone];
    [searchTextField setDelegate:self];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    [searchTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [searchTextField setFont:[UIFont fontWithName:@"Swis721 BT" size:12.0]];
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];

    searchTextField.keyboardType = UIKeyboardTypeAlphabet;
    
    [searchView addSubview:searchTextField];
    

    
    UIImageView *textFieldBorder = (UIImageView *)[self.view viewWithTag:1000];
    NSLog(@"Image View %@",textFieldBorder);
    UIImage *emailImage = [UIImage imageNamed:@"inputbgerror.png"];
    
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 3.0f;
    edgeInsets.top = 0.0f;
    edgeInsets.right = 3.0; //Assume 5px will be the constant portion in your image
    edgeInsets.bottom = 0.0f;
    emailImage = [emailImage resizableImageWithCapInsets:edgeInsets];
    [textFieldBorder setImage:emailImage];

    
    
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setFrame:CGRectMake(238.0, 0, 35.0, 35.0)];
//    closeButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5);
//    [closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//    
//    //[closeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(crossOption:) forControlEvents:UIControlEventTouchUpInside];
//    [searchView addSubview:closeButton];
//    
//    
//
//
//    
//    //[searchTextField setLeftViewMode:UITextFieldViewModeUnlessEditing];
//    //searchTextField.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
//
//    
//    UILabel *searchFieldFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 25.0, 268.0, 5.0)];
//    [searchFieldFooterLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"inputbgerror.png"]]];
//    [searchView addSubview:searchFieldFooterLabel];
    
    
    tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapRecognizer_ setDelegate:self];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - listTableView.bounds.size.height, self.view.frame.size.width, listTableView.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
		[listTableView addSubview:view];
		_refreshHeaderView = view;
	}
    //
    // update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
   
    [self fetchMusicList];
    

    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
   
    [super viewWillAppear:animated];
    [self.customTitleLabel setFrame:CGRectMake(10.0, 5.0, 200.0, 30.0)];
    NSLog(@"currentMusicListType %d",currentMusicListType);

    
   // [self fetchMusicList];

//    if (currentMusicListType == MusicListTypeArtist) {
//        [listTableView reloadData];
//    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.customTitleLabel setFrame:CGRectMake(35.0, 5.0, 200.0, 30.0)];

}
-(void)fetchMusicList {
    //
    
    // Do Login
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];

    
    //[searchedList removeAllObjects];

    
    NSString *webPath;
    if (currentMusicListType == MusicListTypeHome) {
        webPath = [NSString stringWithFormat:@"?do=following&email=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"]];
    }
    if (currentMusicListType == MusicListTypeTopTen) {
        webPath = @"?do=topten";

    }
    if (currentMusicListType == MusicListTypeGenre) {
        webPath = @"?do=genres";

    }
    if (currentMusicListType == MusicListTypeArtist) {
        webPath = [NSString stringWithFormat:@"?do=artists&email=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"]];
    }
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    
    //NSLog(@"web Path %@",webPath);


    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSDictionary *dict= [str objectFromJSONString];
        
        //NSLog(@"JSON DICT %@",dict);
        
        NSArray *tempArtists = [dict objectForKeyedSubscript:@"PAYLOAD"];
        
        
        [myList removeAllObjects];

        for (NSDictionary *artistDict in tempArtists) {
            
            if (currentMusicListType == MusicListTypeHome) {
                BNMMyArtist *artist = [[BNMMyArtist alloc] initWithDictionary:artistDict];
                [myList addObject:artist];

            }
            if (currentMusicListType == MusicListTypeTopTen) {
                BNMTrack *track = [[BNMTrack alloc] initWithDictionary:artistDict];
                [myList addObject:track];

            }
           
            if (currentMusicListType == MusicListTypeGenre) {
                BNMGenre *genre = [[BNMGenre alloc] initWithDictionary:artistDict];
                [myList addObject:genre];
                
            }
            if (currentMusicListType == MusicListTypeArtist) {
                BNMArtist *artist = [[BNMArtist alloc] initWithDictionary:artistDict];
                [myList addObject:artist];

            }

        }
        

        [searchedList removeAllObjects];
        [searchedList addObjectsFromArray:[myList mutableCopy]];

        [listTableView setDataSource:self];
        [listTableView setDelegate:self];

        [listTableView reloadData];




    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        [listTableView setDataSource:self];
        [listTableView setDelegate:self];

        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
    }];

}

-(void)tapped{
    
    [self.view removeGestureRecognizer:tapRecognizer_];
    if ([searchTextField isFirstResponder]) {
        [searchTextField resignFirstResponder];
    }
    //searchView.hidden = YES;
    
}

-(IBAction)backToPreviousView:(id)sender{
    // Back To Previous View
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchOption:(id)sender{
    // search option clicked
    searchView.hidden = NO;
    [searchTextField becomeFirstResponder];
    searchTextField.text = @"";
    //searchButton.hidden = YES;

}
-(IBAction)menuOption:(id)sender{
    // menu option clicked
    BNMSettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMSettingsViewController"];
    [self.navigationController pushViewController:controller animated:YES];


}
-(IBAction)crossOption:(id)sender{
    // crossOption clicked
    [self.view removeGestureRecognizer:tapRecognizer_];
    searchView.hidden = YES;
    [searchTextField resignFirstResponder];
    
    searchedList = [myList mutableCopy];
    [listTableView reloadData];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tabOptions:(id)sender{
    UIButton *tempButton = (UIButton *)sender;
    [listTableView setDataSource:nil];
    [listTableView setDelegate:nil];

    
    
    if (tempButton.tag == 1) {
        // Home
        currentMusicListType = MusicListTypeHome;

        for (UILabel *tempLabel in self.view.subviews) {
            if ([tempLabel isKindOfClass:[UILabel class]]) {
                if (tempLabel.tag == 6 || tempLabel.tag == 7 ||tempLabel.tag == 8) {
                    [tempLabel setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        
        UILabel *selectedLabel = (UILabel *)[self.view viewWithTag:5];
        [selectedLabel setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0]];

        
    }
    if (tempButton.tag == 2) {
        // Top Ten
        currentMusicListType = MusicListTypeTopTen;
        

        for (UILabel *tempLabel in self.view.subviews) {
            if ([tempLabel isKindOfClass:[UILabel class]]) {
                if (tempLabel.tag == 5 || tempLabel.tag == 7 ||tempLabel.tag == 8) {
                    [tempLabel setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        UILabel *selectedLabel = (UILabel *)[self.view viewWithTag:6];
        [selectedLabel setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0]];



    }
    if (tempButton.tag == 3) {
        // Genre
        currentMusicListType = MusicListTypeGenre;
        for (UILabel *tempLabel in self.view.subviews) {
            if ([tempLabel isKindOfClass:[UILabel class]]) {
                if (tempLabel.tag == 5 || tempLabel.tag == 6 ||tempLabel.tag == 8) {
                    [tempLabel setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        UILabel *selectedLabel = (UILabel *)[self.view viewWithTag:7];
        [selectedLabel setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0]];



    }
    if (tempButton.tag == 4) {
        // Artist
        currentMusicListType = MusicListTypeArtist;
        

        for (UILabel *tempLabel in self.view.subviews) {
            if ([tempLabel isKindOfClass:[UILabel class]]) {
                if (tempLabel.tag == 5 || tempLabel.tag == 6 ||tempLabel.tag == 7) {
                    [tempLabel setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        
        UILabel *selectedLabel = (UILabel *)[self.view viewWithTag:8];
        [selectedLabel setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0]];



    }
   
    [self performSelectorOnMainThread:@selector(fetchMusicList) withObject:nil waitUntilDone:NO];


    
}

-(IBAction)followUnfollowOption:(id)sender{
    UIButton *tempButton = (UIButton *)sender;
    BNMArtist *tempArtist = [searchedList objectAtIndex:tempButton.tag];
        
    NSString *webPath = [NSString stringWithFormat:@"?do=follow&email=%@&artist_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"],tempArtist.artistId];
    

    
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
        
        if ([str isEqualToString:@"1"]) {
            [tempArtist setArtistFollowStatus:1];
            //tempButton.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0];
            //[tempButton setTitle:NSLocalizedString(@"Following", nil) forState:UIControlStateNormal];
            [tempButton setBackgroundImage:[UIImage imageNamed:@"following70.png"] forState:UIControlStateNormal];
            
        }
        else{
            [tempArtist setArtistFollowStatus:0];
            //tempButton.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:168.0/255.0 blue:64.0/255.0 alpha:1.0];
            //[tempButton setTitle:NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
            [tempButton setBackgroundImage:[UIImage imageNamed:@"follow70.png"] forState:UIControlStateNormal];


        }
        //
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }];

}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{

    if ([searchTextField isFirstResponder]) {
        return;
    }
    _reloading = YES;
//    [self.view removeGestureRecognizer:tapRecognizer_];
//    searchView.hidden = YES;
//    [searchTextField resignFirstResponder];
//    
//    searchedList = [myList mutableCopy];

    [self fetchMusicList];
    
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
   	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:listTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
        // The user did scroll to the bottom of the scroll view
   [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark
#pragma mark MBProgressHud Methods

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
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField  {
   
    [self.view removeGestureRecognizer:tapRecognizer_];

}

- (void)textFieldDidChange:(UITextField *)textField
{
    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
       [textField resignFirstResponder];
    return  YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.view removeGestureRecognizer:tapRecognizer_];
    searchView.hidden = YES;
    [searchTextField resignFirstResponder];
    
    searchedList = [myList mutableCopy];
    [listTableView reloadData];
    
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

     if (searchStr.length == 0) {
     searchedList = [myList mutableCopy];
     [listTableView reloadData];
     return YES;
     }
    
     NSString* filter = @"%K CONTAINS[cd] %@";
    if (currentMusicListType == MusicListTypeHome) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"artistName",searchStr];
        searchedList = [[myList filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    if (currentMusicListType == MusicListTypeTopTen) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"tracknName",searchStr];
        searchedList = [[myList filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    if (currentMusicListType == MusicListTypeGenre) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"genreName",searchStr];
        searchedList = [[myList filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    if (currentMusicListType == MusicListTypeArtist) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"artistName",searchStr];
        searchedList = [[myList filteredArrayUsingPredicate:predicate] mutableCopy];
    }

    [listTableView reloadData];


    return YES;
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
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [searchedList count];
    
    
}
// custom view for header. will be adjusted to default or specified header height

// Customize the appearance of table view cells...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (currentMusicListType == MusicListTypeHome) {
        
        static NSString *homeTableIdentifier = @"MusicsListHomeCellIdentifier";

        
        BNMHomeTableViewCell *cell = (BNMHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:homeTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BNMHomeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.artistNameLabel.textColor = CELLLABELCOLOR;
            [cell.artistNameLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:17.0]];
            [cell.artistStatusLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
            cell.artistStatusLabel.textColor = CELLLABELCOLOR;
            [cell.artistLatestLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
            cell.artistLatestLabel.textColor = CELLLABELCOLOR;
            cell.userInteractionEnabled = YES;
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
        }
        if (indexPath.row == 0 && searchView.hidden) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg-h.png"]];
        }
        
        BNMMyArtist *currentArtist = (BNMMyArtist *)[searchedList objectAtIndex:indexPath.row];
        [cell setArtistData:currentArtist];
        
        return cell;


    }
    
    if (currentMusicListType == MusicListTypeTopTen) {
        
        static NSString *topTenTableIdentifier = @"MusicsListTopTenCellIdentifier";

        BNMTopTenTableViewCell *cell  = (BNMTopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:topTenTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BNMTopTenTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.trackArtistNameLabel.textColor = CELLLABELCOLOR;
            [cell.trackArtistNameLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:17.0]];
            
            [cell.trackNameLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
            cell.trackNameLabel.textColor = CELLLABELCOLOR;
            cell.userInteractionEnabled = YES;
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
        }
        
        if (indexPath.row == 0 && searchView.hidden) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg-h.png"]];
        }
        if (indexPath.row == 1 && searchView.hidden) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg2.png"]];
        }
        if (indexPath.row == 2 && searchView.hidden) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg3.png"]];
        }

        
        BNMTrack *currentTrack = (BNMTrack *)[searchedList objectAtIndex:indexPath.row];
        [cell setTrackData:currentTrack];
        
        return cell;
        
        
    }
    
    if (currentMusicListType == MusicListTypeGenre) {
        
        static NSString *genreTableIdentifier = @"MusicsListGenreCellIdentifier";
        
        BNMGenreTableViewCell *cell = (BNMGenreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:genreTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BNMGenreTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.genreNameLabel.textColor = CELLLABELCOLOR;
            [cell.genreNameLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:21.0]];
            
            cell.userInteractionEnabled = YES;
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
        }
        
        BNMGenre *currentGenre = (BNMGenre *)[searchedList objectAtIndex:indexPath.row];
        [cell setGenreData:currentGenre];
        
        return cell;
        
        
    }
    
    if (currentMusicListType == MusicListTypeArtist) {
        
        static NSString *artistTableIdentifier = @"MusicsListArtistCellIdentifier";
        
        BNMArtistTableViewCell *cell = (BNMArtistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:artistTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BNMArtistTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.artistNameLabel.textColor = CELLLABELCOLOR;
            [cell.artistNameLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:21.0]];
            
            //[cell.artistFollowStatusButton setTitleColor:CELLLABELCOLOR forState:UIControlStateNormal];
            //[cell.artistFollowStatusButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];

            
            cell.userInteractionEnabled = YES;
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
        }
        
//        if (indexPath.row == 0) {
//            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg-h.png"]];
//        }

        BNMArtist *currentArtist = (BNMArtist *)[searchedList objectAtIndex:indexPath.row];
        [cell setArtistData:currentArtist];
        [cell.artistFollowStatusButton setTag:indexPath.row];
        [cell.artistFollowStatusButton addTarget:self action:@selector(followUnfollowOption:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
        
        
    }



    return nil;


}

// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - TableView Delegate methods
// ----------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (currentMusicListType == MusicListTypeHome) {
        //TABSTOALBUMVIEW
        BNMMyArtist *currentArtist = (BNMMyArtist *)[searchedList objectAtIndex:indexPath.row];
        selectedId = currentArtist.artistId;
        [self performSegueWithIdentifier:@"TABSTOALBUMVIEW" sender:self];
    }
    if (currentMusicListType == MusicListTypeTopTen) {
        BNMPlayerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMPlayerViewController"];
        [controller setCurrentIndex:indexPath.row];
        [controller setPlayerList:searchedList];
        [self.navigationController pushViewController:controller animated:YES];

    }
    if (currentMusicListType == MusicListTypeGenre) {
        BNMGenre *currentGenre = (BNMGenre *)[searchedList objectAtIndex:indexPath.row];
        selectedId = currentGenre.genreId;
        [self performSegueWithIdentifier:@"TABSTOTRACKS" sender:self];
    }
    if (currentMusicListType == MusicListTypeArtist) {
        BNMArtist *currentArtist = (BNMArtist *)[searchedList objectAtIndex:indexPath.row];
        BNMArtistProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMArtistProfileViewController"];
        [controller setCurrentArtist:currentArtist];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"TABSTOALBUMVIEW"]){
        BNMAlbumsViewController *controller = (BNMAlbumsViewController *)segue.destinationViewController;
        if (currentMusicListType == MusicListTypeHome || currentMusicListType == MusicListTypeArtist) {
            [controller setCurrentArtistId:selectedId];
            [controller setIsGenre:NO];

        }

    }
    if ([segue.identifier isEqualToString:@"TABSTOTRACKS"]) {
        
        
        if (currentMusicListType == MusicListTypeGenre) {
            BNMTracksViewController *controller = (BNMTracksViewController *)segue.destinationViewController;
            [controller setCurrentAlbumId:selectedId];
            [controller setIsGenre:YES];
        }
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
