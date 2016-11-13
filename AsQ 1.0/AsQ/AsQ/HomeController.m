//
//  HomeController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "HomeController.h"
#import "DDMenuController.h"
#import "AsQProfileController.h"
#import "AsQNoficationController.h"
#import "AsQCreatePoll.h"
#import "SVPullToRefresh.h"
#import "AsqListCell.h"
#import "AsqDetailViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface HomeController ()

@end

@implementation HomeController

@synthesize badgeValue, flag, count, detailViewTag , asqList_tableview, asqListArray, hud, notificsBtn;

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
    
    UIButton *addBtn =[[UIButton alloc] init];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addPlusButton.png"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(5, 5, 44, 44);
    
    UIBarButtonItem *add =[[UIBarButtonItem alloc] initWithCustomView:addBtn];
    [addBtn addTarget:self action:@selector(addPoll) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = add;

    notificsBtn           = [[UIButton alloc] init];
    notificsBtn.frame = CGRectMake(10, 10, 44, 44);
    notificsBtn.layer.cornerRadius = 12.0f;
    
    notificsBtn.layer.cornerRadius = 5.0f;
    notificsBtn.layer.contentsRect = CGRectMake(0, 0, 22.0f, 20.0f);

    //notificsBtn.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:95.0/255.0 blue:128.0/255.0 alpha:1];
    badgeValue = 0;
    NSLog(@"badgeValue::::%d", badgeValue);
    UIBarButtonItem *notifics   = [[UIBarButtonItem alloc] initWithCustomView: notificsBtn];
    [notificsBtn addTarget:self action:@selector(showNotifications) forControlEvents:UIControlEventTouchUpInside];
    [notificsBtn setImage:[UIImage imageNamed:@"noti-center.png"] forState:UIControlStateNormal];
    
    PFUser *user    = [PFUser currentUser];
    NSString *path  = @"http://graph.facebook.com/";
    path = [path stringByAppendingFormat:@"%@/picture", [user objectForKey:kASQParseUserFacebookIDKey]];
    NSURL *url = [NSURL URLWithString:path];
    
    UIImageView*  avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [ASQUtility downloadImageInImageView:avatarImageView withURL:url];
    [avatarImageView.layer setMasksToBounds:YES];
    [avatarImageView.layer setCornerRadius:3.0f];
    
    UIButton *profIleBtn =[[UIButton alloc] init];
    profIleBtn.frame = CGRectMake(0, 3, 34, 34);
    profIleBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile.png"]];
    [profIleBtn addSubview:avatarImageView];
    [profIleBtn.layer setCornerRadius:3.0f];

    UIBarButtonItem *profile =[[UIBarButtonItem alloc] initWithCustomView:profIleBtn];
    [profIleBtn addTarget:self action:@selector(goToProfile) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = 
    [NSArray arrayWithObjects:profile, notifics, nil];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]];
    [self setNotificationBadge];
    [self initialSetup];
}

- (void)viewDidLoad
{
    self.queue = [[NSOperationQueue alloc] init];
//    self.queue.maxConcurrentOperationQueue = 4;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Local Methods

-(void) initialSetup
{
    AsQquery = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    loadMoreCount = 1;
    // create asqlist array
    asqIdListArray      = [[NSMutableArray alloc] init];
    newAsqIdListArray   = [[NSMutableArray alloc] init];
    asqListArray        = [[NSMutableArray alloc] init];
    newAsqListArray     = [[NSMutableArray alloc] init];
    
    // Create table to list poll
    asqList_tableview               =   [[UITableView alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width, self.view.frame.size.height-45) style:UITableViewStylePlain];
    asqList_tableview.delegate      =   self;
    asqList_tableview.dataSource    =   self;
    asqList_tableview.hidden        =   YES;

    asqList_tableview.backgroundColor   = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    asqList_tableview.separatorStyle    = UITableViewCellSeparatorStyleNone;
    
    __weak HomeController *dp = self;
    [asqList_tableview addPullToRefreshWithActionHandler:^{
        [dp fetchPollList];
    }];
    
    [self.view addSubview:asqList_tableview];
    
    self.view.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud setLabelText:@"Loading"];
    [self.hud setDimBackground:YES];
    
    noDataView                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    noDataView.backgroundColor     = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    UIImageView*    imgView        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata.png"]];
    [noDataView addSubview:imgView];
    noDataView.hidden              =  YES;
    [self.view addSubview:noDataView];
    [[self navigationController] setNavigationBarHidden:FALSE animated:YES];
    //[self fetchPollList];
}

