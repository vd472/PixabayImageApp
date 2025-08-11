//
//  ImageCollectionViewCell.m
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import "ImageCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 4.0;
    
    // Image View
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 6.0;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imageView];
    
    // User Label
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.userLabel.textColor = [UIColor darkGrayColor];
    self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userLabel];
    
    // Tags Label
    self.tagsLabel = [[UILabel alloc] init];
    self.tagsLabel.font = [UIFont systemFontOfSize:12];
    self.tagsLabel.textColor = [UIColor lightGrayColor];
    self.tagsLabel.numberOfLines = 0;
    self.tagsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.tagsLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Image View
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor multiplier:0.75],
        
        // User Label
        [self.userLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:8],
        [self.userLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.userLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        
        // Tags Label
        [self.tagsLabel.topAnchor constraintEqualToAnchor:self.userLabel.bottomAnchor constant:4],
        [self.tagsLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.tagsLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.tagsLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-8]
    ]];
}

- (void)configureWithImage:(PixabayImageModel *)image {
    self.userLabel.text = image.user;
    self.tagsLabel.text = [image.tags componentsJoinedByString:@", "];
    
    // Load image with SDWebImage
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image.previewURL]
                      placeholderImage:[self createPlaceholderImage]
                             options:SDWebImageRefreshCached
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"Error loading image: %@", error);
        }
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageView sd_cancelCurrentImageLoad];
    self.imageView.image = nil;
    self.userLabel.text = nil;
    self.tagsLabel.text = nil;
}

- (UIImage *)createPlaceholderImage {
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    UIColor *backgroundColor = [UIColor systemGray5Color];
    [backgroundColor setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIColor *iconColor = [UIColor systemGray3Color];
    [iconColor setFill];
    
    // Draw a simple image icon
    CGFloat iconSize = 40;
    CGFloat x = (size.width - iconSize) / 2;
    CGFloat y = (size.height - iconSize) / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, iconSize, iconSize)];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
