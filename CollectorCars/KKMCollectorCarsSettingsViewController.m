//
//  ViewController.m
//  CollectorCars
//
//  Created by Mohan, Kishore Kumar on 8/11/15.
//  Copyright (c) 2015 Mohan, Kishore Kumar. All rights reserved.
//

#import "KKMCollectorCarsSettingsViewController.h"
#import "KKMCollectorCarsRequest.h"

NSInteger const KKMMaxPriceRange = 1000000; //1M
NSInteger const KKMPriceIncrement = 50000;

NSInteger const KKMTableRowExpandHeight = 200.0f;
NSInteger const KKMTableRowDefaultHeight = 44.0f;

NSString* const KKMAnyString = @"Any";
NSString* const KKMNoMinString = @"No Min";
NSString* const KKMNoMaxString = @"No Max";
NSString* const KKMUpToString = @"up to";
NSString* const KKMPlusString = @"+";

@interface KKMCollectorCarsSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentControl;

@property (weak, nonatomic) IBOutlet UIPickerView *yearFromPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *yearToPickerView;
@property (weak, nonatomic) IBOutlet UILabel *yearSelectedValueLablel;

@property (weak, nonatomic) IBOutlet UIPickerView *priceMinPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *priceMaxPickerView;
@property (weak, nonatomic) IBOutlet UILabel *priceSelectedValueLabel;

@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;

@property (nonatomic, strong) NSMutableArray *yearFromRangeArray;
@property (nonatomic, strong) NSMutableArray *yearToRangeArray;

@property (nonatomic, strong) NSMutableArray *priceMinRangeArray;
@property (nonatomic, strong) NSMutableArray *priceMaxRangeArray;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation KKMCollectorCarsSettingsViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInitialDataFromRequest];
    [self setUp];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpPickerDefaultValues];
}

#pragma mark - Action

- (IBAction)saveButtonTapped:(id)sender
{
    KKMCollectorCarsRequest *request = [[KKMCollectorCarsRequest alloc] init];

    if(self.categorySegmentControl.selectedSegmentIndex == 0)
        request.categoryID = 6001;
    else
        request.categoryID = 6024;
    
    request.keywords = self.keywordTextField.text;
    [self.saveButtonDelegate saveButtonTappedOnViewController:self withRequest:request];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup

- (void)setupInitialDataFromRequest
{
    if (self.request.categoryID == 6001)
        [self.categorySegmentControl setSelectedSegmentIndex:0];
    else
        [self.categorySegmentControl setSelectedSegmentIndex:1];
    
    if (self.request.keywords)
        self.keywordTextField.text = self.request.keywords;
}

- (void)setUp
{
    [self hidePickerViews];
    [self setUpYearPickerData];
    [self setUpPricePickerData];
}

- (void)hidePickerViews
{
    self.yearFromPickerView.hidden = YES;
    self.yearToPickerView.hidden = YES;
    self.priceMinPickerView.hidden = YES;
    self.priceMaxPickerView.hidden = YES;
}

- (void)setUpPricePickerData
{
    self.priceMinRangeArray = [NSMutableArray new];
    self.priceMaxRangeArray = [NSMutableArray new];
    [self.priceMinRangeArray addObject:KKMNoMinString];
    
    NSInteger j = 0;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];
    
    NSString *str;
    while (j < KKMMaxPriceRange)
    {
        j += KKMPriceIncrement;
        str =[numberFormatter stringFromNumber:[NSNumber numberWithInteger:j]];
        [self.priceMinRangeArray addObject:str];
        [self.priceMaxRangeArray addObject:str];
    }
    
    [self.priceMaxRangeArray addObject:KKMNoMaxString];
}

- (void)setUpYearPickerData
{
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
    
    [self setUpPricePickerData];
}

