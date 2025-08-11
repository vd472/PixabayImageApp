//
//  OptionalDetailViewController.h
//  PixabayImageApp
//
//  Created by vijayesha on 01.08.25.
//

#import <UIKit/UIKit.h>
#import "PixabayImageModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * OptionalDetailViewController
 *
 * Displays detailed information about a Pixabay image, including a large preview,
 * username, tags, and image statistics (likes, favorites, comments). Uses SDWebImage
 * for efficient image loading and caching. The UI is scrollable and neatly presents
 * all metadata in a visually appealing layout.
 */

@interface OptionalDetailViewController : UIViewController
@property (nonatomic, strong) PixabayImageModel *imageModel;
@end

NS_ASSUME_NONNULL_END
