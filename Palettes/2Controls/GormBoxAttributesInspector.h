/*
  GormBoxAttributesInspector.h

   Copyright (C) 2001-2005 Free Software Foundation, Inc.

   Author: Adam Fedor <fedor@gnu.org>
           Laurent Julliard <laurent@julliard-online.org>
   Date: Aug 2001
   Author: Gregory John Casamento <greg_casamento@yahoo.com>
   Date: 2003, 2004, 2005
   
   This file is part of GNUstep.
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
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


#ifndef	INCLUDED_GormBoxAttributesInspector_h
#define	INCLUDED_GormBoxAttributesInspector_h

#include <InterfaceBuilder/InterfaceBuilder.h>

@class NSButton;
@class NSColorWell;
@class NSForm;
@class NSMatrix;
@class NSSlider;

@interface GormBoxAttributesInspector:IBInspector
{
  NSMatrix *positionMatrix;
  NSMatrix *borderMatrix;
  NSForm *titleForm;
  NSSlider *horizontalSlider;
  NSSlider *verticalSlider;
  NSColorWell *colorWell;
  NSButton *backgroundSwitch;
}

@end

#endif /* INCLUDED_GormBoxAttributesInspector_h */
