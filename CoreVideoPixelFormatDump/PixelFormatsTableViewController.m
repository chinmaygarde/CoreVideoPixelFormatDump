//
//  PixelFormatsTableViewController
//  CoreVideoPixelFormatDump
//
//  Created by Chinmay Garde on 8/2/14.
//  Copyright (c) 2014 Chinmay Garde. All rights reserved.
//

#import "PixelFormatsTableViewController.h"
#import "FormatDescriptionTableViewController.h"

#import <CoreVideo/CoreVideo.h>

NSString *NSStringFromCVPixelFormatType(OSType type) {
    switch (type) {
        case 0x00000001:
            return @"1Monochrome";
        case 0x00000002:
            return @"2Indexed";
        case 0x00000004:
            return @"4Indexed";
        case 0x00000008:
            return @"8Indexed";
        case 0x00000021:
            return @"1IndexedGray_WhiteIsZero";
        case 0x00000022:
            return @"2IndexedGray_WhiteIsZero";
        case 0x00000024:
            return @"4IndexedGray_WhiteIsZero";
        case 0x00000028:
            return @"8IndexedGray_WhiteIsZero";
        case 0x00000010:
            return @"16BE555";
        case 'L555':
            return @"16LE555";
        case '5551':
            return @"16LE5551";
        case 'B565':
            return @"16BE565";
        case 'L565':
            return @"16LE565";
        case 0x00000018:
            return @"24RGB";
        case '24BG':
            return @"24BGR";
        case 0x00000020:
            return @"32ARGB";
        case 'BGRA':
            return @"32BGRA";
        case 'ABGR':
            return @"32ABGR";
        case 'RGBA':
            return @"32RGBA";
        case 'b64a':
            return @"64ARGB";
        case 'b48r':
            return @"48RGB";
        case 'b32a':
            return @"32AlphaGray";
        case 'b16g':
            return @"16Gray";
        case 'R10k':
            return @"30RGB";
        case '2vuy':
            return @"422YpCbCr8";
        case 'v408':
            return @"4444YpCbCrA8";
        case 'r408':
            return @"4444YpCbCrA8R";
        case 'y408':
            return @"4444AYpCbCr8";
        case 'y416':
            return @"4444AYpCbCr16";
        case 'v308':
            return @"444YpCbCr8";
        case 'v216':
            return @"422YpCbCr16";
        case 'v210':
            return @"422YpCbCr10";
        case 'v410':
            return @"444YpCbCr10";
        case 'y420':
            return @"420YpCbCr8Planar";
        case 'f420':
            return @"420YpCbCr8PlanarFullRange";
        case 'a2vy':
            return @"422YpCbCr_4A_8BiPlanar";
        case '420v':
            return @"420YpCbCr8BiPlanarVideoRange";
        case '420f':
            return @"420YpCbCr8BiPlanarFullRange";
        case 'yuvs':
            return @"422YpCbCr8_yuvs";
        case 'yuvf':
            return @"422YpCbCr8FullRange";
        case 'L008':
            return @"OneComponent8";
        case '2C08':
            return @"TwoComponent8";
        case 'L00h':
            return @"OneComponent16Half";
        case 'L00f':
            return @"OneComponent32Float";
        case '2C0h':
            return @"TwoComponent16Half";
        case '2C0f':
            return @"TwoComponent32Float";
        case 'RGhA':
            return @"64RGBAHalf";
        case 'RGfA':
            return @"128RGBAFloat";
        default:
            return @"Unknown";
    }
    return @"Unknown";
}

@implementation PixelFormatsTableViewController {
    NSArray *_formats;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  Based on: https://developer.apple.com/library/mac/qa/qa1501/_index.html
     */
    _formats = CFBridgingRelease(CVPixelFormatDescriptionArrayCreateWithAllPixelFormatTypes(kCFAllocatorDefault));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _formats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportedFormatCell" forIndexPath:indexPath];
    
    UInt32 value = [_formats[indexPath.row] unsignedIntValue];
    
    cell.textLabel.text = NSStringFromCVPixelFormatType(value);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d) %c%c%c%c", (unsigned int)value, (char)(value >> 24), (char)(value >> 16), (char)(value >> 8), (char)value];
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FormatDescription"]) {
        NSUInteger valueIndex = [self.tableView indexPathForCell:sender].row;
        
        FormatDescriptionTableViewController *destination = [segue destinationViewController];
        
        OSType format = [_formats[valueIndex] unsignedIntValue];
        destination.pixelFormatType = format;
        destination.title = NSStringFromCVPixelFormatType(format);
    }
}

@end