-(void) refreshCellData : (PFObject*) quesObj
{
    NSLog(@"asqIdListArray::: %@",asqIdListArray);
    NSString* quesId = (NSString *)quesObj.objectId;
    NSUInteger index = [asqIdListArray indexOfObject:quesId];
    NSLog(@"indexofquid::: %d",index);
    [asqListArray replaceObjectAtIndex:index withObject:quesObj];
    NSLog(@"asqListArray::: %@",[asqListArray objectAtIndex:index]);
    NSLog(@"refreshCellData called successfully %@",quesObj);
    [asqList_tableview reloadData];
}

-(void) setNotificationBadge
{
    NSLog(@"notification badge has been called:::%d",badgeValue);
    if(badgeValue!=0)
    {
        NSLog(@"inside badgeValue::::%d", badgeValue);
        NSString *notification = [NSString stringWithFormat:@"%d",badgeValue];
        [notificsBtn setTitle:notification forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"outside badgeValue::::%d", badgeValue);
        [notificsBtn setImage:[UIImage imageNamed:@"noti-empty.png"] forState:UIControlStateNormal];
    }
    notificsBtn.titleLabel.font = [UIFont systemFontOfSize:12];

}

-(void) goToProfile
{
    AsQProfileController *profileViewController = [[AsQProfileController alloc] loadProfile:[PFUser currentUser]];
    [self.navigationController pushViewController:profileViewController animated:YES];

}

-(void) showNotifications
{
    NSLog(@"showNotifications");
    AsQNoficationController* notification_vc        =   [[AsQNoficationController alloc] init];
    UINavigationController* nav                     =   [[UINavigationController alloc] initWithRootViewController:notification_vc];
    [self presentModalViewController:nav animated:YES];
}

-(void) addPoll
{
    AsQCreatePoll* create_vc        =   [[AsQCreatePoll alloc] init];
    create_vc.delegate              =   self;
    UINavigationController* nav     =   [[UINavigationController alloc] initWithRootViewController:create_vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - sending poll data to save in DB

-(void) pollSaveToDB:(NSMutableDictionary*) asqDictionary withArray: (NSMutableArray*) sharedTo
{
    NSNumber *ownerFbId  = (NSNumber *)[[PFUser currentUser] objectForKey:kASQParseUserFacebookIDKey];
    
    PFObject *question = [PFObject objectWithClassName:kASQParseQuestionClassKey];
    [question setObject:[PFUser currentUser] forKey:kASQParseQuestionAskedByKey];
    
    NSData *data = (NSData *)[asqDictionary objectForKey:@"imageData"];

    NSString *questionContent = [asqDictionary objectForKey: @"question"];
    if([((NSString*)[asqDictionary objectForKey: @"question"]) rangeOfString:@"\u200B"].length > 0){
        questionContent = [[((NSString*)[asqDictionary objectForKey: @"question"]) componentsSeparatedByString:@"\u200B"] objectAtIndex:1];
    }
    int voteType = [(NSNumber*)[asqDictionary objectForKey: @"voteType"] intValue];
    
    if(voteType==0)
    {
        NSArray *options = [asqDictionary objectForKey: @"optionsArray"];
        if([options count]!=0)
        {
            [question setObject:[asqDictionary objectForKey: @"optionsArray"] forKey:kASQParseQuestionChoicesKey];
        }
        else
        {
                [question setObject:[NSNumber numberWithInt:1] forKey:kASQParseQuestionPollTypeKey];
        }
    }
    [question setObject:[asqDictionary objectForKey: @"voteType"] forKey:kASQParseQuestionPollTypeKey];
    [question setObject:[asqDictionary objectForKey: @"allowUnknown"] forKey:kASQParseQuestionAllowUnknownKey];
    [question setObject:[asqDictionary objectForKey: @"authorName"] forKey:kASQParseQuestionAuthorNameKey];
    [question setObject:ownerFbId forKey:kASQParseQuestionownerFbIdKey];
    
    [question setObject:questionContent forKey:kASQParseQuestionContentKey];
    
    NSNumber *zero = [NSNumber numberWithInt:0];
    NSNumber *askedTo = [NSNumber numberWithInt:[sharedTo count]+1];
    [question setObject: zero forKey:kASQParseQuestionOpt0Key];
    [question setObject: zero forKey:kASQParseQuestionOpt1Key];
    [question setObject: zero forKey:kASQParseQuestionOpt2Key];
    [question setObject: zero forKey:kASQParseQuestionOpt3Key];
    [question setObject: zero forKey:kASQParseQuestionAnsCountKey];
    [question setObject: zero forKey:kASQParseQuestionFreezeKey];
    [question setObject:askedTo forKey:kASQParseQuestionAskedToKey];
    
    if(data)
    {
        PFFile *file = [PFFile fileWithName:@"image_data.jpg" data:data];
        [question setObject:file forKey:kASQParseQuestionImageKey];
    }
   
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicWriteAccess:YES];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    question.ACL = defaultACL;
    [question saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        [asqDictionary setValue:question.objectId forKey:@"questionId"];
        [self saveShareDetails:asqDictionary shareIdArray: sharedTo];
        [self getNewQuestionRow:question];
        asqList_tableview.hidden = NO;
        [asqList_tableview reloadData];
    }];

    //NSLog(@"poll related data %@",[asqDictionary objectForKey: @"questionType"]);
}

