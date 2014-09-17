//
//  MovieCell.h
//  TomatoesThatRot
//
//  Created by Ying Yang on 9/16/14.
//  Copyright (c) 2014 Ying Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
