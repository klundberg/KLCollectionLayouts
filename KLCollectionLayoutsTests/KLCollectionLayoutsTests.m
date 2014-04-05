//
//  KLCollectionLayoutsTests.m
//  KLCollectionLayoutsTests
//
//  Created by Kevin Lundberg on 7/30/13.
//  Copyright (c) 2013 Kevin Lundberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KLAnchoredCollectionViewFlowLayout.h"
#import "KRLSimpleCollectionViewController.h"
#define HC_SHORTHAND 1
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND 1
#import <OCMockito/OCMockito.h>

@interface KLCollectionLayoutsTests : XCTestCase
{
    KLAnchoredCollectionViewFlowLayout *layout;
    KRLSimpleCollectionViewController *controller;
}
@end

@implementation KLCollectionLayoutsTests

- (void)setUp
{
    [super setUp];
    layout = [[KLAnchoredCollectionViewFlowLayout alloc] init];
    controller = [[KRLSimpleCollectionViewController alloc] initWithCollectionViewLayout:layout];
    controller.view.frame = CGRectMake(0, 0, 320, 480);
    controller.items = @[@1,@2,@3,@4,@5];
}

- (void)test_headerSticksWhenScrollingDown
{
    layout.itemSize = CGSizeMake(300, 300);
    layout.headerReferenceSize = CGSizeMake(40, 40);

    [controller.view layoutIfNeeded];

    UICollectionReusableView *view = [controller.visibleSupplementaryViews anyObject];
    assertThat(view, isNot(nilValue()));
    assertThatFloat(view.frame.origin.y, equalToFloat(0));

    [controller.collectionView scrollRectToVisible:CGRectMake(0, 10, 320, 480) animated:NO];

    view = [controller.visibleSupplementaryViews anyObject];
    assertThat(view, isNot(nilValue()));
    assertThatFloat(view.frame.origin.y, equalToFloat(0));

}

@end
