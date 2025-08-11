//
//  PixabayImageCollectionViewController.h
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import <UIKit/UIKit.h>
#import "PixabayImageModel.h"

/**
 * PixabayImageCollectionViewController
 *
 * Displays a paginated, searchable grid of images from Pixabay using a UICollectionView.
 * Supports searching by keywords, infinite scroll with pagination, and local caching.
 * Uses a repository pattern to fetch data from both API and Core Data, handles image deduplication,
 * and shows a detail screen when an image is selected.
 * Provides a responsive, user-friendly interface for browsing image results.
 */

@interface PixabayImageCollectionViewController : UIViewController 
@end


