//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by akshay on 03/01/19.
//  Copyright © 2019 akshay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet Property
    @IBOutlet weak var tblExpandable: UITableView!
    
    //MARK: - variables
    var visibleRowsPerSection = [[Int]]()
    var cellDescriptors: NSMutableArray!
    
    //MARK: - tableview data source
    override func viewWillAppear(_ animated: Bool) {
        loadCellDescriptors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: (currentCellDescriptor["cellIdentifier"] as? String ?? ""), for: indexPath)
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
            if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                cell.textLabel?.text = primaryTitle as? String
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellTextfield" {
            (cell as? CustomCell)?.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSwitch" {
            (cell as? CustomCell)?.lblSwitchLabel.text = currentCellDescriptor["primaryTitle"] as? String
            
            let value = currentCellDescriptor["value"] as? String
            (cell as? CustomCell)?.swMaritalStatus.isOn = (value == "true") ? true : false
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker" {
            (cell as? CustomCell)?.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSlider" {
            let value = currentCellDescriptor["value"] as! String
            (cell as? CustomCell)?.slExperienceLevel.value = (value as NSString).floatValue
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        
        if (self.cellDescriptors[indexPath.section] as! [[String: Any]])[indexOfTappedRow]["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if (self.cellDescriptors[indexPath.section] as! [[String: Any]])[indexOfTappedRow]["isExpanded"] as! Bool == false {
                shouldExpandAndShowSubRows = true
            }
            
            
            (((self.cellDescriptors.object(at: indexPath.section) as! NSMutableArray) [indexOfTappedRow]) as! NSDictionary).setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
//            (indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow]["additionalRows"] as! Int)) {

            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + ((self.cellDescriptors[indexPath.section] as! [[String: Any]])[indexOfTappedRow]["isExpandable"] as! Int))
            {
                (((self.cellDescriptors.object(at: indexPath.section) as! NSMutableArray) [i]) as! NSDictionary).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        
        getIndicesOfVisibleRows()
        tblExpandable.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .fade)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String {
        case "idCellNormal":
            return 60.0
            
        case "idCellDatePicker":
            return 270.0
            
        default:
            return 44.0
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Personal"
            
        case 1:
            return "Preferences"
            
        default:
            return "Work Experience"
        }
    }
    

    
    
    //MARK: - logic function
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist"){
            cellDescriptors = NSMutableArray.init(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tblExpandable.reloadData()
        }
    }
    
    func getCellDescriptorForIndexPath(indexPath: IndexPath) -> [String: Any] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = (self.cellDescriptors[indexPath.section] as! [[String: Any]])[indexOfVisibleRow]
        return cellDescriptor
    }
    
    func configureTableView(){
        self.tblExpandable.delegate = self
        self.tblExpandable.dataSource = self
        
        self.tblExpandable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        tblExpandable.register(UINib.init(nibName: "NormalCell", bundle: Bundle.main) , forCellReuseIdentifier: "idCellNormal")
        tblExpandable.register(UINib.init(nibName: "TextfieldCell", bundle: Bundle.main), forCellReuseIdentifier: "idCellTextfield")
        tblExpandable.register(UINib.init(nibName: "DatePickerCell", bundle: Bundle.main), forCellReuseIdentifier: "idCellDatePicker")
        tblExpandable.register(UINib.init(nibName: "SwitchCell", bundle: Bundle.main), forCellReuseIdentifier: "idCellSwitch")
        tblExpandable.register(UINib.init(nibName: "ValuePickerCell", bundle: Bundle.main), forCellReuseIdentifier: "idCellValuePicker")
        tblExpandable.register(UINib.init(nibName: "SliderCell", bundle: Bundle.main), forCellReuseIdentifier: "idCellSlider")
        
    }
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...(((currentSectionCells as? [[String: Any]])?.count ?? 0) - 1)
            {
                if ((currentSectionCells as! [[String: Any]])[row]["isVisible"] as? Bool ?? false)
                {
                    visibleRows.append(row)
                }
            }//inner loop
            visibleRowsPerSection.append(visibleRows)
        }//outer loop
    }
    
}

