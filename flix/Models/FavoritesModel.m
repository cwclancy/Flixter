//
//  FavoritesModel.m
//  flix
//
//  Created by Connor Clancy on 6/28/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "FavoritesModel.h"

@implementation FavoritesModel

- (void)addMovie:(NSDictionary *)movie {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSMutableArray *movies = (NSMutableArray *)[defaults objectForKey:@"movies"];
        [movies addObject:movie];
        [defaults setObject:movie forKey:@"movies"];
    }
    else {
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        [movies addObject:movie];
        [defaults setObject:movie forKey:@"movies"];
    }
}

+ (NSArray *)getMovies {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSArray *)[defaults objectForKey:@"movies"];
}

@end
