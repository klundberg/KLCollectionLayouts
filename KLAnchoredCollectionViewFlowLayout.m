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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (!self.headersAnchored && !self.footersAnchored) {
        return [super layoutAttributesForElementsInRect:rect];
    }

    NSMutableArray *attributeList = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    if (self.headersAnchored) {
        [self addMissingHeadersToList:attributeList];
    }

    for (UICollectionViewLayoutAttributes *attributes in attributeList) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [self adjustHeaderAttributes:attributes];
        }
    }
    
    return attributeList;
}


- (void)addMissingHeadersToList:(NSMutableArray *)attributeList
{
    // missing headers are headers whose sections are visible but the headers themselves are offscreen.
    NSMutableIndexSet *sectionsWithoutHeadersDisplayed = [self sectionsWithoutHeadersDisplayed:attributeList];
    
    [sectionsWithoutHeadersDisplayed enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttributes) {
            [attributeList addObject:layoutAttributes];
        }
    }];
}

/**
 * @param attributeList the list of attributes that are normally shown by the layout int he current bounds of the collection view.
 * @returns a set of indices corresponding to the sections that are visible on screen but whose headers are not visible.
 */
- (NSMutableIndexSet *)sectionsWithoutHeadersDisplayed:(NSArray *)attributeList
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


/**
 * adjusts the position of the given header to the
 * @param attributes Layout Attributes for the header we want to anchor to the top of the scroll view as we scroll through its section.
 */
- (void)adjustHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    NSInteger section = attributes.indexPath.section;
    NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
    
    if (numberOfItemsInSection == 0) {
        // there's nothing to do when we have no items, since the header has no space to stick.
        return;
    }
    
    // calculate the upper and lower limits to where the given header will be stuck to the top of the collection view.
    NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
    
    UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
    UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
    
    CGFloat headerHeight = CGRectGetHeight(attributes.frame);
    CGFloat minimumVerticalPosition = CGRectGetMinY(firstCellAttrs.frame) - self.sectionInset.top - headerHeight;
    CGFloat maximumVerticalPosition = CGRectGetMaxY(lastCellAttrs.frame) + self.sectionInset.bottom - headerHeight;
    
    // Apply the limits to the given layout attributes.
    CGFloat newVerticalPosition = MAX(self.collectionView.contentOffset.y + self.collectionView.contentInset.top, minimumVerticalPosition);
    newVerticalPosition = MIN(newVerticalPosition - self.collectionView.contentInset.bottom, maximumVerticalPosition);
    
    CGRect frame = attributes.frame;
    frame.origin.y = newVerticalPosition;
    attributes.frame = frame;
    
    // Keep the anchored views "above" the cells in its section, so that the cells don't overlap it while scrolling.
    attributes.zIndex = KLAnchoredSupplementaryViewZIndex;
}

@end
