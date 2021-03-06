//
//  KLAnchoredCollectionViewFlowLayout.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 7/30/13.
//  Copyright (c) 2013 Kevin Lundberg. All rights reserved.
//

#import "KLAnchoredCollectionViewFlowLayout.h"

static NSInteger const KLAnchoredSupplementaryViewZIndex = 1024;


@implementation KLAnchoredCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    self.headersAnchored = YES;
    self.footersAnchored = YES;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (!self.headersAnchored && !self.footersAnchored) {
        return [super layoutAttributesForElementsInRect:rect];
    }

    NSArray *attributeList = [self layoutAttributesWithHeadersAndFootersForVisibleSections:rect];

    for (UICollectionViewLayoutAttributes *attributes in attributeList) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [self adjustHeaderAttributesIfNeededToKeepThemVisible:attributes];
        }
    }

    return attributeList;
}

- (NSMutableArray *)layoutAttributesWithHeadersAndFootersForVisibleSections:(CGRect)rect
{
    NSMutableArray *attributeList = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    if (self.headersAnchored) {
        NSMutableIndexSet *sectionsWithoutHeadersDisplayed = [self visibleSectionsWithoutVisibleHeaders:attributeList];
        NSArray *missingHeaders = [self layoutAttributesForHeadersInSections:sectionsWithoutHeadersDisplayed];
        [attributeList addObjectsFromArray:missingHeaders];
    }
    return attributeList;
}

/**
 @param attributeList the list of attributes that are normally shown by the layout in the current bounds of the collection view.
 @return a set of indices corresponding to the sections that are visible on screen but whose headers are not visible.
 */
- (NSMutableIndexSet *)visibleSectionsWithoutVisibleHeaders:(NSArray *)attributeList
{
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    // count all the cells on screen and record what sections they fall under.
    for (UICollectionViewLayoutAttributes *layoutAttributes in attributeList) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    // don't count any headers that are already on screen, since those headers need to scroll with the content untill they go offscreen,
    // at which point they will be anchored.
    for (UICollectionViewLayoutAttributes *layoutAttributes in attributeList) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    return missingSections;
}

- (NSMutableArray *)layoutAttributesForHeadersInSections:(NSMutableIndexSet *)sectionsWithoutHeadersDisplayed
{
    // missing headers are headers whose sections are visible but the headers themselves are offscreen.
    NSMutableArray *array = [NSMutableArray array];
    [sectionsWithoutHeadersDisplayed enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttributes) {
            [array addObject:layoutAttributes];
        }
    }];
    return array;
}

/**
 * adjusts the position of the given header to the
 * @param attributes Layout Attributes for the header we want to anchor to the top of the scroll view as we scroll through its section.
 */
- (void)adjustHeaderAttributesIfNeededToKeepThemVisible:(UICollectionViewLayoutAttributes *)attributes
{
    NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
    
    if (numberOfItemsInSection == 0) {
        // there's nothing to do when we have no items, since the header has no space to stick.
        return;
    }
    
    CGFloat minimumPosition = [self minimumPositionForItemWithAttributes:attributes];
    CGFloat maximumPosition = [self maximumPositionForItemWithAttributes:attributes];

    // Apply the limits to the given layout attributes.
    CGRect frame = attributes.frame;
    frame.origin.y = [self newPositionBetweenMinimum:minimumPosition maximum:maximumPosition];
    attributes.frame = frame;
    
    // Keep the anchored views "above" the cells in its section, so that the cells don't overlap it while scrolling.
    attributes.zIndex = KLAnchoredSupplementaryViewZIndex;
}

- (CGFloat)minimumPositionForItemWithAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
    UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];

    CGFloat headerHeight = CGRectGetHeight(attributes.frame);
    CGFloat minimumVerticalPosition = CGRectGetMinY(firstCellAttrs.frame) - self.sectionInset.top - headerHeight;
    return minimumVerticalPosition;
}

- (CGFloat)maximumPositionForItemWithAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];

    NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:attributes.indexPath.section];
    UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];

    CGFloat headerHeight = CGRectGetHeight(attributes.frame);
    CGFloat maximumVerticalPosition = CGRectGetMaxY(lastCellAttrs.frame) + self.sectionInset.bottom - headerHeight;
    return maximumVerticalPosition;
}

- (CGFloat)newPositionBetweenMinimum:(CGFloat)minimumPosition maximum:(CGFloat)maximumPosition
{
    CGFloat newPosition = MAX(self.collectionView.contentOffset.y + self.collectionView.contentInset.top, minimumPosition);
    newPosition = MIN(newPosition - self.collectionView.contentInset.bottom, maximumPosition);
    return newPosition;
}

@end
