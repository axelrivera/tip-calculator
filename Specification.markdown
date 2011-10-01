Rivera Labs Tip Calculator
==========================

### Functional Specification ###

App Name: Rivera Labs Tip Calculator  
Version: 1.0 Alpha  
Author: Axel Rivera  
Created: September 28, 2011  
Last Updated: September 29, 2011

Overview
========

Rivera Labs Tip Calculator is a generic tip calculator for consumers.  It's main purpose is to introduce people to the Rivera Labs brand.  It will also serve as a white label tip calculator for companies interested in their own branded tip calculator.  We will include options to add custom branding throughout the app without sacrificing user experience.

Non Goals
=========

This version will not support the following features:

* Custom Graphics
* Custom UI Controls

Screen By Screen Specification
==============================

Main Screen
-----------

The main screen will include a **Page Control** element that will handle two pages *Tip Summary Page* and *Split Adjustments Page*.  If the *shake to clear* option is enabled in the settings the user can shake the device to reset all the values.  An appropriate animation for this action would be to swipe the current view to the right and swipe an empty *Tip Summary Page* from the left.

All animations in the *Main Screen* will be backed up by audio feedback, unless the sound switch in the *Settings Screen* is Off.

### Check Summary Page ###

The *Check Summary Page* will take care of tip information input and summary.  It will include a table with two sections: (1) Input, (2) Display.  At the bottom right corner of the screen there will be an *Info* button that will display the **Settings Screen**, using a flip animation.

#### Input Section

1.	Number of Splits  
	Will Display list of options with split numbers ranging from *None* to *Fifty*.
	
2.	Tip Percentage  
	Will display list of percentage options ranging from *No Tip* to *Fifty Percent*.  
	The selection picker should include the total tip for that percentage to provide feedback.
	
3.	Check Amount  
	Will display a Number Pad to enter the total amount directly into the table cell.

#### Display Section

1.	Total Tip Cell  
	Displays the total tip.
	
2.	Total to Pay Cell  
	Displays the total to pay.

3.	Total Per Person Cell  
	Displays the total per person, if available.

#### Text Strings

*	Section 1, Row 1 Label: _Split Check_
*	Section 1, Row 2 Label: _Tip Percentage_
*	Section 1, Row 3 Label: _Bill Total_
*	Section 2, Row 1 Label: _Total Tip_
*   Section 2, Row 2 Label: _Total To Pay_
*	Section 2, Row 3 Label: _Total Per Person_
*	Split Picker Suffix: _people_

### Split Adjustments Page ###

The *Split Adjustments Page* will allow the user to modify the total amount that each person will pay when the check is split.  It will include a table with a single section of custom cells.  The footer of the section will display the bill total for feedback.  At the bottom right corner of the screen there will be an *Info* button that will display the **Settings Screen**, using a flip animation.

#### Custom Cell Description

1.	The top part of the cell will include a label describing the total and tip amount per person.

2.	The bottom part of the cell with include a slider to increase or reduce the amount each person has to pay.
	It will also include *two* buttons at the beginning and end of the slider to allow for better precision when
	modifying the information.  The developer needs to validate the total after the total for each person is modified.

#### Text Strings

*	Custom Cell Label: _Check # $x.xx $x.xx + $x.xx tip_
*	Section Footer: _Total $x.xx_

Settings Screen
---------------

The *Settings Screen* will display all the settings available in the Tip Calculator and it will be accessible from the *Check Summary Page* and the *Split Adjustments Page*.

The content will include a table with two sections.  The first section will include basic cells for selecting currency, rounding, and tax rate.  The second section will include two switch options to:

1.	_Sound_
2.	_Shake to Clear_  (If this option is enabled the user can shake the device to clear the current check)

### Navigation Options

Right Item: _Done_ button to quit the screen and return to the *Main Screen*.

### Important Delegate Methods

This screen should implement delegate methods for:

*	*Selected Currency Screen*
*	*Select Rounding Screen*
*	*Select Tax Options*

### Text strings

*	Navigation Title: _Rivera Labs Tip Calculator_
*	Navigation Right Item: _Done_
*	Currency Label: _Currency_
*	Rounding Label: _Rounding_
*	Tax Label: _Tax_
*	Sound Label: _Sound_
*	Shake Label: _Shake to Clear_

Select Currency Screen
----------------------

The *Select Currency Screen* is accessible from the *Settings Screen* and it displays all the currencies supported by the App.  The screen will rely on an enumerated type with the following options Auto, Dollar, Pound, Euro, and Franc.

The screen will rely on a table with a single checkmark to determine the selected option.  It will pass the selected value to the *Settings Screen* trough a delegate.

There should also be helper functions to create the Data Source for the Table and display matching strings to the values in the enumerated currency values.

### Text Strings

*	Navigation Title: _Default Currency_
*	Row 1 Label: _Auto_
*	Row 2 Label: _Dollar ($)_
*	Row 3 Label: _Pound (£)_
*	Row 4 Label: _Euro (€)_
*	Row 5 Label: _Franc(Fr)_

>	Note: The currency string helper method should have an option to include/remove the currency symbol when displaying
>	the string.

Select Rounding Screen
----------------------

The *Select Rounding Screen* is accessible from the *Settings Screen* and it displays all the rounding options supported by the App.  The screen will rely on an enumerated type with the following options Exact, Round Tip Up, Round Tip Down, Round Total Up, and Round Total Down.

The screen will rely on a table with a single checkmark to determine the selected option.  It will pass the selected value to the *Settings Screen* trough a delegate*.

There should also be helper functions to create the Data Source for the Table and display matching strings to the values in the enumerated rounding values.

### Text Strings

*	Navigation Title: _Rounding Options_
*	Row 1 Label: _Exact_
*	Row 2 Label: _Round Tip Up_
*	Row 3 Label: _Round Tip Down_
*	Row 4 Label: _Round Total Up_
*	Row 5 Label: _Round Total Down_

Select Tax Screen
-----------------

The *Select Tax Screen* is accessible from the *Settings Screen* and it displays the available tax settings.  It includes a table with two sections.  The second section will be available depending on the selection from the first section.

#### Section 1

Includes a options to include tip on tax with possible values being Yes or No.  I the selection is No then the second section is appears with an animation from top to bottom.

#### Section 2

Includes a cell with a text field to include the tax rate that will be used in check calculations.

### Text Strings

*	Navigation Title: _Tax_
*	Section 1 Header: _Tip On Tax?_
*	Section 1, Row 1 Label: _Yes_
*	Section 1, Row 2 Label: _No_
*	Section 2 Row 1 Label: _Tax Rate_
