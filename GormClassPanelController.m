/* GormClassPanelController.m
 *
 * Copyright (C) 2004 Free Software Foundation, Inc.
 *
 * Author:	Gregory John Casamento <greg_casamento@yahoo.com>
 * Date:	2004
 * 
 * This file is part of GNUstep.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/* All Rights reserved */

#include <AppKit/AppKit.h>
#include "GormClassPanelController.h"
#include "GormPrivate.h"

@implementation GormClassPanelController

- (id) initWithTitle: (NSString *)title classList: (NSArray *)classes
{
  self = [super init];
  if(self != nil)
    {
      if ( ![NSBundle loadNibNamed:@"GormClassPanel" owner:self] )
	{
	  NSLog(@"Can not load bundle GormClassPanel");
	  return nil;
	}
    }

  ASSIGN(allClasses, [classes mutableCopy]);
  [allClasses removeObject: @"FirstResponder"];
  [panel setTitle: title];

  return self;
}

- (NSString *)runModal
{
  [NSApp runModalForWindow: panel];
  [panel orderOut: self];
  return className;
}

- (void) dealloc
{
  RELEASE(allClasses);
  RELEASE(className);
  RELEASE(panel);
  [super dealloc];
}

- (void) okButton: (id)sender
{
  ASSIGN(className, [[classBrowser selectedCell] stringValue]);
  [NSApp stopModal];
}

- (int) browser: (NSBrowser*)sender numberOfRowsInColumn: (int)column
{
  return [allClasses count];
}

- (NSString*) browser: (NSBrowser*)sender titleOfColumn: (int)column
{
  return @"Class";
}

- (void) browser: (NSBrowser*)sender
 willDisplayCell: (id)aCell
	   atRow: (int)row
	  column: (int)col
{
  if (row >= 0 && row < [allClasses count])
    {
      [aCell setStringValue: [allClasses objectAtIndex: row]];
      [aCell setEnabled: YES];
    }
  else
    {
      [aCell setStringValue: @""];
      [aCell setEnabled: NO];
    }
  [aCell setLeaf: YES];
}
@end