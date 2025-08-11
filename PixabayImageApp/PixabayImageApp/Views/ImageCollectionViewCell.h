//
//  ImageCollectionViewCell.h
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import <UIKit/UIKit.h>
#import "PixabayImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *tagsLabel;

- (void)configureWithImage:(PixabayImageModel *)image;

@end

NS_ASSUME_NONNULL_END
