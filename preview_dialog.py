#!/usr/bin/env python
# Copyright (c) 2009 Taylon Silmer <taylonsilva@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, 
# MA 02111-1307, USA.
from optparse import OptionParser
import os

import gtk

class Window(gtk.Window):
    def __init__(self, title, window_position):
        super(Window, self).__init__()

        self.set_title(title)
        self.set_decorated(False)
        self.set_border_width(2)
        self.connect("key-press-event", gtk.main_quit)

        if window_position == 'right_bottom':
            self.set_gravity(gtk.gdk.GRAVITY_SOUTH_EAST)
            width, height = self.get_size()
            self.move(gtk.gdk.screen_width() - width, gtk.gdk.screen_height() - height)
        elif window_position == 'right_top':
            width, height = self.get_size()
            self.move(gtk.gdk.screen_width() - width, 0)
        else:
            self.set_position(gtk.WIN_POS_CENTER)

class ImageWindow(Window):
    def __init__(self, image_dir, title, window_position):
        super(ImageWindow, self).__init__(title, window_position)

        image = gtk.Image()
        image.set_from_file(image_dir)

        self.add(image)
        self.show_all()

class ColorWindow(Window):
    def __init__(self, color, title, window_position):
        super(ColorWindow, self).__init__(title, window_position)

        self.color_area = gtk.DrawingArea()
        self.color_area.set_size_request(120, 75)
        self.color_area.modify_bg(gtk.STATE_NORMAL, gtk.gdk.color_parse(color))

        self.add(self.color_area)
        self.show_all()

argv = OptionParser()
argv.add_option("-s", "--show", action="store", dest="show", type="string", help="Image or Color to show")
argv.add_option("-t", "--title", action="store", dest="title", type="string", help="Window title")
argv.add_option("-p", "--position", action="store", dest="window_position", type="string", help="Window position")

(args, trash) = argv.parse_args()

if not args.title:
    args.title = 'VIM'

if not args.window_position:
    args.window_position='right_bottom'

# For be a file need to have a '/' (setting path) and a '.' (setting file extension)
if '/' in args.show and '.' in args.show and os.path.isfile(args.show):
    ImageWindow(args.show, args.title, args.window_position)
else:
    try:
        ColorWindow('#' + args.show, args.title, args.window_position)
    except:
        ColorWindow(args.show, args.title, args.window_position)

gtk.main()
