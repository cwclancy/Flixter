//
//  GridViewController.m
//  flix
//
//  Created by Connor Clancy on 6/28/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "GridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *movieTitles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) NSMutableArray *favorites;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width/postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self fetchMovies];
    self.filteredData = self.movies;
    //self.movieTitles = [self getMovieTitles:self.movies];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    //[self.mainActivityMonitor startAnimating];
    //[self.view bringSubviewToFront:self.mainActivityMonitor];
    // network call
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self fetchMovies];
            }];
            NSLog(@"HERE!!!!");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Failed" message:@"Check your internet and retry" preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:retry];
            [self presentViewController:alert animated:YES completion:^{
                [self fetchMovies];
            }];
        }
        
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary); // print data
            
            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
            [self.collectionView reloadData];
            // TODO: Get the array of movies
            
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        //[self.refreshControl endRefreshing];
        //[self.mainActivityMonitor stopAnimating];
    }];
    [task resume];
}

// SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath =[self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.item];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

// Search Bar Functions

- (NSArray *)getMovieTitles:(NSArray *)movies {
    NSMutableArray *result = [NSMutableArray new];
    for (int i = 0; i < self.movies.count; i++) {
        NSString *title = self.movies[i][@"title"];
        [result addObject:title];
    }
    return (NSArray *)result;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        self.filteredData = [self.movies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title contains[c] %@)", searchText]];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.collectionView reloadData];
    
}

- (IBAction)swipeToCancel:(id)sender {
    self.filteredData = self.movies;
    [self.collectionView reloadData];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    NSLog(@"SWIPER IM SWIPING!!!");
}


@end
