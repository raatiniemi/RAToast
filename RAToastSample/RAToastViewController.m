//
//  RAViewController.m
//  RAToastSample
//
//  Created by Tobias Raatiniemi on 2014-06-13.
//  Copyright (c) 2014 Raatiniemi. All rights reserved.
//

#import "RAToastViewController.h"

@interface RAToastViewController () {
@private
	NSArray *_rows;
}

/// List of available toast configuration.
@property NSArray *rows;

@end

@implementation RAToastViewController

@synthesize rows = _rows;

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Adjust the background color, since the background color of the toast box
	// are semi-transparent black.
	[[self view] setBackgroundColor:[UIColor whiteColor]];

	// Setup the available toast gravities.
	NSMutableArray *rows = [[NSMutableArray alloc] init];
	[rows addObject:@"Top left"];
	[rows addObject:@"Top center"];
	[rows addObject:@"Top right"];
	[rows addObject:@"Bottom left"];
	[rows addObject:@"Bottom center"];
	[rows addObject:@"Bottom right"];
	[rows addObject:@"Default"];
	[self setRows:rows];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( !cell ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:14.0]];
		[[cell textLabel] setTextColor:[UIColor darkGrayColor]];

		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
		[[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
		[[cell detailTextLabel] setNumberOfLines:0];
	}

	NSString *text = [[self rows] objectAtIndex:[indexPath row]];
	[[cell textLabel] setText:text];

	if ( [@"Top left" isEqualToString:text] ) {
		[[cell detailTextLabel] setText:@"RAToastGravityTop|RAToastGravityLeft"];
	} else if ( [@"Top center" isEqualToString:text] ) {
		[[cell detailTextLabel] setText:@"RAToastGravityTop"];
	} else if ( [@"Top right" isEqualToString:text] ) {
		[[cell detailTextLabel] setText:@"RAToastGravityTop|RAToastGravityRight"];
	} else if ( [@"Bottom left" isEqualToString:text] ) {
		[[cell detailTextLabel] setText:@"RAToastGravityBottom|RAToastGravityLeft"];
	} else if ( [@"Bottom center" isEqualToString:text] ) {
		[[cell detailTextLabel] setText:@"RAToastGravityBottom"];
	} else if ( [@"Bottom right" isEqualToString:text] ) {
		[[cell detailTextLabel] setText:@"RAToastGravityBottom|RAToastGravityRight"];
	}

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self rows] count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Initialize the toast.
	RAToast *toast = [RAToast makeText:@"Foobar"];
	NSString *text = [[self rows] objectAtIndex:[indexPath row]];

	// Depending on the row text adjust the toast gravity.
	if ( [@"Top left" isEqualToString:text] ) {
		[toast setGravity:RAToastGravityTop|RAToastGravityLeft];
	} else if ( [@"Top center" isEqualToString:text] ) {
		[toast setGravity:RAToastGravityTop];
	} else if ( [@"Top right" isEqualToString:text] ) {
		[toast setGravity:RAToastGravityTop|RAToastGravityRight];
	} else if ( [@"Bottom left" isEqualToString:text] ) {
		[toast setGravity:RAToastGravityBottom|RAToastGravityLeft];
	} else if ( [@"Bottom center" isEqualToString:text] ) {
		[toast setGravity:RAToastGravityBottom];
	} else if ( [@"Bottom right" isEqualToString:text] ) {
		[toast setGravity:RAToastGravityBottom|RAToastGravityRight];
	}

	// Show the toast.
	[toast show];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end