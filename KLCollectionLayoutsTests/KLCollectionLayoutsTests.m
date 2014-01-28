//
//  KLCollectionLayoutsTests.m
//  KLCollectionLayoutsTests
//
//  Created by Kevin Lundberg on 7/30/13.
//  Copyright (c) 2013 Kevin Lundberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KLAnchoredCollectionViewFlowLayout.h"
//#import >

@interface KLCollectionLayoutsTests : XCTestCase
{
    KLAnchoredCollectionViewFlowLayout *layout;
    UICollectionView *view;
}
@end

@implementation KLCollectionLayoutsTests

- (void)setUp
{
    [super setUp];
    layout = [[KLAnchoredCollectionViewFlowLayout alloc] init];
    view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) collectionViewLayout:layout];
}

- (void)test_
{

}

@end
