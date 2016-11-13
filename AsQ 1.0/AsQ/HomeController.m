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
#import "AsQCreatePoll.h"
#import "SVPullToRefresh.h"
#import "AsqListCell.h"

@interface HomeController ()

@end

@implementation HomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lify Cycle

-(void) loadView
{
    [super loadView];    
    
    // set Navigation Buttons
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(loadProfile)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPoll)];
    
    [self initialSetup];
    
    [self fetchPollList];
    
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
    asqList_tableview               =   [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    asqList_tableview.delegate      =   self;
    asqList_tableview.dataSource    =   self;
    asqList_tableview.hidden        =   YES;
    asqList_tableview.rowHeight     =   300;
    
    __weak HomeController *dp = self;
    
    [asqList_tableview addPullToRefreshWithActionHandler:^{

        [dp fetchPollList];
    }];
    
    [self.view addSubview:asqList_tableview];
    
    noDataView                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    noDataView.backgroundColor     = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    UIImageView*    imgView        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata.png"]];
    [noDataView addSubview:imgView];
    noDataView.hidden              =  NO;
    [self.view addSubview:noDataView];
}

-(void) loadProfile
{
    NSLog(@"profile push");
    
    AsQProfileController* profile_vc    =   [[AsQProfileController alloc] init];
    [self.navigationController pushViewController:profile_vc animated:YES];
}

-(void) addPoll
{
    NSLog(@"Add a new Poll");
    
    AsQCreatePoll* create_vc        =   [[AsQCreatePoll alloc] init];
    create_vc.delegate              =   self;
    UINavigationController* nav     =   [[UINavigationController alloc] initWithRootViewController:create_vc];
    
    [self presentModalViewController:nav animated:YES];
}


-(void) pollRelatedData:(NSDictionary*) asqDictionary
{
    PFObject *question = [PFObject objectWithClassName:kASQParseQuestionClassKey];
    [question setObject:[PFUser currentUser] forKey:kASQParseQuestionAskedByKey];
    //[question setObject:self.photoFile forKey:kASQParseQuestionImageKey];
    
    NSData *data = [asqDictionary objectForKey:@"imageData"];
    
    //NSLog(@"image data : %@",data);
    
    PFFile *file = [PFFile fileWithName:@"image_data.jpg" data:data];
    
    [question setObject:[asqDictionary objectForKey: @"voteType"] forKey:kASQParseQuestionPollTypeKey];
    [question setObject:[asqDictionary objectForKey: @"question"] forKey:kASQParseQuestionContentKey];
    [question setObject:file forKey:@"image"];
    [question saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        
    //NSLog(@"Saved : %i",success);
        
    [self fetchPollList];
           
    }];
    
    //NSLog(@"poll related data %@",[asqDictionary objectForKey: @"questionType"]);
}

-(void) fetchPollList
{
    PFQuery *query = [PFQuery queryWithClassName:kASQParseQuestionClassKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            // The find succeeded.
           // NSLog(@"Successfully retrieved %d scores.", objects.count);
            
            [asqList_tableview.pullToRefreshView stopAnimating];
            
            asqListArray = [objects mutableCopy];
            asqList_tableview.hidden  =  ([asqListArray count] > 0) ? NO : YES;
            noDataView.hidden         =  ([asqListArray count] > 0) ? YES : NO;
            [asqList_tableview reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
    /*PFQuery *query = [PFQuery queryWithClassName:kASQParseQuestionClassKey];

    [query getObjectInBackgroundWithId:@"yFUTRGHS1D" block:^(PFObject* obj, NSError *error){
        
        PFFile* image_file  =   [obj objectForKey:@"image"];
        
        UIImageView*    img =   [[UIImageView alloc] initWithImage:[UIImage imageWithData:image_file.getData]];
        
        [self.view addSubview:img];
    }];
    */
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;   //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [asqListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    AsqListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[AsqListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    PFObject*   asq_obj =   [asqListArray objectAtIndex:indexPath.row];
    
    [cell setupPollValues:asq_obj];
    
    //NSLog(@"---->>> %@",[asq_obj objectForKey:@"content"]);
    //cell.textLabel.text =   [asq_obj objectForKey:@"content"];
    
    return cell;
}

#pragma mark - TableView Delegates

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

#pragma mark - Memory Managment

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
