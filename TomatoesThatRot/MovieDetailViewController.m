//
//  MovieDetailViewController.m
//  TomatoesThatRot
//
//  Created by Ying Yang on 9/16/14.
//  Copyright (c) 2014 Ying Yang. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MoviesViewController.h"
#import "UIImageView+AFNetworking.h"


@interface MovieDetailViewController ()
@property (nonatomic, strong) UILabel *movieSynopisisLabel;
@property (nonatomic, strong) UILabel *movieTitleLabel;
@property (nonatomic, strong) UILabel *movieRateLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *movieDetailScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *movieHighResImageView;
@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom init
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = self.selectedMovie[@"title"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(OnTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;

    [self loadMovieDetailView];
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(switchToHighResImage) userInfo:nil repeats:NO];    
}

- (void)loadMovieDetailView {
    // set poster image
    NSURL *imageURL = [NSURL URLWithString:[[self.selectedMovie objectForKey:@"posters"] valueForKey:@"thumbnail"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.movieHighResImageView.image = [UIImage imageWithData:imageData];


    self.movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 320, 40)];
    self.movieRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 30)];
    self.movieSynopisisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, 320, 980)];
    
    self.movieTitleLabel.numberOfLines = 2;
    self.movieRateLabel.numberOfLines = 1;
    self.movieSynopisisLabel.numberOfLines = 0;
    
    
    self.movieSynopisisLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    self.movieTitleLabel.font = [UIFont fontWithName:@"Cochin-bold" size:21.0];
    self.movieRateLabel.font = [UIFont fontWithName:@"GillSans" size:14.0];
    
    self.movieSynopisisLabel.alpha = self.movieRateLabel.alpha = self.movieTitleLabel.alpha = 0.8;
    self.movieSynopisisLabel.textColor = self.movieTitleLabel.textColor = self.movieRateLabel.textColor = [UIColor whiteColor];

    // set the movie synopsis
    self.movieTitleLabel.text = [NSString stringWithFormat:@"%@ (%@) ", self.selectedMovie[@"title"], self.selectedMovie[@"year"]];
    self.movieSynopisisLabel.text = self.selectedMovie[@"synopsis"];
    self.movieRateLabel.text = [NSString stringWithFormat:@"Critics Score:%@, Audience Score:%@", [[self.selectedMovie objectForKey:@"ratings"] valueForKey:@"critics_score"], [[self.selectedMovie objectForKey:@"ratings"] valueForKey:@"critics_score"]];
    
    self.movieSynopisisLabel.backgroundColor = self.movieRateLabel.backgroundColor = self.movieTitleLabel.backgroundColor = [UIColor blackColor];
    [self.movieDetailScrollView addSubview:self.movieTitleLabel];
    [self.movieDetailScrollView addSubview:self.movieRateLabel];
    [self.movieDetailScrollView addSubview:self.movieSynopisisLabel];
    
    [self.movieSynopisisLabel sizeToFit];

    
    CGSize labelSize = CGSizeMake(self.movieSynopisisLabel.frame.size.width - 5, self.movieSynopisisLabel.frame.size.height + 320);
        self.movieDetailScrollView.contentSize = labelSize;
}

- (void)switchToHighResImage {
    NSURL *imageURL = [NSURL URLWithString:[[self.selectedMovie objectForKey:@"posters"] valueForKey:@"thumbnail"]];
    
    imageURL = [NSURL URLWithString:[[imageURL absoluteString] stringByReplacingOccurrencesOfString:@"tmb" withString:@"org"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.movieHighResImageView.image = [UIImage imageWithData:imageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)OnTapBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
