/* GormObjectEditor.m
 *
 * Copyright (C) 1999 Free Software Foundation, Inc.
 *
 * Author:	Richard Frith-Macdonald <richard@brainstrom.co.uk>
 * Date:	1999
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

#include "GormPrivate.h"

/*
 * Method to return the image that should be used to display objects within
 * the matrix containing the objects in a document.
 */
@implementation NSObject (GormObjectAdditions)
- (NSString*) inspectorClassName
{
  return @"GormObjectInspector";
}
- (NSString*) connectInspectorClassName
{
  return @"GormObjectInspector";
}
- (NSString*) sizeInspectorClassName
{
  return @"GormObjectInspector";
}
- (NSString*) helpInspectorClassName
{
  return @"GormObjectInspector";
}
- (NSString*) classInspectorClassName
{
  return @"GormObjectInspector";
}
- (NSString*) editorClassName
{
  return @"GormObjectEditor";
}
- (NSImage*) imageForViewer
{
  static NSImage	*image = nil;

  if (image == nil)
    {
      NSBundle	*bundle = [NSBundle mainBundle];
      NSString	*path = [bundle pathForImageResource: @"GormObject"];

      image = [[NSImage alloc] initWithContentsOfFile: path];
    }
  return image;
}
@end



@implementation	GormObjectEditor

static NSMapTable	*docMap = 0;

+ (void) initialize
{
  if (self == [GormObjectEditor class])
    {
      docMap = NSCreateMapTable(NSNonRetainedObjectMapKeyCallBacks,
	NSObjectMapValueCallBacks, 2);
    }
}

- (BOOL) acceptsTypeFromArray: (NSArray*)types
{
  return NO;
}

- (BOOL) activate
{
  [window makeKeyAndOrderFront: self];
  return YES;
}

- (void) addObject: (id)anObject
{
  if (anObject != nil
    && [objects indexOfObjectIdenticalTo: anObject] == NSNotFound)
    {
      [objects addObject: anObject];
      [self refreshCells];
    }
}

- (id) changeSelection: (id)sender
{
  int	row = [self selectedRow];
  int	col = [self selectedColumn];
  int	index = row * [self numberOfColumns] + col;
  id	obj = nil;

  if (index >= 0 && index < [objects count])
    {
      obj = [objects objectAtIndex: index];
      if (obj != selected)
	{
	  NSNotificationCenter	*nc = [NSNotificationCenter defaultCenter];

	  selected = obj;
	  [nc postNotificationName: IBSelectionChangedNotification
			    object: self];
	}
    }
  return obj;
}

- (void) close
{
  [self closeSubeditors];
}

- (void) closeSubeditors
{
}

- (BOOL) containsObject: (id)object
{
  if ([objects indexOfObjectIdenticalTo: object] == NSNotFound)
    return NO;
  return YES;
}

- (void) copySelection
{
}

- (void) dealloc
{
  RELEASE(objects);
  [super dealloc];
}

- (void) deleteSelection
{
}

/*
 *	Dragging source protocol implementation
 */
- (void) draggedImage: (NSImage*)i endedAt: (NSPoint)p deposited: (BOOL)f
{
  NSString	*type = [[dragPb types] lastObject];

  /*
   * Windows are an exception to the normal DnD mechanism - we create them
   * if they are dropped anywhere except back in the pallettes view -
   * ie. if they are dragged, but the drop fails.
   */
  if (f == NO && [type isEqual: IBWindowPboardType] == YES)
    {
      id<IBDocuments>	active = [(id<IB>)NSApp activeDocument];

      if (active != nil)
	{
	  [active pasteType: type fromPasteboard: dragPb parent: nil];
	}
    }
}

- (unsigned) draggingEntered: (id<NSDraggingInfo>)sender
{
  NSArray	*types;

  dragPb = [sender draggingPasteboard];
  types = [dragPb types];
  if ([types containsObject: IBObjectPboardType] == YES)
    {
      dragType = IBObjectPboardType;
    }
  else if ([types containsObject: GormLinkPboardType] == YES)
    {
      dragType = GormLinkPboardType;
    }
  else
    {
      dragType = nil;
    }
  return [self draggingUpdated: sender];
}

- (unsigned) draggingUpdated: (id<NSDraggingInfo>)sender
{
  if (dragType == IBObjectPboardType)
    {
      return NSDragOperationCopy;
    }
  else if (dragType == GormLinkPboardType)
    {
      NSPoint	loc = [sender draggingLocation];
      int	r, c;
      int	pos;
      id	obj = nil;

      loc = [self convertPoint: loc fromView: nil];
      [self getRow: &r column: &c forPoint: loc];
      pos = r * [self numberOfColumns] + c;
      if (pos >= 0 && pos < [objects count])
	{
	  obj = [objects objectAtIndex: pos];
	}
      [NSApp displayConnectionBetween: [NSApp connectSource] and: obj];
      return NSDragOperationLink;
    }
  else
    {
      return 0;
    }
}

- (unsigned int) draggingSourceOperationMaskForLocal: (BOOL)flag
{
  return NSDragOperationLink;
}

- (void) drawSelection
{
}

- (id<IBDocuments>) document
{
  return document;
}

- (id) editedObject
{
  return selected;
}

/*
 *	Initialisation - register to receive DnD with our own types.
 */
