//
//  ImageDetailViewController.m
//  PixabayImageApp
//
//  Created by vijayesha on 01.08.25.
//


#import "ImageDetailViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface ImageDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic, strong) UILabel *favoritesLabel;
@property (nonatomic, strong) UILabel *commentsLabel;
@property (nonatomic, strong) UIStackView *statsStackView;


@end

@implementation ImageDetailViewController

- (instancetype)initWithImage:(PixabayImageModel *)imageModel {
    self = [super init];
    if (self) {
        self.imageModel = imageModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self configureWithImageModel:self.imageModel];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Image Details";
    
    // Scroll View
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    // Image View
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.imageView];
    
    // User Label
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    self.userLabel.textColor = [UIColor labelColor];
    self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.userLabel];
    
    // Tags Label
    self.tagsLabel = [[UILabel alloc] init];
    self.tagsLabel.font = [UIFont systemFontOfSize:16];
    self.tagsLabel.textColor = [UIColor secondaryLabelColor];
    self.tagsLabel.numberOfLines = 0;
    self.tagsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.tagsLabel];
    
    // Stats Container
    self.statsStackView = [[UIStackView alloc] init];
    self.statsStackView.axis = UILayoutConstraintAxisHorizontal;
    self.statsStackView.distribution = UIStackViewDistributionFillEqually;
    self.statsStackView.spacing = 16;
    self.statsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview: self.statsStackView];
    
    // Likes Label
    self.likesLabel = [[UILabel alloc] init];
    self.likesLabel.font = [UIFont systemFontOfSize:14];
    self.likesLabel.textColor = [UIColor systemBlueColor];
    self.likesLabel.textAlignment = NSTextAlignmentCenter;
    [self.statsStackView addArrangedSubview:self.likesLabel];
    
    // Favorites Label
    self.favoritesLabel = [[UILabel alloc] init];
    self.favoritesLabel.font = [UIFont systemFontOfSize:14];
    self.favoritesLabel.textColor = [UIColor systemRedColor];
    self.favoritesLabel.textAlignment = NSTextAlignmentCenter;
    [self.statsStackView addArrangedSubview:self.favoritesLabel];
    
    // Comments Label
    self.commentsLabel = [[UILabel alloc] init];
    self.commentsLabel.font = [UIFont systemFontOfSize:14];
    self.commentsLabel.textColor = [UIColor systemGreenColor];
    self.commentsLabel.textAlignment = NSTextAlignmentCenter;
    [self.statsStackView addArrangedSubview:self.commentsLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        // Image View
        [self.imageView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:16],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:16],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-16],
        [self.imageView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor constant:-32],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor multiplier:0.75],
        
        //User Label
        [self.userLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:16],
        [self.userLabel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:16],
        [self.userLabel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-16],
        
        // Tags Label
        [self.tagsLabel.topAnchor constraintEqualToAnchor:self.userLabel.bottomAnchor constant:8],
        [self.tagsLabel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:16],
        [self.tagsLabel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-16],
        
        // Stats Stack View
        [ self.statsStackView.topAnchor constraintEqualToAnchor:self.tagsLabel.bottomAnchor constant:16],
        [ self.statsStackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:16],
        [ self.statsStackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-16],
        [ self.statsStackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-16]
    ]];
}

- (void)configureWithImageModel:(PixabayImageModel *)imageModel {
    self.userLabel.text = [NSString stringWithFormat:@"User: %@", imageModel.user];
    self.tagsLabel.text = [NSString stringWithFormat:@"Tags: %@", [imageModel.tags componentsJoinedByString:@", "]];
    self.likesLabel.text = [NSString stringWithFormat:@"❤️ %ld", (long)imageModel.likes];
    self.favoritesLabel.text = [NSString stringWithFormat:@"⭐ %ld", (long)imageModel.favorites];
    self.commentsLabel.text = [NSString stringWithFormat:@"💬 %ld", (long)imageModel.comments];
    
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
