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

@interface KKMCollectorCarsSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *yearFromPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *yearToPickerView;
@property (weak, nonatomic) IBOutlet UILabel *yearSelectedValueLablel;

@property (weak, nonatomic) IBOutlet UIPickerView *priceMinPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *priceMaxPickerView;
@property (weak, nonatomic) IBOutlet UILabel *priceSelectedValueLabel;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) NSMutableArray *yearRangeArray;
@property (nonatomic, strong) NSMutableArray *priceRangeArray;

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
    
    [self.yearFromPickerView selectRow:54 inComponent:0 animated:YES];
    [self.yearToPickerView selectRow:(self.yearRangeArray.count - 1) inComponent:0 animated:YES];
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
    self.yearRangeArray = [NSMutableArray new];
    [self.yearRangeArray addObject:@"Any"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];

    for (int i = 1896; i <= year; i++)
    {
        [self.yearRangeArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [self.yearRangeArray addObject:@"To"];
    
    
    
    
    // price
    self.priceRangeArray = [NSMutableArray new];
    [self.priceRangeArray addObject:@"Any"];

    NSInteger j = 0;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];

    while (j <= KKMMaxPriceRange)
    {
        j += KKMPriceIncrement;
        [self.priceRangeArray addObject:[numberFormatter stringFromNumber:[NSNumber numberWithInteger:j]]];
    }    
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *viewsToShow;
    NSArray *viewsToHide;
    
    if (indexPath.row == 0)
        return;
    else if(indexPath.row == 1)
    {
        viewsToShow = @[self.yearFromPickerView, self.yearToPickerView];
        viewsToHide = @[self.yearSelectedValueLablel];
    }
    else if(indexPath.row == 2)
    {
        viewsToShow = @[self.priceMinPickerView, self.priceMaxPickerView];
        viewsToHide = @[self.priceSelectedValueLabel];
    }

    
    if (self.selectedIndexPath && [indexPath isEqual:self.selectedIndexPath])
    {
        // same row tapped, so collapse the row
        self.selectedIndexPath = nil;
        [self hideViews:viewsToShow];
        [self showViews:viewsToHide];
        [self tableView:tableView collapseRowAtIndexPath:indexPath];
        return;
    }
    
    if(self.selectedIndexPath)
    {
        [self hideViews:viewsToShow];
        [self showViews:viewsToHide];
        [self tableView:tableView expandRowAtIndexPath:indexPath viewsToShow:viewsToShow viewsToHide:viewsToHide];
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
    [self hideViews:viewsToHide];
    
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

- (void)tableView:(UITableView *)tableView collapseRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [tableView reloadData];  // commit final state
    }];
}

- (void)tableView:(UITableView *)tableView expandRowAtIndexPath:(NSIndexPath *)indexPath collapseRowAtIndexPath:(NSIndexPath *)collapseIndexPath
{
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
    if([self isYearPicker:pickerView])
        return self.yearRangeArray.count;
    else if([self isPricePicker:pickerView])
        return self.priceRangeArray.count;
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self isYearPicker:pickerView])
        return self.yearRangeArray[row];
    else if([self isPricePicker:pickerView])
        return self.priceRangeArray[row];
    return 0;
}

- (BOOL)isYearPicker:(UIPickerView *)pickerView
{
    return ([pickerView isEqual:self.yearFromPickerView] || [pickerView isEqual:self.yearToPickerView]);
}

- (BOOL)isPricePicker:(UIPickerView *)pickerView
{
    return ([pickerView isEqual:self.priceMinPickerView] || [pickerView isEqual:self.priceMaxPickerView]);
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if ([self isYearPicker:pickerView])
    {
        UILabel* tView = (UILabel*)view;
        if (!tView)
        {
            tView = [[UILabel alloc] init];
            [tView setFont:[UIFont systemFontOfSize:12]];
            [tView setTextAlignment:NSTextAlignmentCenter];
        }
        tView.text=[self.yearRangeArray objectAtIndex:row];
        return tView;
    }
    else if([self isPricePicker:pickerView])
    {
        UILabel* tView = (UILabel*)view;
        if (!tView)
        {
            tView = [[UILabel alloc] init];
            [tView setFont:[UIFont systemFontOfSize:12]];
            [tView setTextAlignment:NSTextAlignmentCenter];
        }
        tView.text=[self.priceRangeArray objectAtIndex:row];
        return tView;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.yearFromPickerView])
    {
        //- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;  // scrolls the specified row to center.
        [self.yearToPickerView selectRow:row inComponent:0 animated:YES];
    }
}

@end
