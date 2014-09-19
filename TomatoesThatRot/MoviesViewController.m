//
//  MoviesViewController.m
//  TomatoesThatRot
//
//  Created by Ying Yang on 9/15/14.
//  Copyright (c) 2014 Ying Yang. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MMprogressHUD.h"


// class extension
@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom init
        self.title = @"All Movies";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // delegate is like event - tell them we understand and we wanna handle them ourselves
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 105;
    
    // register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell"  bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    // add a loading view (spinner) then try and fetch the data
    [MMProgressHUD showWithTitle:@"Loading.."];
    [self fetchMovies];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchNewMoviesOnPull:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)fetchNewMoviesOnPull:(id) refreshControl {
    [self fetchMovies];
    [refreshControl endRefreshing];
}

- (void)fetchMovies {
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    
    // description how you wanna form that request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: url]];

    // reads the request
    // what thread i wanna run the response in
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //hide the loading view
        if (!connectionError) {
            // dictionary is the same as hash table
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
            // this will trigger numberOfRows and cellForRowAtIndexPath to be called again
            [self.tableView reloadData];
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            label.text = @"Oops there's a network connection error";
            label.backgroundColor = [UIColor orangeColor];
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 2;
            [self.view addSubview:label];
            
            [label setAlpha:0.0];
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^(void) {
                                 [label setAlpha:1.0];
                             }
                             completion:^(BOOL finished) {
                                 if(finished) {
                                     [UIView animateWithDuration:1.5 delay:4 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                      animations:^(void) {
                                                          [label setAlpha:0.0];
                                                      }
                                                      completion:^(BOOL finished) {
                                                          // try reload? not doing anything? Ask user to pull down
                                                          // should remove the label from subview
                                                          [label removeFromSuperview];
                                                      }];
                                 }
                             }];
            
        }
        [MMProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

// resuable cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie = self.movies[indexPath.row];
    MovieCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsis.text = movie[@"synopsis"];
    
    NSURL *imageURL = [NSURL URLWithString:[[movie objectForKey:@"posters"] valueForKey:@"thumbnail"]];
    [cell.posterView setImageWithURL:imageURL];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // should navigate to the corresponding movie detail view
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MovieDetailViewController *movieDetailView = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];

    movieDetailView.selectedMovie = self.movies[indexPath.row];
    [self.navigationController pushViewController:movieDetailView animated:YES];    
}

@end