- (void)setUpPickerDefaultValues
{
    [self.yearFromPickerView reloadAllComponents];
    [self.yearToPickerView reloadAllComponents];
    
    [self.yearFromPickerView selectRow:0 inComponent:0 animated:YES];
    [self.yearToPickerView selectRow:(self.yearToRangeArray.count - 1) inComponent:0 animated:YES];
    self.yearSelectedValueLablel.text = KKMAnyString;
    
    
    [self.priceMinPickerView reloadAllComponents];
    [self.priceMaxPickerView reloadAllComponents];
    
    [self.priceMinPickerView selectRow:0 inComponent:0 animated:YES];
    [self.priceMaxPickerView selectRow:(self.priceMaxRangeArray.count -1) inComponent:0 animated:YES];
    self.priceSelectedValueLabel.text = KKMAnyString;
}


#pragma mark - Actions
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reset:(id)sender
{
    [self setUpPickerDefaultValues];
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4)
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (NSString*)tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger fromRow = 0;
    NSInteger toRow = 0;
    
    if([self isYearPickerView:pickerView])
    {
        fromRow = [self.yearFromPickerView selectedRowInComponent:0];
        toRow = [self.yearToPickerView selectedRowInComponent:0] + 1;
    }
    else if([self isPricePickerView:pickerView])
    {
        fromRow = [self.priceMinPickerView selectedRowInComponent:0];
        toRow = [self.priceMaxPickerView selectedRowInComponent:0];
    }
    
    
    if ([pickerView isEqual:self.yearFromPickerView])
    {
        if (fromRow > toRow)
            [self.yearToPickerView selectRow:row-1 inComponent:0 animated:YES];
    }
    else if ([pickerView isEqual:self.yearToPickerView])
    {
        if (toRow < fromRow)
            [self.yearFromPickerView selectRow:toRow inComponent:0 animated:YES];
    }
    else if ([pickerView isEqual:self.priceMinPickerView])
    {
        if (fromRow > toRow)
            [self.priceMaxPickerView selectRow:fromRow inComponent:0 animated:YES];
    }
    else if ([pickerView isEqual:self.priceMaxPickerView])
    {
        if (toRow < fromRow)
            [self.priceMinPickerView selectRow:toRow inComponent:0 animated:YES];
    }
    
    
    [self setSelectedPickerValues:pickerView fromRow:(NSInteger)fromRow toRow:(NSInteger)toRow];
}

#pragma mark - UIPickerViewDataSource Helpers

- (void)setSelectedPickerValues:(UIPickerView *)pickerView fromRow:(NSInteger)fromRow toRow:(NSInteger)toRow
{
    NSString *fromText;
    NSString *toText;
    
    if([self isYearPickerView:pickerView])
    {
        fromText = self.yearFromRangeArray[fromRow];
        toText = self.yearToRangeArray[toRow - 1];
        
        self.yearSelectedValueLablel.text = [self selectedValueLabelFromText:fromText toText:toText];
    }
    else if([self isPricePickerView:pickerView])
    {
        fromText = self.priceMinRangeArray[fromRow];
        toText = self.priceMaxRangeArray[toRow];
        
        self.priceSelectedValueLabel.text = [self selectedValueLabelFromText:fromText toText:toText];
    }
}

- (NSString *)selectedValueLabelFromText:(NSString *)fromText toText:(NSString *)toText
{
    NSString *delimiterText = @" to ";
    
    if ([fromText isEqualToString:KKMNoMinString] && [toText isEqualToString:KKMNoMaxString])
    {
        delimiterText = @"Any";
        fromText = @"";
        toText = @"";
    }
    else
    {
        if ([fromText isEqualToString:KKMNoMinString])
        {
            fromText = KKMUpToString;
            delimiterText = @" ";
        }
        
        if ([toText isEqualToString:KKMNoMaxString])
        {
            toText = KKMPlusString;
            delimiterText = @"";
        }
    }
    
    return [NSString stringWithFormat:@"%@%@%@", fromText, delimiterText, toText];
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


- (BOOL)isYearPickerView:(UIPickerView *)pickerView
{
    return ([pickerView isEqual:self.yearFromPickerView] || [pickerView isEqual:self.yearToPickerView]);
}


- (BOOL)isPricePickerView:(UIPickerView *)pickerView
{
    return ([pickerView isEqual:self.priceMinPickerView] || [pickerView isEqual:self.priceMaxPickerView]);
}





@end
