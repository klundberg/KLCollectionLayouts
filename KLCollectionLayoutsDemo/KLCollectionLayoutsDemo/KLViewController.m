//
//  KLViewController.m
//  KLCollectionLayoutsDemo
//
//  Created by Kevin Lundberg on 3/27/14.
//  Copyright (c) 2014 Lundbergsoft. All rights reserved.
//

#import "KLViewController.h"
#import <KLCollectionLayouts/KLCollectionLayouts.h>

@interface KLViewController ()

@property (nonatomic, strong) KLAnchoredCollectionViewFlowLayout *layout;

@end

@implementation KLViewController

- (KLAnchoredCollectionViewFlowLayout *)layout
{
    return (id)self.collectionViewLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    self.layout.headerReferenceSize = CGSizeMake(50, 50);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        return view;
    }
    return nil;
}

@end
