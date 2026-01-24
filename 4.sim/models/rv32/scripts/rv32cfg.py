#!/usr/bin/env python3

# SPDX-License-Identifier: GPL-3.0-or-later

# =======================================================================
#
#  rv32.py                                             date: 2021/03/07
#
#  Author: Simon Southwell
#
#  Copyright (c) 2021 Simon Southwell
#
#  GUI front end for rv32_cpu ISS extension configuration
#
#  This file is part of the rv32_cpu instruction set simulator.
#
#  This file is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  The code is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  You should have received a copy of the GNU General Public License
#  along with this file. If not, see <http://www.gnu.org/licenses/>.
#
# =======================================================================

# Get libraries for interfacing with the OS
import os, subprocess, sys

# Get everything from Tkinter, as we use quite a lot
from tkinter      import *

# Override any Tk widgets that have themed versions in ttk,
# and pull in other ttk specific widgets (ie. Separator and Notebook)
from tkinter.ttk  import *

# Only promote what's used from the support libraries
from tkinter.filedialog import askopenfilename
from tkinter.messagebox import showinfo, showwarning

# ----------------------------------------------------------------
# Define the rv32gui class
# ----------------------------------------------------------------

class rv32gui :

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Constructor
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def __init__(self) :

    # ------------------------------------------------------------
    # Create the instance variables here (i.e. like C++ member
    # variables)
    # ------------------------------------------------------------

    # Get a Tk object
    self.root = Tk()

    # Create some Tk class variables to allow auto-update of
    # widgets. The 'boolean' checkbutton vars are integers,
    # with the rest as strings (even if meant for numbers)
    self.extI               = IntVar()
    self.extM               = IntVar()
    self.extA               = IntVar()
    self.extF               = IntVar()
    self.extD               = IntVar()
    self.extE               = IntVar()
    self.extC               = IntVar()
    self.extG               = IntVar()
    self.extZcr             = IntVar()
    self.extZifencei        = IntVar()

    self.machine            = IntVar()
    self.supervisor         = IntVar()
    self.user               = IntVar()

    self.arch               = StringVar()

    self.opfile             = StringVar()

    # Tk variables for directory locations
    self.scriptdir          = StringVar()
    self.rundir             = StringVar()

    # ------------------------------------------------------------
    # Set/configure instance objects here
    # ------------------------------------------------------------

    self.root.title('rv32.py : Copyright (c) 2021 WyvernSemi')

    # Configure the font for message boxes (the default is awful)
    self.root.option_add('*Dialog.msg.font', 'Ariel 10')

    # Set some location state
    self.scriptdir.set(os.path.dirname(os.path.realpath(sys.argv[0])))
    self.rundir.set(os.getcwd())

    # Change the default icon to something more appropriate
    self.__rv32SetIcon(self.root)

    # Set the Tk variables to default values

    self.extI.set       (1)
    self.extM.set       (1)
    self.extA.set       (1)
    self.extF.set       (1)
    self.extD.set       (1)
    self.extE.set       (0)
    self.extC.set       (1)
    self.extG.set       (1)
    self.extZcr.set     (1)
    self.extZifencei.set(1)

    self.machine.set    (1)
    self.supervisor.set (0)
    self.user.set       (0)

    self.arch.set       ('0') # 0 = RV32, 1 = RV64

    self.opfile.set     ('../include/rv32_extensions.h')

    # Setup up traces on the checkbox variables
    self.extF.trace       ('w', self.__rv32ExtFUpdated)
    self.extD.trace       ('w', self.__rv32ExtDUpdated)
    self.extG.trace       ('w', self.__rv32ExtGUpdated)

    self.extI.trace       ('w', self.__chkUpdated)
    self.extM.trace       ('w', self.__chkUpdated)
    self.extA.trace       ('w', self.__chkUpdated)
    self.extF.trace       ('w', self.__chkUpdated)
    self.extD.trace       ('w', self.__chkUpdated)
    self.extE.trace       ('w', self.__chkUpdated)
    self.extC.trace       ('w', self.__chkUpdated)
    self.extZcr.trace     ('w', self.__chkUpdated)
    self.extZifencei.trace('w', self.__chkUpdated)



  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define the 'Private' class methods
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  # --------------------------------------------------------------
  # Utility methods
  # --------------------------------------------------------------

  # __addCheckButtonRows()
  #
  # Creates an array of labelled check button widgets. Widgets are
  # children of 'frame' and a label for the frame is created from
  # 'labeltxt'. The tupleList should be a two dimensional array
  # ([row][col]) of tuples of the form:
  #  (<label txt>, <Tk variable>, <onvalue>)
  #
  # Returns list of widget handles as a linear list (scanning from left to right,
  # then top to bottom)

  @staticmethod
  def __addCheckButtonRows(labeltxt, tupleList, frame, padx = 15) :

    curr_row = 0

    # Add a label for this frame, if one specified
    if labeltxt != '' :
      Label(frame, text=labeltxt).grid(row=curr_row, sticky=W)
      curr_row += 1

    # Initialise the handle list
    hdllist = []

    # Loop through the list of rows
    for rowList in tupleList :

      curr_col = 0

      # Loop through the column tuples in the row list, extracting a
      # label text string, and a Tk variable
      for txt, var, onvalue in rowList :

        # Create a check button and specify grid position
        hdl = Checkbutton(master = frame, text = txt, variable = var, onvalue = onvalue)
        hdl.grid(row = curr_row, column = curr_col, sticky = W, padx = padx)

        # Add handle to list
        hdllist.append(hdl)

        curr_col += 1

      curr_row += 1

    # When done, return list of widget handles as a linear list
    # (scanning from left to right, then top to bottom)
    return hdllist


  # __addRadioButtonRows()
  #
  # Creates an array of labelled radio button widgets. Widgets are
  # children of 'frame' and a label for the frame is created from
  # 'labeltxt'. The tupleList should be a two dimensional array
  # ([row][col]) of tuples of the form:
  #  (<label txt>, <Tk variable>, <onvalue>)
  #
  # Returns list of widget handles as a linear list (scanning from left to right,
  # then top to bottom)
  @staticmethod
  def __addRadioButtonRows(labeltxt, tupleList, frame, padx = 15) :

    curr_row = 0

    # Add a label for this frame, if one specified
    if labeltxt != '' :
      Label(frame, text=labeltxt).grid(row=curr_row, sticky=W)
      curr_row += 1

    # Initialise the handle list
    hdllist = []

    # Loop through the list of rows
    for rowList in tupleList :

      curr_col = 0

      # Loop through the column tuples in the row list, extracting a
      # label text string, and a Tk variable
      for txt, var, onvalue in rowList :

        # Create a check button and specify grid position
        hdl = Radiobutton(master = frame, text = txt, variable = var, value = onvalue)
        hdl.grid(row = curr_row, column = curr_col, sticky = W, padx = padx)

        # Add handle to list
        hdllist.append(hdl)

        curr_col += 1

      curr_row += 1

    # When done, return list of widget handles as a linear list
    # (scanning from left to right, then top to bottom)
    return hdllist

  # __addFileEntryRows()
  #
  # Creates an array of labelled entry widgets with a folloiwng 'Browse' button.
  # Widgets are children of 'frame' and a label for the frame is created from 'labeltxt'.
  # tupleList should be a two dimensional array ([rows][cols]) of tuples
  # of the form:
  #    (<label txt>, <Tk variable>, <entry width>, <button txt>, <button callback>)
  # If button callback is None, then no button is added.
  #
  @staticmethod
  def __addFileEntryRows(labeltxt, tupleList, frame) :

    curr_row = 0

    # Add a label for this frame, if one specified
    if labeltxt != '' :
      Label(master = frame, text = labeltxt).grid(row = curr_row, sticky = W, pady = 0)
      curr_row += 1

    # Initialise the handle list
    hdllist = []

    # Loop through the list of rows
    for rowList in tupleList :

      curr_col = 0

      # Loop through the column tuples in the row list, extracting a
      # label text string, a Tk variable, a width value, button label text
      # and a button callback function
      for txt, var, width, btxt, bfunc in rowList :

        # Create a labelled entry widget and specify grid position
        Label(master = frame, text=txt).grid (row = curr_row, column = curr_col, sticky = E, pady = 5, padx = 5)
        curr_col += 1
        hdl = Entry(frame, textvariable = var, width = width)
        hdl.grid(row = curr_row, column = curr_col, sticky = W)

        # Add entry handle to handle list
        hdllist.append(hdl)

        if bfunc is not None :
          # In adjacent column, add a 'Browse' button
          curr_col += 1
          hdl = Button(master = frame, text = btxt, command = bfunc)
          hdl.grid (row = curr_row, column = curr_col, sticky = W, padx = 10)

          # Add handle for button to handle list
          hdllist.append(hdl)
          curr_col += 1

      curr_row += 1

    # When done, return list of widget handles as a linear list
    # (scanning from left to right---Entry then Button widgets---then
    # top to bottom)
    return hdllist


  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Callbacks
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  # __rv32ExtFUpdated()
  #
  # Callback for changes to F extension check box
  #
  def __rv32ExtFUpdated(self, object, lstidx, mode) :
    if self.extF.get() == 0 :
      self.extD.set(0)

  # __rv32ExtDUpdated()
  #
  # Callback for changes to D extension check box
  #
  def __rv32ExtDUpdated(self, object, lstidx, mode) :
    if self.extD.get() != 0 :
      self.extF.set(1)

  # __rv32ExtGUpdated()
  #
  # Callback for changes to G extension check box
  #
  def __rv32ExtGUpdated(self, object, lstidx, mode) :
    if self.extG.get() != 0 :
      self.extI.set(1)
      self.extZifencei.set(1)
      self.extZcr.set(1)
      self.extM.set(1)
      self.extA.set(1)
      self.extF.set(1)
      self.extD.set(1)
    else :
      if self.extI.get() and self.extZifencei.get() and self.extZcr.get() and self.extM.get() and self.extA.get() and self.extF.get() and self.extD.get() :
        showwarning('Warning', 'Unchecked G extension with all G extensions selected')

  def __chkUpdated(self, object, lstidx, mode) :
    if self.extI.get() and self.extZifencei.get() and self.extZcr.get() and self.extM.get() and self.extA.get() and self.extF.get() and self.extD.get() :
      self.extG.set(1)
    else :
      self.extG.set(0)

  # __rv32GetOutputFile()
  #
  # Callback for 'Browse' button of .h file
  #
  def __rv32GetOutputFile(self) :
    # Open a file select dialog box
    fname = askopenfilename(filetypes = (('header files','*.h'), ('all files','*.*')))

    # Only update the entry if the returned value not an empty string,
    # otherwise the checker fires an error when updating the box.
    if fname != '' :
      self.opfile.set(os.path.relpath(fname, self.rundir.get()))

  # __rv32Generate()
  #
  # Callback for 'Generate' button
  #
  def __rv32Generate(self) :

    # Open file for writing

    ofp = open(self.opfile.get(), 'w')

    # Print header
    ofp.write('\n// *** AUTOMATICALLY GENERATED FILE. DO NOT EDIT! ***\n\n')

    # Print ifndef include file definitions
    ofp.write('#ifndef _RV32_EXTENSIONS_H_\n')
    ofp.write('#define _RV32_EXTENSIONS_H_\n')
    ofp.write('\n')

    ofp.write('// Define the inheritance chain for adding new extensions.\n')
    ofp.write('// Currently this is setup to add Zicsr, M, A, F, and D\n')
    ofp.write('// in that order. If an extension were to be skipped,\n')
    ofp.write('// then the subsequent definition just uses the last\n')
    ofp.write('// active class to inherit from in place of the skipped\n')
    ofp.write('// class. Note, since the FENCE instruction is a NOP\n')
    ofp.write('// in this model, Zifencei is implicit in the rv32i_cpu\n')
    ofp.write('// base class.\n\n')

    # For all selected classes

    extensions = [(self.extI,   'rv32i_cpu',   'RV32_I_INHERITANCE_CLASS',     'RV32I_INCLUDE'),
                  (self.extZcr, 'rv32csr_cpu', 'RV32_ZICSR_INHERITANCE_CLASS', 'RV32CSR_INCLUDE'),
                  (self.extM,   'rv32m_cpu',   'RV32_M_INHERITANCE_CLASS',     'RV32M_INCLUDE'),
                  (self.extA,   'rv32a_cpu',   'RV32_A_INHERITANCE_CLASS',     'RV32A_INCLUDE'),
                  (self.extF,   'rv32f_cpu',   'RV32_F_INHERITANCE_CLASS',     'RV32F_INCLUDE'),
                  (self.extD,   'rv32d_cpu',   'RV32_D_INHERITANCE_CLASS',     'RV32D_INCLUDE'),
                  (self.extC,   'rv32c_cpu',   'RV32_C_INHERITANCE_CLASS',     'RV32C_INCLUDE')]

    lastExt = ''

    for flag, ext, define, incl in extensions :
      padStr = '     '
      if len(define) < 28 :
        padStr += ' ' * (28 - len(define))
      if flag.get() != 0 :
        ofp.write ('#define ' + define + padStr + lastExt + '\n')
        lastExt = ext
      else:
        if ext != 'rv32d_cpu' :
          ofp.write ('#define ' + define + padStr + 'rv32i_cpu' + ' /* Excluded, so defaulted to base so will compile */\n')
        else :
          ofp.write ('#define ' + define + padStr + 'rv32f_cpu' + ' /* Excluded, so defaulted to rv32f so will compile */\n')

    if self.extI.get() and self.extM.get() and self.extA.get() and self.extF.get() and self.extD.get() :
      ofp.write('\n// Inheritance for a G spec processor should have all the above\n')
      ofp.write('// classes inherited, without skips\n')
      ofp.write('#define RV32_G_INHERITANCE_CLASS         rv32d_cpu\n')


    ofp.write('\n// Uncomment the following to compile for RV32E base class,\n')
    ofp.write('// or define it when compiling rv32i_cpu.cpp\n')
    ofp.write('\n')
    if self.extE.get() == 0 :
      ofp.write('//')
    ofp.write('#define RV32E_EXTENSION\n')

    lastExt = 'rv32i_cpu'

    ofp.write('\n')

    ofp.write('// Define the class include file definitions used here. I.e. those needed\n')
    ofp.write('// for the target spec. Each one defines its predecessor, as including\n')
    ofp.write('// headers for later derived classes causes a compile error---even when\n')
    ofp.write('// using forward references (needs a completed class reference).\n\n')

    for flag, ext, define, incl in extensions :
      padStr = '                  '
      if len(incl) < 15 :
        padStr += ' ' * (15 - len(incl))
      if ext != 'rv32i_cpu' :
        if flag.get() != 0 :
          ofp.write('#define ' + incl + padStr + '"' + lastExt + '.h"\n')
          lastExt = ext
        else :
          if ext == 'rv32d_cpu' :
            ofp.write('#define ' + incl + padStr + '"' + 'rv32f_cpu' + '.h" /* Excluded, so defaulted to rv32f so will compile */\n')
          else :
            ofp.write('#define ' + incl + padStr + '"' + 'rv32i_cpu' + '.h" /* Excluded, so defaulted to base so will compile */\n')

    ofp.write('\n')
    ofp.write('// Define the extension spec for the target model. Chose the\n')
    ofp.write('// highest order class that\'s needed.\n')
    ofp.write('#define RV32_TARGET_INHERITANCE_CLASS    ' + lastExt + '\n')
    ofp.write('\n')
    ofp.write('// Define target include: must match include of RV32_TARGET_INHERITANCE_CLASS\n')
    ofp.write('#define RV32_TARGET_INCLUDE             "' + lastExt + '.h"\n')

    # ofp.write #endif
    ofp.write('\n')
    ofp.write('#endif\n')

    #ofp.close

    showinfo('Generate', 'Completed generation of ' + self.opfile.get())


  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Widget generators
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  # _rv32CreateWidgets()
  #
  # Create the application GUI
  #
  # noinspection PyBroadException
  def __rv32CreateWidgets (self, top) :

    # Determine whether on windows or not, as this will make some differences
    if os.name == 'nt' :
      isWindows = True
    else :
      isWindows = False

    nextrow = 0

    sep = Separator(top, orient=HORIZONTAL)
    sep.grid(row = nextrow, sticky=W+E, pady = 0)

    nextrow += 1

    frm        = Frame(master = top)
    frm.grid(row = nextrow, padx = 10, pady = 10)

    # Create a panel with the icon image. Image file expected to be in same location
    # as the script.
    imgerr = False
    img = ''
    try :
      img = PhotoImage(file = self.scriptdir.get() + '/' +'icon.png')
    except :
      imgerr = True

    if not imgerr :
      panel = Label(master = frm, image = img)
    else :
      # If the above threw an exception, just have an empty panel
      panel = Label(master = frm, width = 15)

    self.__rv32CreateSubWidgets(master = frm, panel = panel, isLnx = False)

    # Start of Tk event loop
    mainloop()

  # _rv32CreateSubWidgets()
  #
  # Create the application GUI's sub-widgets. Return a list of widget handles
  # that are not valid for fast mode.
  #
  # noinspection PyBroadException
  def __rv32CreateSubWidgets (self, master, panel, isLnx) :

    framerow    = 0
    totalcols   = 3

    # Add check buttons in a frame, as column 0. Each tuple is (<label>, <Tk variable>, <onvalue>).
    # Two dimensional array is tupleList[rows][cols]
    flagsframe = LabelFrame(master = master, text = 'Extensions:', padding = 20)
    tupleList = [
      [('I', self.extI, 1), ('M', self.extM, 1), ('A', self.extA, 1), ('F', self.extF, 1), ('D', self.extD, 1)],
      [('Zifencei', self.extZifencei, 1), ('Zcsr', self.extZcr, 1), ('G', self.extG, 1), ('E', self.extE, 1), ('C', self.extC, 1)]
    ]
    self.chkHdls = self.__addCheckButtonRows('', tupleList, flagsframe, 12)

    self.chkHdls[0].config(state = DISABLED)
    self.chkHdls[5].config(state = DISABLED)
    #self.chkHdls[6].config(state = DISABLED)

    flagsframe.grid(row = framerow, padx = 10, pady = 10, sticky = W)

    panel.grid(row = framerow, column = 2, pady = 10, padx = 5)

    framerow += 1
    flagsframe = LabelFrame(master = master, text = 'Privilege Levels:', padding = 21)
    tupleList = [
      [('machine', self.machine, 1), ('supervisor', self.supervisor, 1), ('user', self.user, 1)]
    ]

    hdls = self.__addCheckButtonRows('', tupleList, flagsframe, 21)

    hdls[0].config(state = DISABLED)
    hdls[1].config(state = DISABLED)
    hdls[2].config(state = DISABLED)

    flagsframe.grid(row = framerow, padx = 10, pady = 10, sticky = W)

    flagsframe = LabelFrame(master = master, text = 'Architecture:', padding = 21)
    tupleList = [
      [('RV32', self.arch, '0'), ('RV64', self.arch, '1')]
    ]

    hdls = self.__addRadioButtonRows('', tupleList, flagsframe)

    hdls[0].config(state = DISABLED)
    hdls[1].config(state = DISABLED)

    flagsframe.grid(row = framerow, column = 1, columnspan = 2, padx = 10, pady = 10, sticky = W+E)


    # Add utility files selection in a new frame. Each tuple is
    # (<label>, <Tk variable>, <width>, <button label>, <callback>).
    # Two dimensional array is tupleList[rows][cols]
    fileframe = LabelFrame(master = master, text='Files:', padding = 5)
    tupleList = [[('Output file',     self.opfile,    50, 'Browse', self.__rv32GetOutputFile)]
                ]

    hdls = self.__addFileEntryRows('', tupleList, fileframe)

    # Add utility file widgets frame in a new row, spanning all three columns
    framerow +=1
    fileframe.grid(row = framerow, columnspan = totalcols, padx = 10, pady = 10, sticky = W+E)

    goButton = Button(master = master, text='Generate', command=self.__rv32Generate)
    framerow += 1
    goButton.grid (row = framerow, columnspan = 3)


  # _rv32SetIcon()
  #
  # Set the icon for the given widget (windows only)
  #
  def __rv32SetIcon(self, widget) :

    if os.name == 'nt' :
      widget.iconbitmap(os.path.join(self.scriptdir.get(), 'favicon.ico'))

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # 'Public' methods
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  # run()
  #
  # Top level method to create application window, and generate output
  #
  def run(self):

    # Create the application GUI
    self.__rv32CreateWidgets(self.root)


# ###############################################################
# Only run if not imported
#
if __name__ == '__main__' :

  gui = rv32gui()
  gui.run()

