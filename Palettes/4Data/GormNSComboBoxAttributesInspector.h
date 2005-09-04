/* 
   GormNSComboBoxAttributesInspector.h

   Copyright (C) 2001-2005 Free Software Foundation, Inc.

   Author:  Laurent Julliard <laurent@julliard-online.org>
   Date: Nov 2001
   
   This file is part of GNUstep.
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111 USA.
*/

/*
  July 2005 : Spilt inspector in separate classes.
  Always use ok: revert: methods
  Clean up
  Author : Fabien Vallon <fabien@sonappart.net>
*/

#ifndef INCLUDED_GormNSComboBoxAttributesInspector_h
#define INCLUDED_GormNSComboBoxAttributesInspector_h

#include <InterfaceBuilder/IBInspector.h>

@class NSMutableArray;
@class NSMatrix;
@class NSButton;
@class NSColorWell;
@class NSForm;
@class NSTableView;
@class NSTextField;

@interface GormNSComboBoxAttributesInspector: IBInspector
{
   NSMatrix *alignmentMatrix;
   NSColorWell *backgroundColorWell;
   NSForm  *itemField;
   NSButton *editable;
   NSButton *selectable;
   NSButton *usesDataSource;
   NSColorWell *textColorWell;
   NSForm *visibleItemsForm;
   NSTableView *itemTableView;
   NSTextField *itemTxt;
   NSButton *addButton;
   NSButton *removeButton;
@private
   NSMutableArray *itemsArray;
}
 @end

#endif
