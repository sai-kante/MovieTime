//
//  MoviesListViewController.m
//  MovieTime
//
//  Created by Sai Kante on 3/15/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "MoviesListViewController.h"
#import "MovieViewCell.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PullRefreshTableViewController.h"
#import "MBProgressHUD.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface MoviesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *MoviesList_VC;
@property (weak, nonatomic) IBOutlet UIView *NetError;
@property (strong, nonatomic) NSArray *moviesList;

@end

@implementation MoviesListViewController
{
    UIRefreshControl *refresh;
    MBProgressHUD *progressHUD;
}

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
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.NetError.alpha=0;
    self.title=@"MoviesList";
    self.moviesList=[[NSArray alloc] init];
    
    PullRefreshTableViewController *refreshTableVC = [[PullRefreshTableViewController alloc] init];
    
    refreshTableVC.tableView = self.MoviesList_VC;
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progressHUD show:YES];
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    refreshTableVC.refreshControl = refresh;
    
    UINib *movieCellNib= [UINib nibWithNibName:@"MovieViewCell" bundle:nil];
    [self.MoviesList_VC registerNib:movieCellNib forCellReuseIdentifier:@"MovieViewCell"];
    
    
    self.MoviesList_VC.dataSource=self;
    self.MoviesList_VC.autoresizesSubviews=false;
    self.MoviesList_VC.delegate = self;
    
    [self queryMovies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) queryMovies
{
    [progressHUD show:YES];
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError!=NULL) {
            [refresh endRefreshing];
            [progressHUD hide:YES];
            self.NetError.alpha=1.0;
        }
        else {
            [progressHUD hide:YES];
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", object);
            self.moviesList=[object objectForKey:@"movies"];
            //NSLog(@"%@", self.moviesList);
            [self.MoviesList_VC reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moviesList.count;
    //return moviesListTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MovieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieViewCell"
                           forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
     NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieViewCell" owner:self options:nil];
     cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *movie=self.moviesList[indexPath.row];
    
    cell.movieNameLabel.text = [NSString stringWithFormat:@"%@",[movie objectForKey:@"title"]];;
    cell.movieDescLabel.text = [NSString stringWithFormat:@"%@",[movie objectForKey:@"synopsis"]];
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[movie objectForKey:@"posters"] objectForKey:@"thumbnail"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    cell.movieCastLabel.text = [MoviesListViewController getCast:movie];
    cell.selected=false;
    //[cell setNeedsLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailViewController *detailedView=[[MovieDetailViewController alloc] init];
    detailedView.movieDict=self.moviesList[indexPath.row];
    if(detailedView.movieDict!=NULL) {
        [self.navigationController pushViewController:detailedView animated:YES];
    }
}


- (void)refresh {
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

-(void)refreshView:(UIRefreshControl *)refreshC {
    
    refreshC.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    // custom refresh logic would be placed here...
    self.NetError.alpha=0;
    [self queryMovies];
    
    [refreshC endRefreshing];
    
}


+(NSString*) getCast: (NSDictionary*)movieDict {
    NSArray *abridgedCast=[movieDict objectForKey:@"abridged_cast"];
    NSString *cast = @"";
    if(abridgedCast!=NULL) {
        for (NSDictionary *castI in abridgedCast) {
            cast = [cast stringByAppendingFormat:@"%@, ", [castI objectForKey:@"name"]];
        }
    }
    if ([cast length] > 0) {
        cast = [cast substringToIndex:[cast length] - 2];
    }
    return cast;
}




@end
