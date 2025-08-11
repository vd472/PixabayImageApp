//
//  OptionalDetailViewController.m
//  PixabayImageApp
//
//  Created by vijayesha on 01.08.25.
//

#import "OptionalDetailViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface OptionalDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation OptionalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureWithImageModel:self.imageModel];
}

- (void)configureWithImageModel:(PixabayImageModel *)imageModel {
    self.userLabel.text = [NSString stringWithFormat:@"User: %@", imageModel.user];
    self.tagsLabel.text = [NSString stringWithFormat:@"Tags: %@", [imageModel.tags componentsJoinedByString:@", "]];
    self.likesLabel.text = [NSString stringWithFormat:@"❤️ %ld", (long)imageModel.likes];
    self.favoritesLabel.text = [NSString stringWithFormat:@"⭐ %ld", (long)imageModel.favorites];
    self.commentLabel.text = [NSString stringWithFormat:@"💬 %ld", (long)imageModel.comments];
    
    // Load large image with SDWebImage
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.largeImageURL]
                      placeholderImage:[self createPlaceholderImage]
                             options:SDWebImageRefreshCached
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"Error loading large image: %@", error);
        }
    }];
}

- (UIImage *)createPlaceholderImage {
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    UIColor *backgroundColor = [UIColor systemGray5Color];
    [backgroundColor setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIColor *iconColor = [UIColor systemGray3Color];
    [iconColor setFill];
    
    // Draw a simple image icon
    CGFloat iconSize = 80;
    CGFloat x = (size.width - iconSize) / 2;
    CGFloat y = (size.height - iconSize) / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, iconSize, iconSize)];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
