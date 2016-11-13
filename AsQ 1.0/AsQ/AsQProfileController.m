//
//  AsQProfileController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsQProfileController.h"
#import "SVPullToRefresh.h"
#import "AsQListCell.h"

@interface AsQProfileController ()

@end

@implementation AsQProfileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle

-(void) loadView
{
    [[self navigationController] setNavigationBarHidden:TRUE animated:NO];
    [super loadView];
    NSLog(@"self.navigationController loadview");
    UIButton *backBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem: customItem];

//    loadProfileForUser = [PFUser currentUser];
    NSLog(@"loadProfileForUser %@",loadProfileForUser);
    if(loadProfileForUser==[PFUser currentUser])
    {
        UIButton *logoutBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *logoutBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
        [logoutBtn setBackgroundImage:logoutBtnImage forState:UIControlStateNormal];
        [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:13];

        [logoutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.frame = CGRectMake(0, 0, 50, 44);
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
        self.navigationItem.rightBarButtonItem = logoutButton;
    }
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]];
    
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];

    [self initialSetup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Local Methods

-(void) initialSetup
{
    // create asqlist array 
    asqListArray    =   [[NSMutableArray alloc] init];
    
    // Create table to list poll
    asqList_tableview               =   [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-45) style:UITableViewStylePlain];
    asqList_tableview.delegate      =   self;
    asqList_tableview.dataSource    =   self;
    asqList_tableview.hidden        =   NO;
    //asqList_tableview.rowHeight     =   370;

    asqList_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    asqList_tableview.backgroundColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];

    __weak AsQProfileController *dp = self;
    
    [asqList_tableview addPullToRefreshWithActionHandler:^{

        [dp fetchPollList];
    }];
    
    
    [self.view addSubview:asqList_tableview];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    activityIndicator.frame = CGRectMake(0, 0, 320, 480);
    activityIndicator.backgroundColor     = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:activityIndicator];
    self.view.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [[self navigationController] setNavigationBarHidden:FALSE animated:YES];
    
    
    noDataView                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    noDataView.backgroundColor     = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    UILabel *NoAsqLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 50.0, 150.0, 20.0)];
    [NoAsqLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:16.0f ]];
    NoAsqLabel.text=@"No AsQ till now!";
    [noDataView addSubview:NoAsqLabel];
}

-(void) getProfileInfo : (UITableViewCell *)cell
{
    //Profile view
    UIView *profileViewBg = [[UIView alloc] initWithFrame:CGRectMake(20, 16, 281.0f, 108.0f)];
    profileViewBg.backgroundColor = [UIColor colorWithRed:185.0/255 green:185.0/255 blue:185.0/255 alpha:1.0];
    UIView *profileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280.0f, 106.0f)];
    profileView.backgroundColor = [UIColor whiteColor];
    
    //Getting profile image
   // PFUser *user = loadProfileForUser;
    NSString *oldPath  = @"http://graph.facebook.com/";
    oldPath = [oldPath stringByAppendingFormat:@"%@/picture", [loadProfileForUser objectForKey:@"facebookId"]];
    NSURL *oldUrl = [NSURL URLWithString:oldPath];
    PFImageView*  bgAvatarImageView = [[PFImageView alloc] initWithFrame:CGRectMake(7, 6, 53, 53)];
    [ASQUtility downloadImageInImageView:bgAvatarImageView withURL:oldUrl];
    
    NSString *path  = @"http://graph.facebook.com/";
    path = [path stringByAppendingFormat:@"%@/picture?width=180&height=180", [loadProfileForUser objectForKey:@"facebookId"]];
    NSURL *url = [NSURL URLWithString:path];
    
    PFImageView*  avatarImageView = [[PFImageView alloc] initWithFrame:CGRectMake(7, 6, 53, 53)];
    [ASQUtility downloadImageInImageView:avatarImageView withURL:url];
    [avatarImageView.layer setMasksToBounds:YES];
    [avatarImageView.layer setCornerRadius:5.0f];
  
    UILabel *profileName   = [[UILabel alloc] initWithFrame:CGRectMake(70, 16, 200, 20)];
    profileName.text       = [loadProfileForUser objectForKey:kASQParseUserDisplayNameKey];
    profileName.textColor  = [UIColor colorWithRed:121.0/255 green:176.0/255 blue:215.0/255 alpha:1.0];
    [profileName setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:16.0f ]];
    
    UILabel *profileEmail   = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, 180, 15)];
    
    timeIntervalFormatter       = [[TTTTimeIntervalFormatter alloc] init];
    NSTimeInterval timeInterval = [loadProfileForUser.createdAt timeIntervalSinceNow];
    NSString *timestamp         = [timeIntervalFormatter stringForTimeInterval:timeInterval];
    NSString *joinedSince       = [@"Joined " stringByAppendingString:timestamp];
    [profileEmail setText:joinedSince];
    
    profileEmail.textColor  = [UIColor colorWithRed:121.0/255 green:176.0/255 blue:215.0/255 alpha:1.0];
    [profileEmail setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:13.0f ]];
    
    UIView *countsBg = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 280.0f, 36.0f)];
    countsBg.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    
    UIView *countsSeperator = [[UIView alloc] initWithFrame:CGRectMake(132.0f, 0, 2.0f, 36.0f)];
    countsSeperator.backgroundColor = [UIColor colorWithRed:227.0/255 green:227.0/255 blue:227.0/255 alpha:1.0];
    
    [countsBg addSubview:countsSeperator];
    
    [profileViewBg addSubview:profileView];
    [profileView addSubview:bgAvatarImageView];
    [profileView addSubview:avatarImageView];
    [profileView addSubview:profileName];
    [profileView addSubview:profileEmail];
    [profileView addSubview:countsBg];
    //[self.view addSubview:profileViewBg];
    [cell.contentView addSubview:profileViewBg];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"cellview::: %@",cell);
    //return cell;
}

