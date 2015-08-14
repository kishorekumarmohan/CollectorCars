//
//  ViewController.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/11/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsSettingsViewController.h"

NSInteger const KKMMaxPriceRange = 1000000; //1M
NSInteger const KKMPriceIncrement = 50000;

NSInteger const KKMTableRowExpandHeight = 200.0f;
NSInteger const KKMTableRowDefaultHeight = 44.0f;

NSString* const KKMNoMinString = @"No Min";
NSString* const KKMNoMaxString = @"No Max";

@interface KKMCollectorCarsSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *yearFromPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *yearToPickerView;
@property (weak, nonatomic) IBOutlet UILabel *yearSelectedValueLablel;

@property (weak, nonatomic) IBOutlet UIPickerView *priceMinPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *priceMaxPickerView;
@property (weak, nonatomic) IBOutlet UILabel *priceSelectedValueLabel;

@property (nonatomic, strong) NSMutableArray *yearFromRangeArray;
@property (nonatomic, strong) NSMutableArray *yearToRangeArray;

@property (nonatomic, strong) NSMutableArray *priceMinRangeArray;
@property (nonatomic, strong) NSMutableArray *priceMaxRangeArray;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation KKMCollectorCarsSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUp];
    [self setUpPickerData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.yearToPickerView selectRow:(self.yearToRangeArray.count - 1) inComponent:0 animated:YES];
    [self.priceMaxPickerView selectRow:(self.priceMaxRangeArray.count -1) inComponent:0 animated:YES];
}

- (void)setUp
{
    self.yearFromPickerView.hidden = YES;
    self.yearToPickerView.hidden = YES;
    self.priceMinPickerView.hidden = YES;
    self.priceMaxPickerView.hidden = YES;
}

- (void)setUpPickerData
{
    // year
    self.yearFromRangeArray = [NSMutableArray new];
    self.yearToRangeArray = [NSMutableArray new];
    [self.yearFromRangeArray addObject:KKMNoMinString];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];

    for (int i = 1896; i <= year; i++)
    {
        [self.yearFromRangeArray addObject:[NSString stringWithFormat:@"%d", i]];
        [self.yearToRangeArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [self.yearToRangeArray addObject:KKMNoMaxString];
    
    // price
    self.priceMinRangeArray = [NSMutableArray new];
    self.priceMaxRangeArray = [NSMutableArray new];
    [self.priceMinRangeArray addObject:KKMNoMinString];

    NSInteger j = 0;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];

    NSString *str;
    while (j <= KKMMaxPriceRange)
    {
        j += KKMPriceIncrement;
        str =[numberFormatter stringFromNumber:[NSNumber numberWithInteger:j]];
        [self.priceMinRangeArray addObject:str];
        [self.priceMaxRangeArray addObject:str];
    }
    
    [self.priceMaxRangeArray addObject:KKMNoMaxString];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
        return;

    NSArray *viewsToShow;
    NSArray *viewsToHide;
    
    if(indexPath.row == 1)
    {
        if (self.selectedIndexPath.row == 1)
        {
            viewsToShow = @[self.yearSelectedValueLablel];
            viewsToHide = @[self.yearFromPickerView, self.yearToPickerView];
        }
        else if (self.selectedIndexPath.row == 2)
        {
            viewsToShow = @[self.yearFromPickerView, self.yearToPickerView, self.priceSelectedValueLabel];
            viewsToHide = @[self.priceMinPickerView, self.priceMaxPickerView, self.yearSelectedValueLablel];
        }
        else
        {
            viewsToShow = @[self.yearFromPickerView, self.yearToPickerView];
            viewsToHide = @[self.yearSelectedValueLablel];
        }
    }
    else if(indexPath.row == 2)
    {
        if (self.selectedIndexPath.row == 1)
        {
            viewsToShow = @[self.priceMinPickerView, self.priceMaxPickerView, self.yearSelectedValueLablel];
            viewsToHide = @[self.yearFromPickerView, self.yearToPickerView, self.priceSelectedValueLabel];
        }
        else if (self.selectedIndexPath.row == 2)
        {
            viewsToShow = @[self.priceSelectedValueLabel];
            viewsToHide = @[self.priceMinPickerView, self.priceMaxPickerView];
        }
        else
        {
            viewsToShow = @[self.priceMinPickerView, self.priceMaxPickerView];
            viewsToHide = @[self.priceSelectedValueLabel];
        }
    }
    
    if ([indexPath isEqual:self.selectedIndexPath])
    {
        // same row tapped, so collapse the row
        self.selectedIndexPath = nil;
        [self tableView:tableView collapseRowAtIndexPath:indexPath viewsToShow:viewsToShow viewsToHide:viewsToHide];
        return;
    }
    
    if(self.selectedIndexPath)
    {
        [self tableView:tableView expandRowAtIndexPath:indexPath collapseRowAtIndexPath:self.selectedIndexPath viewsToShow:viewsToShow viewsToHide:viewsToHide];
        self.selectedIndexPath = indexPath;
    }
    else
    {
        // no other rows expanded; expand the current row
        self.selectedIndexPath = indexPath;
        [self tableView:tableView expandRowAtIndexPath:indexPath viewsToShow:viewsToShow viewsToHide:viewsToHide];
        return;
    }
}