- (id) initWithObject: (id)anObject inDocument: (id<IBDocuments>)aDocument
{
  id	old = NSMapGet(docMap, (void*)aDocument);

  if (old != nil)
    {
      RELEASE(self);
      self = RETAIN(old);
      [self addObject: anObject];
      return self;
    }

  self = [super init];
  if (self != nil)
    {
      NSButtonCell	*proto;

      document = aDocument;

      [self registerForDraggedTypes: [NSArray arrayWithObjects:
	IBObjectPboardType, GormLinkPboardType, nil]];

      [self setAutosizesCells: NO];
      [self setCellSize: NSMakeSize(72,72)];
      [self setIntercellSpacing: NSMakeSize(8,8)];
      [self setAutoresizingMask: NSViewMinYMargin|NSViewWidthSizable];
      [self setMode: NSRadioModeMatrix];
      /*
       * Send mouse click actions to self, so we can handle selection.
       */
      [self setAction: @selector(changeSelection:)];
      [self setDoubleAction: @selector(raiseSelection:)];
      [self setTarget: self];

      objects = [NSMutableArray new];
      proto = [NSButtonCell new];
      [proto setBordered: NO];
      [proto setAlignment: NSCenterTextAlignment];
      [proto setImagePosition: NSImageAbove];
      [proto setSelectable: NO];
      [proto setEditable: NO];
      [self setPrototype: proto];
      RELEASE(proto);
      NSMapInsert(docMap, (void*)aDocument, (void*)self);
      [self addObject: anObject];
    }
  return self;
}

- (void) makeSelectionVisible: (BOOL)flag
{
  if (flag == YES && selected != nil)
    {
      unsigned	pos = [objects indexOfObjectIdenticalTo: selected];
      int	r = pos / [self numberOfColumns];
      int	c = pos % [self numberOfColumns];

      [self selectCellAtRow: r column: c];
    }
  else
    {
      [self deselectAllCells];
    }
}

- (void) mouseDown: (NSEvent*)theEvent
{
  NSView	*view;

  mouseDownPoint = [theEvent locationInWindow];
  [super mouseDown: theEvent];
}

- (id<IBEditors>) openSubeditorForObject: (id)anObject
{
  return nil;
}

- (void) orderFront
{
  [window orderFront: self];
}

- (void) pasteInSelection
{
}

- (BOOL) performDragOperation: (id<NSDraggingInfo>)sender
{
  return YES;
}

- (BOOL) prepareForDragOperation: (id<NSDraggingInfo>)sender
{
  return YES;
}

- (id) raiseSelection: (id)sender
{
  id	obj = [self changeSelection: sender];

  if ([obj isKindOfClass: [NSWindow class]])
    {
      [obj makeKeyAndOrderFront: self];
    }
  else if ([obj isKindOfClass: [NSMenu class]])
    {
      NSLog(@"Menu needs raising"); /* FIXME */
    }
  return self;
}

/*
 * Return the rectangle in which an objects image will be displayed.
 */
- (NSRect) rectForObject: (id)anObject
{
  unsigned	pos = [objects indexOfObjectIdenticalTo: anObject];
  NSRect	rect;
  int		r;
  int		c;

  if (pos == NSNotFound)
    return NSZeroRect;
  r = pos / [self numberOfColumns];
  c = pos % [self numberOfColumns];
  rect = [self cellFrameAtRow: r column: c];
  /*
   * Adjust to image area.
   */
  rect.size.width -= 15;
  rect.size.height -= 15;
  return rect;
}

- (void) refreshCells
{
  unsigned	count = [objects count];
  unsigned	index;
  int		cols = 0;
  int		rows;
  int		width;

  width = [[self superview] bounds].size.width;
  while (width >= 72)
    {
      width -= (72 + 8);
      cols++;
    }
  if (cols == 0)
    {
      cols = 1;
    }
  rows = count / cols;
  if (rows == 0 || rows * cols != count)
    {
      rows++;
    }
  [self renewRows: rows columns: cols];

  for (index = 0; index < count; index++)
    {
      id		obj = [objects objectAtIndex: index];
      NSButtonCell	*but = [self cellAtRow: index/cols column: index%cols];

      [but setImage: [obj imageForViewer]];
      [but setTitle: [document nameForObject: obj]];
      [but setShowsStateBy: NSChangeGrayCellMask];
      [but setHighlightsBy: NSChangeGrayCellMask];
    }
  while (index < rows * cols)
    {
      NSButtonCell	*but = [self cellAtRow: index/cols column: index%cols];

      [but setImage: nil];
      [but setTitle: nil];
      [but setShowsStateBy: NSNoCellMask];
      [but setHighlightsBy: NSNoCellMask];
      index++;
    }
  [self setIntercellSpacing: NSMakeSize(8,8)];
  [self sizeToCells];
  [self setNeedsDisplay: YES];
}

- (void) removeObject: (id)anObject
{
  unsigned	pos;

  pos = [objects indexOfObjectIdenticalTo: anObject];
  if (pos == NSNotFound)
    {
      return;
    }
  [objects removeObjectAtIndex: pos];
  [self refreshCells];
}

- (void) resetObject: (id)anObject
{
}

- (void) resizeWithOldSuperviewSize: (NSSize)oldSize
{
  [self refreshCells];
}

- (void) selectObjects: (NSArray*)anArray
{
  id	obj = [anArray lastObject];

  if (obj != selected)
    {
      selected = obj;
      [document setSelectionFromEditor: self];
    }
}

- (NSArray*) selection
{
  if (selected == nil)
    return [NSArray array];
  else
    return [NSArray arrayWithObject: selected];
}

- (unsigned) selectionCount
{
  return (selected == nil) ? 0 : 1;
}

- (void) validateEditing
{
}

- (BOOL) wantsSelection
{
  return NO;
}

- (NSWindow*) window
{
  return [super window];
}
@end
