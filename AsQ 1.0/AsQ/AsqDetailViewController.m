//
//  AsqDetailViewController.m
//  AsQ
//
//  Created by drevathy-0847 on 4/28/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsqDetailViewController.h"
#import "MBProgressHUD.h"
#import "AsqListCell.h"
#import "AsqAnsweredPplCell.h"

@interface AsqDetailViewController ()
@property (nonatomic, assign) BOOL votesFetchInProgress;

@end

@implementation AsqDetailViewController

@synthesize asqDetailView, asqObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadView
{
   // [[self navigationController] setNavigationBarHidden:TRUE animated:NO];
    [super loadView];
    
    UIButton *backBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem: customItem];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]];
    
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    
    peopleListArray    =   [[NSMutableArray alloc] init];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    activityIndicator.frame = CGRectMake(0, 0, 320, 480);
    activityIndicator.backgroundColor     = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:activityIndicator];
    [self fetchFriendsList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (id)initWithAsQ:(PFObject *)asq
{
    self = [super initWithStyle:UITableViewStylePlain];
     
    PFQuery *quesQuery = [PFQuery queryWithClassName:kASQParseQuestionClassKey];
    PFObject *questionObj = [quesQuery getObjectWithId:asq.objectId];
    asqObj = questionObj;
    
    
    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    [query whereKey:kASQParseShareDetailsQuestionIdKey equalTo:[PFObject objectWithoutDataWithClassName:kASQParseQuestionClassKey objectId:asq.objectId]];
    [query whereKey:kASQParseShareDetailsSharedUserKey equalTo:[PFUser currentUser]];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
             NSNumber *response  = [object objectForKey:kASQParseShareDetailsResponseKey];
            if(response!=nil &&response!=NULL)
            {
            [asqObj setObject:response forKey:kASQParseShareDetailsResponseKey];
            }
        }
    }];
    
    NSLog(@"questioncontent:::%@",asqObj);

    return self;
}

- (id)initAsQWithContent:(PFObject *)asq referenceClass:(HomeController*) referenceClass
{
    HomeVc = referenceClass;
    asqObj = asq;
    return self;
}
- (id)initWithAsQ:(UIView *)asqView asqObject: (PFObject *) sharedTo
{
    self = [super initWithStyle:UITableViewStylePlain];
    asqDetailView = asqView;
    return self;
}


-(void) getUserRow : (NSArray *)shareObjects
{
    __block int i = 1;
    for (PFObject *userObj in shareObjects) {
        
            PFObject *ques = [userObj objectForKey:kASQParseShareDetailsQuestionIdKey];
            NSNumber *pollType = [ques objectForKey:kASQParseQuestionPollTypeKey];
            int anonymous = [(NSNumber*)[ques objectForKey:kASQParseQuestionAllowUnknownKey] intValue];
            [userObj addObject:pollType forKey:kASQParseQuestionPollTypeKey];
            if(shareObjects!=NULL && anonymous!=1)
            {   
                [peopleListArray addObject:userObj];
            }
            if(i==[peopleListArray count])
            {
                self.tableView.hidden  =  ([peopleListArray count] > 0) ? NO : YES;
                activityIndicator.hidden  =  ([peopleListArray count] > 0) ? YES : NO;
                [activityIndicator stopAnimating];
                [self.tableView reloadData];
            }
            i++;
    }
}

-(void) fetchFriendsList
{
    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    [query includeKey:kASQParseShareDetailsQuestionIdKey];
    [query orderByDescending:@"updatedAt"];
    // Create the question object
    PFObject *ques = [PFObject objectWithClassName:kASQParseQuestionClassKey];
    ques.objectId = asqObj.objectId;
    [query whereKey:kASQParseShareDetailsQuestionIdKey equalTo:ques];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *shareObjects, NSError *error)
     {
         if (!error)
         {
             [self getUserRow:shareObjects];
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
    return [peopleListArray count]+1;   //count of section
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *asqDetailCell  = @"asqDetailCell";
    static NSString *peopleCell     = @"peopleCell";
    
    int feedIndex = [indexPath indexAtPosition:[indexPath length] - 1];
    if(feedIndex==0)
    {
        AsqListCell *cell = [tableView dequeueReusableCellWithIdentifier:asqDetailCell];
        if (cell == nil)
        {
            cell = [[AsqListCell alloc] initCell:asqDetailCell referenceClass:HomeVc];

        }
        [cell setupPollValues:asqObj nonDetail:(BOOL*)1];
        return cell;
    }
    else
    {
        int anonymous = [(NSNumber*)[asqObj objectForKey:kASQParseQuestionAllowUnknownKey] intValue];
        if(anonymous!=1)
        {
            AsqAnsweredPplCell *cell = [tableView dequeueReusableCellWithIdentifier:peopleCell];
            if (cell == nil)
            {
                cell = [[AsqAnsweredPplCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
            }
            NSLog(@"response:::::%@",[asqObj objectForKey:kASQParseShareDetailsResponseKey]);
            [cell setupVotedPeople:[peopleListArray objectAtIndex:feedIndex-1] thisPersonvote:[asqObj objectForKey:kASQParseShareDetailsResponseKey]];
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:nil];
            }
            UIView *anonymousView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            anonymousView.backgroundColor     = [UIColor clearColor];
            UILabel  *textLabel               = [[UILabel alloc] initWithFrame:CGRectMake(00, 0, 320, 20)];
            [textLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:16.0f ]];
            textLabel.text                    = @"Votes are anonymous!";
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.textAlignment = NSTextAlignmentCenter;
            [anonymousView addSubview:textLabel];
            if(feedIndex==1)
            {
                [cell.contentView addSubview:anonymousView];
            }
            return cell;
        }
        
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat totalHeight = 10;
    if (indexPath.row==0) {
        totalHeight = 10 + 35 + 10 + 0 + 10 + 10 + 60 + 10 + 35 +10;
    PFObject *object =   asqObj;
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
    else
    {
        totalHeight=40;
    }
    return totalHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
