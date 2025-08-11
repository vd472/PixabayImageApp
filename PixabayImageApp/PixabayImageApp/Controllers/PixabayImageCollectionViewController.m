//
//  ViewController.m
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import "PixabayImageCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "PixabayAPIService.h"
#import "PersistenceService.h"
#import "PixabayImageRepository.h"
#import "ImageDetailViewController.h"
#import "OptionalDetailViewController.h"

static NSString *const kCellIdentifier = @"ImageCell";
static NSString *const kPixabayAPIKey = @"51556768-62e5294fc64663a9f68f713c2";

@interface PixabayImageCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) PixabayAPIService *pixabayService;
@property (nonatomic, strong) PersistenceService *coreDataService;
@property (nonatomic, strong) PixabayImageRepository *repository;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

// Pagination properties
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoadingMore;
@property (nonatomic, assign) BOOL hasMorePages;
@property (nonatomic, copy) NSString *currentQuery;
@property (nonatomic, strong) NSMutableArray<PixabayImageModel *> *mutableImages;

@end

@implementation PixabayImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupServices];
    [self setupViews];
    [self setupCollectionView];
    [self performInitialSearch];
}

- (void)setupServices {
    self.pixabayService = [[PixabayAPIService alloc] initWithAPIKey:kPixabayAPIKey];
    self.coreDataService = [PersistenceService sharedInstance];
    self.repository = [[PixabayImageRepository alloc] initWithAPIService:self.pixabayService
                                                     persistenceService:self.coreDataService];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Pixabay Images";
    
    self.searchBar.placeholder = @"Search for images...";
    self.searchBar.delegate = self;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.activityIndicator];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)performInitialSearch {
    [self startNewSearchWithQuery:@"apples"];
}

- (void)startNewSearchWithQuery:(NSString *)query {
    if (!query || [query isEqualToString:@""]) return;
    self.currentQuery = query;
    self.currentPage = 1;
    self.hasMorePages = YES;
    self.mutableImages = [NSMutableArray array];
    [self.collectionView reloadData];
    [self loadNextPage];
}

- (void)loadNextPage {
    if (self.isLoadingMore || !self.hasMorePages) return;
    self.isLoadingMore = YES;
    [self.activityIndicator startAnimating];
    
    [self.repository searchImagesWithQuery:self.currentQuery page:self.currentPage completion:^(NSArray<PixabayImageModel *> *images, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isLoadingMore = NO;
            [self.activityIndicator stopAnimating];

            if (error) {
                if (self.mutableImages.count == 0) {
                    [self showErrorAlert:error.localizedDescription];
                }
                return;
            }
            
            // Deduplicate based on imageId
            NSMutableSet *existingIds = [NSMutableSet set];
            for (PixabayImageModel *img in self.mutableImages) {
                [existingIds addObject:img.imageId];
            }
            for (PixabayImageModel *img in images) {
                if (![existingIds containsObject:img.imageId]) {
                    [self.mutableImages addObject:img];
                }
            }
            [self.collectionView reloadData];
            
            self.currentPage += 1;
            self.hasMorePages = (images.count == 20);
        });
    }];
}

- (void)showErrorAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutableImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    PixabayImageModel *image = self.mutableImages[indexPath.item];
    [cell configureWithImage:image];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PixabayImageModel *selectedImage = self.mutableImages[indexPath.item];
    
    // OptionalDetailViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OptionalDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"optionaldetailVC"];
    detailVC.imageModel = selectedImage;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //ImageDetailViewController
//    ImageDetailViewController *detailVC = [[ImageDetailViewController alloc] initWithImage:selectedImage];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat minCellWidth = 180.0;
    CGFloat spacing = 8.0;
    CGFloat availableWidth = collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right;
    NSInteger maxNumColumns = floor((availableWidth + spacing) / (minCellWidth + spacing));
    maxNumColumns = MAX(maxNumColumns, 2);
    CGFloat totalSpacing = (maxNumColumns - 1) * spacing;
    CGFloat cellWidth = (availableWidth - totalSpacing) / maxNumColumns;
    CGFloat cellHeight = cellWidth * 1.4;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat frameHeight = scrollView.frame.size.height;
    if (offsetY > contentHeight - frameHeight * 2 && self.hasMorePages && !self.isLoadingMore) {
        [self loadNextPage];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self startNewSearchWithQuery:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

@end