#pragma mark - logout method to user logout session
- (void)logOut {
    // clear cache
    [[ASQCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kASQParseUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kASQParseUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by clearing the channels key (leaving only broadcast enabled).
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kASQParseInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kASQParseInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Log out
    [PFUser logOut];
    
    if([PFUser currentUser]==NULL)
    {
        LoginViewController* login_vc    =   [[LoginViewController alloc] init];
        UINavigationController* nav      =   [[UINavigationController alloc] initWithRootViewController:login_vc];
        [self presentModalViewController:nav animated:YES];
        [login_vc.navigationController setNavigationBarHidden:YES];
    }
}

#pragma mark - getting the row of data of particular questionid

-(void) getQuestionRow : (NSArray *)shareObjects
{
    __block int i = 1;
    for (PFObject *quesObj in shareObjects) {
        NSNumber *response  = [quesObj objectForKey:kASQParseShareDetailsResponseKey];
        NSObject *createdAt = [quesObj createdAt];
        NSLog(@"createdAt::: %@",[quesObj objectForKey:@"column"]);
        PFObject *object = [quesObj objectForKey:@"parentQuestion"];
            if(object!=NULL)
            {
                //adding a object from shareDetails table
                //Since the response made by the user is in the shareDetails table
                if(response!=Nil)
                {
                    [object setObject:response forKey:@"response"];
                }
                [object setObject:createdAt forKey:@"createdAt"];
                [asqListArray addObject:object];
            }
            if(i==[asqListArray count])
            {
                asqList_tableview.hidden  =  ([asqListArray count] > 0) ? NO : YES;
                activityIndicator.hidden  =  ([asqListArray count] > 0) ? YES : NO;
                [activityIndicator stopAnimating];
                [asqList_tableview reloadData];
            }
            i++;
    }
}

#pragma mark - loadProfileForUser
-(id) loadProfile : (PFUser*) forUser
{
    loadProfileForUser = forUser;
    [self fetchPollList];
    return self;
}

#pragma mark - to fetch shared polls for user param

-(void) fetchPollList
{
    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    [query includeKey:kASQParseShareDetailsQuestionIdKey];
    [query orderByAscending:kASQParseShareDetailscreatedTimeKey];

    //****** Applying criteria here for user ******//
    if(loadProfileForUser!=NULL)
    {
        [query whereKey:kASQParseShareDetailsSharedUserKey equalTo:[PFUser currentUser] ];
        [query whereKey:kASQParseShareDetailsOwnerIdKey equalTo:loadProfileForUser];
    }
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *shareObjects, NSError *error)
     {
         if (!error)
         {
             NSLog(@"shareObjects:::%d",[shareObjects count]);
             if([shareObjects count]!=0 || [asqListArray count]!=0)
             {
                 noDataView.hidden = YES;
             }
             else
             {
                 noDataView.hidden = NO;
                 [activityIndicator stopAnimating];
             }
             [asqList_tableview.pullToRefreshView stopAnimating];
             [self getQuestionRow: shareObjects];
         } else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;   //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [asqListArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *asqCell        = @"asqCell";
    static NSString *profileCell    = @"profileCell";
    
    int feedIndex = [indexPath indexAtPosition:[indexPath length] - 1];
    if(feedIndex!=0)
    {
        PFObject*   asq_obj =   [asqListArray objectAtIndex:feedIndex-1];
        AsqListCell *cell = [tableView dequeueReusableCellWithIdentifier:asqCell];
        if (cell == nil)
        {
            cell = [[AsqListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:asqCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setupPollValues:asq_obj nonDetail:(BOOL*)0];
        return cell;
    }
    else
    {
        NSLog(@"comes here...%@",loadProfileForUser);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:profileCell];
        }
        [self getProfileInfo:cell];
        return cell;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat totalHeight = 10 + 35 + 10 + 0 + 10 + 10 + 60 + 10 + 35 + 10;
    if(indexPath.row!=0)
    {
        PFObject *object =   [asqListArray objectAtIndex:indexPath.row-1];
        NSString *content = [object objectForKey:@"content"];
        CGSize constraint = CGSizeMake(296,9999);
        CGSize size = [content sizeWithFont:[UIFont boldSystemFontOfSize:16.0]
                       constrainedToSize:constraint
                           lineBreakMode:UILineBreakModeWordWrap];
        totalHeight += size.height;

        if(((NSString*)[object objectForKey:@"pollType"]).intValue==0)
        {
            NSArray *optionArray =(NSArray*)[object objectForKey:@"choices"];
            totalHeight += ([optionArray count]*45.0f)-70.0f;
        }

        PFFile *imageFile = [object objectForKey:@"image"];
        if (imageFile) {
            totalHeight += 306;
        }
    }
    else
    {
        totalHeight = 140;
    }
    return totalHeight;
}

#pragma mark - TableView Delegates

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}

#pragma mark - Memory Managment

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