#pragma mark - storing shared details in table

-(void) saveShareDetails:(NSMutableDictionary *) shareDictionary shareIdArray: (NSMutableArray*) sharedTo
{
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicWriteAccess:YES];
    [defaultACL setPublicReadAccess:YES];
    
    PFObject *shareDetailsForSelf = [PFObject objectWithClassName:kASQParseShareDetailsClassKey];
      [shareDetailsForSelf setObject:[PFUser currentUser] forKey:kASQParseShareDetailsOwnerIdKey];
      [shareDetailsForSelf setObject:(NSNumber *)[[PFUser currentUser] objectForKey:kASQParseUserFacebookIDKey] forKey:kASQParseShareDetailsSharedToKey];
    [shareDetailsForSelf setObject:[PFUser currentUser] forKey:kASQParseShareDetailsSharedUserKey];
    
    [shareDetailsForSelf setObject:(NSString *)[[PFUser currentUser] objectForKey:kASQParseUserDisplayNameKey] forKey:kASQParseShareDetailsPersonNameKey];
    
    PFObject *ques = [PFObject objectWithClassName:kASQParseQuestionClassKey];
    ques.objectId = [shareDictionary objectForKey:@"questionId"];
    
    //Add a relation between the question and sharedetails
    [shareDetailsForSelf setObject:ques forKey:kASQParseShareDetailsQuestionIdKey];
    
    [shareDetailsForSelf setObject:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:kASQParseShareDetailscreatedTimeKey];
    
    shareDetailsForSelf.ACL = defaultACL;
    [shareDetailsForSelf saveInBackgroundWithBlock:^(BOOL success, NSError *error) {        
        NSLog(@"Saved share for self");
    }];

    for(int i=0; i<[sharedTo count]; i++)
    {
        PFObject *shareDetails = [PFObject objectWithClassName:kASQParseShareDetailsClassKey];
        [shareDetails setObject:[PFUser currentUser] forKey:kASQParseShareDetailsOwnerIdKey];
        [shareDetails setObject:(NSNumber *)[[sharedTo objectAtIndex:i] objectForKey:@"facebookId"] forKey:kASQParseShareDetailsSharedToKey];
        [shareDetails setObject:[sharedTo objectAtIndex:i] forKey:kASQParseShareDetailsSharedUserKey];
        
        [shareDetails setObject:(NSString *)[[sharedTo objectAtIndex:i] objectForKey:@"displayName"] forKey:kASQParseShareDetailsPersonNameKey];
        
        PFObject *ques = [PFObject objectWithClassName:kASQParseQuestionClassKey];
        ques.objectId = [shareDictionary objectForKey:@"questionId"];
        
        //Add a relation between the question and sharedetails
        [shareDetails setObject:ques forKey:kASQParseShareDetailsQuestionIdKey];
        [shareDetails setObject:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:kASQParseShareDetailscreatedTimeKey];
    
        shareDetails.ACL = defaultACL;
        [ASQUtility sendAsqPushNotification:ques forUser:[sharedTo objectAtIndex:i]];
        [shareDetails saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            NSLog(@"Saved share to friends : %i",success);
        }];
    }
}

- (void)addObjectUnique:(id)anObject
{
    if ([asqListArray containsObject:anObject]) {
        return;
    }
    [asqListArray addObject:anObject];
}


#pragma mark - getting the row of data of particular questionid

