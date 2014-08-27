//
//  FormatDescriptionTableViewController.m
//  CoreVideoPixelFormatDump
//
//  Created by Chinmay Garde on 8/2/14.
//  Copyright (c) 2014 Chinmay Garde. All rights reserved.
//

#import "FormatDescriptionTableViewController.h"
#import "PixelFormatsTableViewController.h"

static NSString *NSStringFromCGBitmapInfo(CGBitmapInfo info) {
    
    NSMutableArray *components = [[NSMutableArray alloc] init];
    
    CGImageAlphaInfo alphaInfo = info & kCGBitmapAlphaInfoMask;
    switch (alphaInfo) {
        case kCGImageAlphaNone:
            [components addObject:@"kCGImageAlphaNone"];
            break;
        case kCGImageAlphaPremultipliedLast:
            [components addObject:@"kCGImageAlphaPremultipliedLast"];
            break;
        case kCGImageAlphaPremultipliedFirst:
            [components addObject:@"kCGImageAlphaPremultipliedFirst"];
            break;
        case kCGImageAlphaLast:
            [components addObject:@"kCGImageAlphaLast"];
            break;
        case kCGImageAlphaFirst:
            [components addObject:@"kCGImageAlphaFirst"];
            break;
        case kCGImageAlphaNoneSkipLast:
            [components addObject:@"kCGImageAlphaNoneSkipLast"];
            break;
        case kCGImageAlphaNoneSkipFirst:
            [components addObject:@"kCGImageAlphaNoneSkipFirst"];
            break;
        case kCGImageAlphaOnly:
            [components addObject:@"kCGImageAlphaOnly"];
            break;
        default:
            [components addObject:@"UnknownAlpha"];
            break;
    }
    
    switch (info & kCGBitmapByteOrderMask) {
        case kCGBitmapByteOrderMask:
            [components addObject:@"kCGBitmapByteOrderMask"];
            break;
        case kCGBitmapByteOrderDefault:
            [components addObject:@"kCGBitmapByteOrderDefault"];
            break;
        case kCGBitmapByteOrder16Little:
            [components addObject:@"kCGBitmapByteOrder16Little"];
            break;
        case kCGBitmapByteOrder32Little:
            [components addObject:@"kCGBitmapByteOrder32Little"];
            break;
        case kCGBitmapByteOrder16Big:
            [components addObject:@"kCGBitmapByteOrder16Big"];
            break;
        case kCGBitmapByteOrder32Big:
            [components addObject:@"kCGBitmapByteOrder32Big"];
            break;
        default:
            [components addObject:@"UnknownByteOrder"];
            break;
    }
    
    if (info & kCGBitmapFloatComponents) {
        [components addObject:@"kCGBitmapFloatComponents"];
    }
    
    return [components componentsJoinedByString:@" | "];
}

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
    
    id key = _descriptionKeys[indexPath.row];
    cell.textLabel.text = key;
    
    id value = _descriptionValues[indexPath.row];

    if (value) {
        // Special case some keys
        if ([key isEqualToString:(id)kCVPixelFormatCGBitmapInfo]) {
            cell.detailTextLabel.text = NSStringFromCGBitmapInfo([value integerValue]);
        } else if ([key isEqualToString:(id)kCVPixelFormatConstant]) {
            cell.detailTextLabel.text = NSStringFromCVPixelFormatType([value integerValue]);
        } else {
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
    }

    return cell;
}

@end
