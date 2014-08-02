//
//  FormatDescriptionTableViewController.m
//  CoreVideoPixelFormatDump
//
//  Created by Chinmay Garde on 8/2/14.
//  Copyright (c) 2014 Chinmay Garde. All rights reserved.
//

#import "FormatDescriptionTableViewController.h"

@implementation FormatDescriptionTableViewController {
    NSMutableArray *_descriptionKeys;
    NSMutableArray *_descriptionValues;
}

-(void) setPixelFormatType:(OSType)pixelFormatType {
    if (_pixelFormatType == pixelFormatType)
        return;
    
    _pixelFormatType = pixelFormatType;
    
    _descriptionKeys = [NSMutableArray array];
    _descriptionValues = [NSMutableArray array];
    
    NSDictionary *dictionary = CFBridgingRelease(CVPixelFormatDescriptionCreateWithPixelFormatType(kCFAllocatorDefault, pixelFormatType));
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [_descriptionKeys addObject:key];
        [_descriptionValues addObject:obj];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _descriptionKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormatDescription" forIndexPath:indexPath];
    
    cell.textLabel.text = _descriptionKeys[indexPath.row];
    
    id value = _descriptionValues[indexPath.row];
    
    if (value) {
        if ([value isKindOfClass:[NSString class]]) {
            cell.detailTextLabel.text = value;
        } else if (CFGetTypeID((CFTypeRef)value) == CFBooleanGetTypeID()) {
            cell.detailTextLabel.text = [value boolValue] ? @"True" : @"False";
        } else if ([value isKindOfClass:[NSNumber class]]) {
            cell.detailTextLabel.text = [value stringValue];
        } else {
            cell.detailTextLabel.text = @"<Something>";
        }
    }

    return cell;
}

@end