-(void) getQuestionRow : (NSArray *)shareObjects
{
    __block int i = 1;
    //NSEnumerator *enumerator = [shareObjects reverseObjectEnumerator];
    //shareObjects             = (NSMutableArray *)[enumerator allObjects];
    //asqIdListArray = nil;
    for (PFObject *quesObj in shareObjects) {
        NSNumber *response  = [quesObj objectForKey:kASQParseShareDetailsResponseKey];
        PFUser *owner = [quesObj objectForKey:kASQParseShareDetailsOwnerIdKey];
        NSNumber *sharedTo  = [quesObj objectForKey:kASQParseShareDetailsSharedToKey];
        NSObject *createdAt = [quesObj createdAt];
        PFObject *object = [quesObj objectForKey:kASQParseShareDetailsQuestionIdKey];
        
        if(object!=NULL)
        {
            //adding a object from shareDetails table
            //Since the response made by the user is in the shareDetails table
            if(response && response!=NULL)
            {
                [object setObject:response forKey:kASQParseShareDetailsResponseKey];
            }
            [object setObject:owner forKey:@"owner"];
            [object setObject:sharedTo forKey:kASQParseShareDetailsSharedToKey];
            [object setObject:createdAt forKey:@"createdAt"];
            [object setObject:quesObj.objectId forKey:@"shareId"];
            NSString* quesIdStr = (NSString *)object.objectId;
            
            if([asqListArray count]>0)
            {
                if(loadMoreCount==1)
                {
                    [asqListArray insertObject:object atIndex:0];
                    [asqIdListArray insertObject:quesIdStr atIndex:0];
                }
                else
                {
                    [asqListArray addObject:object];
                    [asqIdListArray addObject:quesIdStr];
                }
            }
            else if([asqListArray count]!=[shareObjects count])
            {
                [asqIdListArray addObject:quesIdStr];
                [asqListArray addObject:object];
            }
        
        }
        if(i==[shareObjects count])
        {
            asqList_tableview.hidden  =  ([asqListArray count] > 0) ? NO : YES;
            
            
            //activityIndicator.hidden  =  ([asqListArray count] > 0) ? YES : NO;
            //[activityIndicator stopAnimating];
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [asqList_tableview reloadData];
        }
        i++;
    }
}

