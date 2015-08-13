/*
* Copyright (C) 2015 47 Degrees, LLC http://47deg.com hello@47deg.com
*
* Licensed under the Apache License, Version 2.0 (the "License"); you may
* not use this file except in compliance with the License. You may obtain
* a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

protocol Row {
    /**
    Returns the title of this row.
    */
    func title() -> String
    
    /**
    Returns a tuple containing the function that configures the cell corresponding to this row, and its cell identifier.
    */
    func configurationFunctionAndIdentifier(owner: MainViewController) -> (((UITableViewCell, NSIndexPath) -> UITableViewCell), String)

    /**
    Returns the height of this row.
    */
    func rowHeight() -> CGFloat
    
    /**
    Returns the current value corresponding to this row.
    
    :param: owner The owner of the data model for the table view.
    
    :returns: current value for this row if any.
    */
    func currentValue(owner: MainViewController) -> Any?
    
    /**
    Assigns a new value to the model corresponding to this row. Usually called after an user interaction with its cell.
    
    :param: owner The owner of the data model for the table view.
    :param: value The new value, if any.
    */
    func assignValue(owner: MainViewController, value: Any?)
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Enums representing our table data and organization
    /// Section | An enum representing the set of tableView sections.
    enum Section : Int {
        case Dough = 0
        case Ingredients = 1
        
        /**
        Returns an array containing all our enum cases, useful to access their count.
        */
        static let allValues = [Section.Dough, Section.Ingredients]
        
        /**
        Returns the title of this section.
        */
        func title() -> String? {
            switch self {
            case .Dough: return NSLocalizedString("section_title_dough", comment: "")
            case .Ingredients: return NSLocalizedString("section_title_ingredients", comment: "")
            }
        }
        
        /**
        Returns the corresponding enum case for an specific row inside in this section.
        */
        func caseForRow(row: Int) -> Row? {
            switch self {
            case .Dough: return SectionDoughRows(rawValue: row)
            case .Ingredients: return SectionIngredientsRows(rawValue: row)
            }
        }
        
        /**
        Returns the height of the header area of this section.
        */
        func headerHeight() -> CGFloat {
            return CGFloat(kTableCellHeightRegular)
        }
        
        /**
        Returns the header view of this section.
        */
        func headerView(tableView: UITableView) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(kTableHeaderIdentifier) as! TableHeaderView
            if let sectionName = self.title() {
                header.lblTitle.text = sectionName
            }
            return header
        }
    }
    
    /// SectionDoughRows | An enum representing the set of rows of the section depicting a pizza's dough.
    enum SectionDoughRows : Int, Row {
        case Thickness = 0
        case CheeseBorder = 1
        
        static let allValues = [SectionDoughRows.Thickness, SectionDoughRows.CheeseBorder]
        
        func title() -> String {
            switch self {
            case .Thickness: return NSLocalizedString("row_dough_thickness_title", comment: "")
            case .CheeseBorder: return NSLocalizedString("row_dough_cheese_border_title", comment: "")
            }
        }
        
        func configurationFunctionAndIdentifier(owner: MainViewController) -> (((UITableViewCell, NSIndexPath) -> UITableViewCell), String) {
            switch self {
            case .Thickness: return (owner.configureSliderCell, kTableCellIdentifierSlider)
            case .CheeseBorder: return (owner.configureSwitchCell, kTableCellIdentifierSwitch)
            }
        }
        
        func rowHeight() -> CGFloat {
            return CGFloat(kTableCellHeightRegular)
        }
        
        func currentValue(owner: MainViewController) -> Any? {
            switch self {
            case .Thickness: return owner.doughThickness
            case .CheeseBorder: return owner.shouldHaveCheeseBorder
            }
        }
        
        func assignValue(owner: MainViewController, value: Any?) {
            switch self {
            case .Thickness:
                if let thickness = value as? Float {
                    owner.doughThickness = DoughThickness.thicknessFromSliderValue(thickness)
                }
            case .CheeseBorder:
                if let shouldHaveCheeseBorder = value as? Bool {
                    owner.shouldHaveCheeseBorder = shouldHaveCheeseBorder
                }
            }
        }
    }
    
    enum SectionIngredientsRows : Int, Row {
        case Sauce = 0
        case Olives = 1
        case Beef = 2
        case Bacon = 3
        case Anchovies = 4
        
        static let allValues = [SectionIngredientsRows.Sauce, SectionIngredientsRows.Olives, SectionIngredientsRows.Beef, SectionIngredientsRows.Bacon, SectionIngredientsRows.Anchovies]
        
        func title() -> String {
            switch self {
            case .Sauce: return NSLocalizedString("row_ingredients_sauce_title", comment: "")
            case .Olives: return NSLocalizedString("row_ingredients_olives_title", comment: "")
            case .Beef: return NSLocalizedString("row_ingredients_beef_title", comment: "")
            case .Bacon: return NSLocalizedString("row_ingredients_bacon_title", comment: "")
            case .Anchovies: return NSLocalizedString("row_ingredients_anchovies_title", comment: "")
            }
        }
        
        func configurationFunctionAndIdentifier(owner: MainViewController) -> (((UITableViewCell, NSIndexPath) -> UITableViewCell), String) {
            switch self {
            case .Sauce: return (owner.configurePickerCell, kTableCellIdentifierPicker)
            case .Olives, .Beef, .Bacon, .Anchovies: return (owner.configureSwitchCell, kTableCellIdentifierSwitch)
            }
        }
        
        func rowHeight() -> CGFloat {
            switch self {
            case .Sauce: return CGFloat(kTableCellHeightPicker)
            case .Olives, .Beef, .Bacon, .Anchovies: return CGFloat(kTableCellHeightRegular)
            }
        }
        
        func currentValue(owner: MainViewController) -> Any? {
            switch self {
            case .Sauce: return owner.sauceType
            case .Olives: return owner.shouldHaveOlives
            case .Beef: return owner.shouldHaveBeef
            case .Bacon: return owner.shouldHaveBacon
            case .Anchovies: return owner.shouldHaveAnchovies
            }
        }
        
        func assignValue(owner: MainViewController, value: Any?) {
            switch self {
            case .Sauce:
                if let sauceType = value as? MainViewController.Sauce {
                    owner.sauceType = sauceType
                }
            case .Olives:
                if let shouldHaveOlives = value as? Bool {
                    owner.shouldHaveOlives = shouldHaveOlives
                }
            case .Beef:
                if let shouldHaveBeef = value as? Bool {
                    owner.shouldHaveBeef = shouldHaveBeef
                }
            case .Bacon:
                if let shouldHaveBacon = value as? Bool {
                    owner.shouldHaveBacon = shouldHaveBacon
                }
            case .Anchovies:
                if let shouldHaveAnchovies = value as? Bool {
                    owner.shouldHaveAnchovies = shouldHaveAnchovies
                }
            }
        }
    }
    
    // MARK: - Enums representing other data
    enum DoughThickness {
        case Thin
        case Regular
        case Thick
        
        static func thicknessFromSliderValue(value: Float) -> DoughThickness {
            switch value {
            case _ where value <= kThicknessValueForThin: return DoughThickness.Thin
            case _ where value > kThicknessValueForThin && value <= kThicknessValueForRegular: return DoughThickness.Regular
            case _ where value > kThicknessValueForRegular && value <= kThicknessValueForThick: return DoughThickness.Thick
            default: return DoughThickness.Thick
            }
        }
        
        func title() -> String {
            switch self {
            case .Thin: return NSLocalizedString("slider_thickness_thin", comment: "")
            case .Regular: return NSLocalizedString("slider_thickness_regular", comment: "")
            case .Thick: return NSLocalizedString("slider_thickness_thick", comment: "")
            }
        }
        
        func floatValue() -> Float {
            switch self {
            case .Thin: return kThicknessValueForThin
            case .Regular: return kThicknessValueForRegular
            case .Thick: return kThicknessValueForThick
            }
        }
    }
    
    enum Sauce {
        case Tomato
        case BBQ
        case Spicy
        case Carbonara
        
        static func allValues() -> [Sauce] {
            return [Sauce.Tomato, Sauce.BBQ, Sauce.Spicy, Sauce.Carbonara]
        }
        
        func title() -> String {
            switch self {
            case .Tomato: return NSLocalizedString("picker_sauce_tomato_title", comment: "")
            case .BBQ: return NSLocalizedString("picker_sauce_bbq_title", comment: "")
            case .Spicy: return NSLocalizedString("picker_sauce_spicy_title", comment: "")
            case .Carbonara: return NSLocalizedString("picker_sauce_carbonara_title", comment: "")
            }
        }
    }
    
    // MARK: - View Controller's properties and life cycle
    
    @IBOutlet weak var tblMain: UITableView!
    var doughThickness : DoughThickness = DoughThickness.Thin
    var shouldHaveCheeseBorder : Bool = false
    var sauceType : Sauce = Sauce.Tomato
    var shouldHaveOlives : Bool = false
    var shouldHaveBeef : Bool = false
    var shouldHaveBacon : Bool = true
    var shouldHaveAnchovies : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblMain.registerNib(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: kTableCellIdentifierPicker)
        tblMain.registerNib(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: kTableCellIdentifierSlider)
        tblMain.registerNib(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: kTableCellIdentifierSwitch)
        tblMain.registerNib(UINib(nibName: "TableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kTableHeaderIdentifier)
    }
    
    // MARK: - UITableView delegate, datasource and config methods
    // MARK: UITableViewDataSource protocol methods

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.allValues.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCase = Section.allValues[section]
        switch sectionCase {
        case .Dough: return SectionDoughRows.allValues.count
        case .Ingredients: return SectionIngredientsRows.allValues.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionCase = Section.allValues[indexPath.section]
        if let rowCase = sectionCase.caseForRow(indexPath.row) {
                let (configFunction, identifier) = rowCase.configurationFunctionAndIdentifier(self)
                return configureCellForIdentifier(tableView, cellIdentifier: identifier, indexPath: indexPath, configurationFunction: configFunction)
        }
        return UITableViewCell(style: .Default, reuseIdentifier: nil)        
    }
    
    // MARK: Cell configuration functions
    
    func configureCellForIdentifier(tableView: UITableView, cellIdentifier: String, indexPath: NSIndexPath, configurationFunction: (UITableViewCell, NSIndexPath) -> UITableViewCell) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        return configurationFunction(cell, indexPath)
    }
    
    func configurePickerCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let pickerCell = cell as? PickerTableViewCell {
            pickerCell.pickerView.delegate = self
            pickerCell.pickerView.indexPath = indexPath
            if let index = find(Sauce.allValues(), sauceType) {
                pickerCell.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            return pickerCell
        }
        return cell
    }
    
    func configureSliderCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionCase = Section.allValues[indexPath.section]
        if let sliderCell = cell as? SliderTableViewCell,
            let rowCase = sectionCase.caseForRow(indexPath.row) {
                sliderCell.slider.addTarget(self, action: "didChangeSliderValue:", forControlEvents: .ValueChanged)
                sliderCell.lblTitle.text = rowCase.title()
                sliderCell.slider.indexPath = indexPath
                
                if let value = rowCase.currentValue(self) as? DoughThickness {
                    sliderCell.lblValue.text = "\(value.title())"
                    sliderCell.slider.value = value.floatValue()
                }
            return sliderCell
        }
        return cell
    }
    
    func configureSwitchCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionCase = Section.allValues[indexPath.section]
        if let switchCell = cell as? SwitchTableViewCell,
            let rowCase = sectionCase.caseForRow(indexPath.row) {
            switchCell.switchBtn.addTarget(self, action: "didPressSwitch:", forControlEvents: UIControlEvents.TouchUpInside)
            switchCell.lblTitle.text = rowCase.title()
            switchCell.switchBtn.indexPath = indexPath
            if let value = rowCase.currentValue(self) as? Bool {
                switchCell.switchBtn.on = value
            }
            return switchCell
        }
        return cell
    }
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let sectionCase = Section(rawValue: indexPath.section),
            let rowCase = sectionCase.caseForRow(indexPath.row) {
                return rowCase.rowHeight()
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(kTableCellHeightRegular)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Section(rawValue: section)?.headerView(tableView)
    }
    
    // MARK: - Value assign generalization
    
    func assignValueForRowAtIndexPath(someIndexPath: NSIndexPath?, value: Any?) {
        if let indexPath = someIndexPath,
            let sectionCase = Section(rawValue: indexPath.section),
            let rowCase = sectionCase.caseForRow(indexPath.row) {
                rowCase.assignValue(self, value: value)
                tblMain.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource protocols methods
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Sauce.allValues().count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return kComponentsInSaucePickerView
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = .Center
        
        let attributes = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 18.0)!]
        let title = Sauce.allValues()[row].title()
        pickerLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sauceType = Sauce.allValues()[row]
        assignValueForRowAtIndexPath(pickerView.indexPath, value: sauceType)
    }
    
    // MARK: - Slider actions
    
    func didChangeSliderValue(slider: UISlider) {
        assignValueForRowAtIndexPath(slider.indexPath, value: slider.value)
    }
    
    func didPressSwitch(switchBtn: UISwitch) {
        assignValueForRowAtIndexPath(switchBtn.indexPath, value: switchBtn.on)
    }
    
    // MARK: - Button logic
    
    @IBAction func didPressOrderButton(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: self.orderString(), preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
            // Do stuff with the order
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func orderString() -> String {
        let borderCheese = shouldHaveCheeseBorder ? NSLocalizedString("order_border_cheese", comment: "") : NSLocalizedString("order_border_no_cheese", comment: "")
        
        let listOfIngredientsSettings = reduce([(NSLocalizedString("row_ingredients_olives_title", comment: ""), shouldHaveOlives),
            (NSLocalizedString("row_ingredients_beef_title", comment: ""), shouldHaveBeef),
            (NSLocalizedString("row_ingredients_bacon_title", comment: ""), shouldHaveBacon),
            (NSLocalizedString("row_ingredients_anchovies_title", comment: ""), shouldHaveAnchovies)], ""){ (list : String, ingredientSetting: (String, Bool)) -> String in
            if ingredientSetting.1 {
                if list != "" {
                    return "\(list), \(ingredientSetting.0.lowercaseString)"
                } else {
                    return ingredientSetting.0.lowercaseString
                }
            }
            return list
        }
        
        let ingredientsPrefix = NSLocalizedString("order_ingredients_prefix", comment: "")
        let ingredients = listOfIngredientsSettings != "" ? "\(ingredientsPrefix)\(listOfIngredientsSettings)" : NSLocalizedString("order_no_ingredients", comment: "")
        return "Are you sure you want a \(doughThickness.title().lowercaseString) \(borderCheese) pizza with \(sauceType.title()) sauce and \(ingredients)?"
    }
}
