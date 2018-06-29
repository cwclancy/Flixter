//
//  FavoritesModel.h
//  flix
//
//  Created by Connor Clancy on 6/28/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesModel : NSObject
@property (class) NSMutableArray *favorites;
- (void) addMovie;
+ (NSArray *) getMovies;
@end