- (void)tableView:(UITableView *)tableView expandRowAtIndexPath:(NSIndexPath *)indexPath viewsToShow:(NSArray *)viewsToShow viewsToHide:(NSArray *)viewsToHide
{
    [UIView animateWithDuration:0.5 animations:^{
        for (UITableViewCell *cell in tableView.visibleCells) {
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
            
            if (cellIndexPath.row > indexPath.row) {
                CGRect frame = cell.frame;
                frame.origin.y += KKMTableRowExpandHeight - frame.size.height;
                cell.frame = frame;
            }
        }
        // expand selected cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        CGRect frame = cell.frame;
        frame.size.height = KKMTableRowExpandHeight;
        cell.frame = frame;
    } completion:^(BOOL finished) {
        [self hideViews:viewsToHide];
        [self showViews:viewsToShow];
        [tableView reloadData];  // commit final state
    }];
}

- (void)showViews:(NSArray *)views
{
    for (id obj in views)
    {
        UIView *view = (UIView *)obj;
        view.hidden = NO;
    }
}

- (void)hideViews:(NSArray *)views
{
    for (id obj in views)
    {
        UIView *view = (UIView *)obj;
        view.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView collapseRowAtIndexPath:(NSIndexPath *)indexPath viewsToShow:viewsToShow viewsToHide:viewsToHide
{
    [self hideViews:viewsToHide];
    
    [UIView animateWithDuration:0.5 animations:^{
        // move down cells which are below selected one
        for (UITableViewCell *cell in tableView.visibleCells) {
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
            
            if (cellIndexPath.row > indexPath.row) {
                CGRect frame = cell.frame;
                frame.origin.y = frame.origin.y - KKMTableRowExpandHeight + frame.size.height;
                cell.frame = frame;
            }
        }
        // expand selected cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        CGRect frame = cell.frame;
        frame.size.height = KKMTableRowDefaultHeight;
        cell.frame = frame;
    } completion:^(BOOL finished) {
        [self showViews:viewsToShow];
        [tableView reloadData];  // commit final state
    }];
}

- (void)tableView:(UITableView *)tableView expandRowAtIndexPath:(NSIndexPath *)expandIndexPath collapseRowAtIndexPath:(NSIndexPath *)collapseIndexPath viewsToShow:viewsToShow viewsToHide:viewsToHide
{
    [self hideViews:viewsToHide];

    [UIView animateWithDuration:0.5 animations:^{
        
        // move down cells which are below selected one
        for (UITableViewCell *cell in tableView.visibleCells) {
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
            
            if (cellIndexPath.row > collapseIndexPath.row) {
                CGRect frame = cell.frame;
                frame.origin.y = frame.origin.y - KKMTableRowExpandHeight + frame.size.height;
                cell.frame = frame;
            }
        }
        // expand selected cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:collapseIndexPath];
        
        CGRect frame = cell.frame;
        frame.size.height = KKMTableRowDefaultHeight;
        cell.frame = frame;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            for (UITableViewCell *cell in tableView.visibleCells) {
                NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
                
                if (cellIndexPath.row > expandIndexPath.row) {
                    CGRect frame = cell.frame;
                    frame.origin.y += KKMTableRowExpandHeight - frame.size.height;
                    cell.frame = frame;
                }
            }
            // expand selected cell
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:expandIndexPath];
            
            CGRect frame = cell.frame;
            frame.size.height = KKMTableRowExpandHeight;
            cell.frame = frame;
        } completion:^(BOOL finished) {
            [self showViews:viewsToShow];
            [tableView reloadData];  // commit final state
        }];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectedIndexPath])
    {
        return 200.0f;
    }
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:self.yearFromPickerView])
        return self.yearFromRangeArray.count;
    else if([pickerView isEqual:self.yearToPickerView])
        return self.yearToRangeArray.count;
    else if([pickerView isEqual:self.priceMinPickerView])
        return self.priceMinRangeArray.count;
    else if([pickerView isEqual:self.priceMaxPickerView])
        return self.priceMaxRangeArray.count;

    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *text;
    
    if([pickerView isEqual:self.yearFromPickerView])
        text = [self.yearFromRangeArray objectAtIndex:row];
    else if([pickerView isEqual:self.yearToPickerView])
        text = [self.yearToRangeArray objectAtIndex:row];
    else if([pickerView isEqual:self.priceMinPickerView])
        text = [self.priceMinRangeArray objectAtIndex:row];
    else if([pickerView isEqual:self.priceMaxPickerView])
        text = [self.priceMaxRangeArray objectAtIndex:row];
    
    return [self pickerReusingView:view withText:text];
}

- (UIView *)pickerReusingView:(UIView *)view withText:(NSString *)text
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont systemFontOfSize:12]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    tView.text = text;
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger yearFromRow = [self.yearFromPickerView selectedRowInComponent:0];
    NSInteger yearToRow = [self.yearToPickerView selectedRowInComponent:0] + 1;
    
    NSInteger priceMinRow = [self.priceMinPickerView selectedRowInComponent:0];
    NSInteger priceMaxRow = [self.priceMaxPickerView selectedRowInComponent:0];

    if ([pickerView isEqual:self.yearFromPickerView])
    {
        if (yearFromRow > yearToRow)
            [self.yearToPickerView selectRow:row-1 inComponent:0 animated:YES];
    }
    else if ([pickerView isEqual:self.yearToPickerView])
    {
        if (yearToRow < yearFromRow)
            [self.yearFromPickerView selectRow:yearToRow inComponent:0 animated:YES];
    }
    else if ([pickerView isEqual:self.priceMinPickerView])
    {
        if (priceMinRow > priceMaxRow)
            [self.priceMaxPickerView selectRow:priceMinRow inComponent:0 animated:YES];
    }
    else if ([pickerView isEqual:self.priceMaxPickerView])
    {
        if (priceMaxRow < priceMinRow)
            [self.priceMinPickerView selectRow:priceMaxRow inComponent:0 animated:YES];
    }
}

@end
