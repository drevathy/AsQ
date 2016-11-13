//
//  FriendsView.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 22/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "FriendsView.h"
#import "SVPullToRefresh.h"
#import "FriendListCell.h"
#import "AsQCreatePoll.h"


@interface FriendsView ()

@end

@implementation FriendsView

@synthesize selectedMembers_array;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    //self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

#pragma mark - View Life Cycle

-(void) loadView
{
   // groupMembers = [[NSMutableArray alloc] init];
    //[super loadView];
    
    //self.title          =   @"Choose Friends";
    CGFloat nRed        =   238.0/255.0;
    CGFloat nBlue       =   238.0/255.0;
    CGFloat nGreen      =   238.0/255.0;
    self.backgroundColor   =   [[UIColor alloc]initWithRed:nRed green:nBlue blue:nGreen alpha:1];
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]];
    
    UIBarButtonItem *back;
    back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(dismissView)];
    back.tag=0;
    
    UIBarButtonItem *edit;
    edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(backToEditPoll)];
    edit.tag=1;
    
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:back, nil];
//    self.navigationItem.rightBarButtonItem   =   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pollNext)];

    [self initialSetup];
    
    [self getFriendsList];
    
}

#pragma mark - Local methods

-(void) initialSetup
{
    // create friendslist array
    friendListArray    =   [[NSMutableArray alloc] init];
    
    selectedMembers_array    =   [[NSMutableArray alloc] init];
    
    // Create table to list friends
    friendList_tableview               =   [[UITableView alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    friendList_tableview.delegate      =   self;
    friendList_tableview.dataSource    =   self;
    friendList_tableview.hidden        =   YES;
    
    friendList_tableview.backgroundColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    
    NSLog(@"[friendList_tableview isDescendantOfView:self]::: %c",[self.subviews containsObject:friendList_tableview]);
    if([friendListArray count]!=0)
    {
        [friendList_tableview reloadData];
    }
    else
    {
        [self addSubview:friendList_tableview];
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc]
                                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(160, 20, 320, 40)];
    [view addSubview:activityIndicator]; 
    [self addSubview:view];
    
    noFriendsView                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
    noFriendsView.backgroundColor     = [UIColor colorWithRed:23.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    UILabel  *textLabel               = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 320, 20)];
    textLabel.text                    = @"No friends there!";
    noFriendsView.hidden              =  YES;
    [noFriendsView addSubview:textLabel];
    [self addSubview:noFriendsView];
}

-(void) getFriendsList
{    
    // Issue a Facebook Graph API request to get your user's friend list
    PF_FBRequest *request = [PF_FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            //NSLog(@"%@",friendObjects);
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookId" containedIn:friendIds];
            // findObjects will return a list of PFUsers that are friends
            // with the current user
           // NSArray *friendUsers = [friendQuery findObjects];
            __block int i = 1;
            for (PFObject *quesObj in [friendQuery findObjects]) {
                [quesObj fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if(object!=NULL)
                    {
                        [friendListArray addObject:object];
                        [activityIndicator stopAnimating]; // Hide loading indicator
                    }
                    if(i==[friendListArray count])
                    {
                        [[[activityIndicator subviews] objectAtIndex:0] stopAnimating];
                        [activityView removeFromSuperview];
                        activityView = nil;
                        friendList_tableview.hidden  =  ([friendListArray count] > 0) ? NO : YES;
                        noFriendsView.hidden         =  ([friendListArray count] > 0) ? YES : NO;
                        [friendList_tableview reloadData];
                    }
                    i++;
                }];
            }
            
            //[friendListArray addObject:[friendQuery findObjects]];
        }
    }];
}
- (void)viewDidLoad
{
    //[super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) dismissView
{
    //[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;   //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"friendListArray %d",[friendListArray count]);
    return [friendListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MyIdentifier  = @"Myidentifier";
    
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.accessibilityFrame = CGRectMake(0.0f, 2.0f, 320.0f,20.0f);
     PFObject*   friend_obj =   [friendListArray objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:nil];
       cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImage *image = [UIImage imageNamed:@"unselectfriend.png"];
        
        UIButton *checkmarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [checkmarkBtn setImage:image forState:UIControlStateNormal];
        [checkmarkBtn setFrame:CGRectMake(0, 0, 19, 19)];
        [checkmarkBtn setBackgroundColor:[UIColor clearColor]];
        cell.accessoryView = checkmarkBtn;
        if([selectedMembers_array containsObject:[friendListArray objectAtIndex:indexPath.row]])
        {
            [self makeCellSelected:cell doSelect:(BOOL)1];
        }
        [cell setupFriendsView:friend_obj];
    }
    cell.accessoryView.hidden = NO;
    return cell;
}

#pragma mark - select a cell
-(void) makeCellSelected : (UITableViewCell*) cell doSelect:(BOOL) wannaSelect
{
    UIImage *select = [UIImage imageNamed:@"selectfriend.png"];
    UIImage *unselect = [UIImage imageNamed:@"unselectfriend.png"];
    
    NSArray *selectImgs = [NSArray arrayWithObjects:unselect,select, nil];
    cell.accessoryView.hidden = NO;
    UIImage *image = [selectImgs objectAtIndex:wannaSelect];
    UIButton *checkmarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkmarkBtn setImage:image forState:UIControlStateNormal];
    [checkmarkBtn setFrame:CGRectMake(0, 0, 19, 19)];
    [checkmarkBtn setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView = checkmarkBtn;

}
#pragma mark - TableView Delegates

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListCell *cell = (FriendListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType      =  (cell.accessoryType == UITableViewCellAccessoryCheckmark)?UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
    
    if(cell.accessoryType == 0)
    {
        [self makeCellSelected:cell doSelect:(BOOL)1];
        [selectedMembers_array addObject:[friendListArray objectAtIndex:indexPath.row]];
    }else
    {
        [self makeCellSelected:cell doSelect:(BOOL)0];
        [selectedMembers_array removeObject:[friendListArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Memory Managment

- (void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
