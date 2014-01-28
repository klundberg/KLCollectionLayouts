//
//  KLAnchoredCollectionViewFlowLayout.h
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 7/30/13.
//  Copyright (c) 2013 Kevin Lundberg. All rights reserved.
//

/**
 * Class that makes any headers in the layout appear to be anchored to the top and footers to be anchored to the bottom
 * while the headers' sections are scrolling underneath. Functions similarly to plain-style table views with headers.
 *
 * adapted from implementation found here:
 * http://blog.radi.ws/post/32905838158/sticky-headers-for-uicollectionview-using
 */
@interface KLAnchoredCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 * If YES, anchors headers to the collection view so that they are always visible at the top of the view if their sections are scrolled past the top but still visible. Defaults to NO.
 */
@property (nonatomic, assign) BOOL headersAnchored;

/**
 * If YES, anchors footers to the collection view so that they are always visible at the bottom of the view if their sections are scrolled past the bottom but still visible. Defaults to NO.
 */
@property (nonatomic, assign) BOOL footersAnchored;

@end