-(void) getNewQuestionRow : (PFObject *)object
{
    if(object!=NULL)
    {
        NSString *quesIdStr = (NSString *)object.objectId;
//        [asqListArray addObject:object];
        [asqListArray insertObject:object atIndex:0];
        [asqIdListArray addObject:quesIdStr];
        noDataView.hidden = YES;
        [asqList_tableview reloadData];
        [asqList_tableview.pullToRefreshView stopAnimating];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [asqList_tableview scrollsToTop];
}

#pragma mark - to fetch shared polls for the current user

-(void) fetchPollList
{
    [self skipAsqs:0];
    [AsQquery setCachePolicy:kPFCachePolicyNetworkOnly];
    [AsQquery findObjectsInBackgroundWithBlock:^(NSArray *shareObjects, NSError *error)
    {
        if (!error)
        {
            if([shareObjects count]!=0 || [asqListArray count]!=0)
            {
                if(loadMoreCount!=1)
                {
                    NSLog(@"shareObjects::: %@",shareObjects);
                    [self getQuestionRow: shareObjects];
                }
                else
                {
                    NSMutableArray *tmp = [[NSMutableArray alloc] init];
                    for(int x=[shareObjects count] - 1;x>=0; x--){
                        [tmp addObject:[shareObjects objectAtIndex:x]];
                    }
                    [self getQuestionRow: tmp];
                }
                noDataView.hidden = YES;
                [asqList_tableview reloadData];
            }
            else
            {
                noDataView.hidden = NO;
            }
            [asqList_tableview.pullToRefreshView stopAnimating];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void) skipAsqs : (int) skipPage
{
    [AsQquery includeKey:kASQParseShareDetailsQuestionIdKey];
    [AsQquery includeKey:kASQParseShareDetailsOwnerIdKey];
    [AsQquery whereKey:kASQParseShareDetailsSharedUserKey equalTo:[PFUser currentUser]];
    [AsQquery orderByDescending:@"createdAt"];
    if(skipPage==0)
    {
        AsQquery.limit = 15;
    }
    else
    {
        AsQquery.limit = 15;
        AsQquery.skip = skipPage*15;
    }
}

- (void) loadMoreAsqs
{
    [self skipAsqs:loadMoreCount];
    [self fetchPollList];
    loadMoreCount++;
}
#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;   //count of section
}

 - (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    AsqListCell * cell =(AsqListCell*) [asqList_tableview cellForRowAtIndexPath:[indexPaths objectAtIndex:0]];
    NSLog(@"[indexPaths objectAtIndex:0]::: %@",[indexPaths objectAtIndex:0]);
    cell.backgroundColor = [UIColor orangeColor];
//    [self  awillDisplayCell:cell forRowAtIndexPath:[indexPaths objectAtIndex:0]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ( [asqListArray count] < 15 ) {

        return [asqListArray count];
        NSLog(@"count:: %d",[asqListArray count]);
    } else {
        return [asqListArray count] + 1;
        NSLog(@"count:: %d",[asqListArray count]);
    }
}

//-(void) tableView:(UITableView *)tableView willDisplayCell:(AsqListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    flag = YES;
    
    static NSString *MyIdentifier  = @"Myidentifier";
    int index = indexPath.row;
    NSLog(@"[asqListArray count]:::%d::: %d",[asqListArray count],index);
    AsqListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.backgroundColor = [UIColor brownColor];
    NSLog(@"indexpath.row::: %d",indexPath.row);
    if (index != [asqListArray count])
    {
        NSLog(@"count::: %d",indexPath.row);
        
        PFObject*   asq_obj =   [asqListArray objectAtIndex:indexPath.row];
        if (cell == nil)
        {
            cell = [[AsqListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
        }
        
        [cell setupPollValues:asq_obj nonDetail: (BOOL*)0];
    }
    if (index == [asqListArray count])
    {
        if(oldasqListArrayCount == [asqListArray count]){
            if (cell == nil) {
                cell = [[AsqListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:nil];
            }
            // Here we create the ‘End’ cell
            UILabel* loadMore =[[UILabel alloc]initWithFrame: CGRectMake(0,0,342,23)];
            loadMore.textColor = [UIColor lightGrayColor];
            loadMore.highlightedTextColor = [UIColor lightGrayColor];
            loadMore.backgroundColor = [UIColor clearColor];
            [loadMore setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:18.0f ]];
            loadMore.textAlignment=UITextAlignmentCenter;
            loadMore.text=@"●";
            [cell addSubview:loadMore];

        }
        else{
            
            if (cell == nil) {
                cell = [[AsqListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:nil];
            }
            // Here we create the ‘Load more’ cell
            UILabel* loadMore =[[UILabel alloc]initWithFrame: CGRectMake(0,0,342,23)];
            loadMore.textColor = [UIColor lightGrayColor];
            loadMore.highlightedTextColor = [UIColor lightGrayColor];
            loadMore.backgroundColor = [UIColor clearColor];
            [loadMore setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
            loadMore.textAlignment=UITextAlignmentCenter;
            loadMore.text=@"● ● ●";
            [cell addSubview:loadMore];
            [self loadMoreAsqs];
            oldasqListArrayCount = [asqListArray count];
        }
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat totalHeight = 45;
    int index = indexPath.row;
    if (index != [asqListArray count])
    {
        totalHeight = 10 + 35 + 10 + 0 + 10 + 10 + 60 + 10 + 35 +10;
    PFObject *object =   [asqListArray objectAtIndex:indexPath.row];
    NSString *content = [object objectForKey:@"content"];
    CGSize constraint = CGSizeMake(296,9999);
    CGSize size = [content sizeWithFont:[UIFont boldSystemFontOfSize:16.0]
                   constrainedToSize:constraint
                       lineBreakMode:UILineBreakModeWordWrap];
    totalHeight += size.height;// [content sizeWithFont:[UIFont boldSystemFontOfSize:14.0] forWidth:300 lineBreakMode:UILineBreakModeWordWrap].height;
    
    
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
    return totalHeight;
}
    

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row != [asqListArray count] ) {
    AsqListCell *currentCell = (AsqListCell *)[tableView cellForRowAtIndexPath:indexPath];
    PFObject* asqObj = (PFObject *)[asqListArray objectAtIndex:indexPath.row];
    PFObject *activity = [asqListArray objectAtIndex:indexPath.row];
        NSLog(@"currentCell.cellTag::: %d",currentCell.cellTag);
    if(currentCell.cellTag == 3)
    {
        AsQProfileController *profileViewController = [[AsQProfileController alloc] loadProfile:[asqObj objectForKey:@"owner"]];
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
    if (currentCell.cellTag==2 || currentCell.cellTag==4) {
        
        if ([activity objectForKey:kASQParseQuestionAnsCountKey]) {
            AsqDetailViewController *detailViewController = [[AsqDetailViewController alloc] initAsQWithContent:asqObj referenceClass :self];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    }
    
//    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
//    //NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:2 inSection:1];
//    // Add them in an index path array
//    NSArray* indexArray = [NSArray arrayWithObjects:indexPath1,nil];
//    
//    [asqList_tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
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
