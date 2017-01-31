//
//  ViewController.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit


class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let array = ["General", "Business", "Science-and-nature", "Sport", "Technology", "Music", "Gaming", "Entertainment"]
    var section : [String : [LNSourceTemporary]] {
        return LNSection.sharedInstance.section
    }
    var cellDescriptors: [[[String: AnyObject]]] = []
    var visibleRowsPerSection = [[Int]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        loadCellDescriptors()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellDescriptors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If number of self.section < visibleRow from plist. Only for safe!
        switch section {
        case 0:
            if self.section["general"]!.count + 1 < visibleRowsPerSection[section].count {
                return self.section["general"]!.count + 1
            }
        case 1:
            if self.section["business"]!.count + 1  < visibleRowsPerSection[section].count {
                return self.section["business"]!.count + 1
            }
        case 2:
            if self.section["science-and-nature"]!.count + 1 < visibleRowsPerSection[section].count {
                print("Small")
                return self.section["science-and-nature"]!.count + 1
            }
        case 3:
            if self.section["sport"]!.count + 1  < visibleRowsPerSection[section].count {
                return self.section["sport"]!.count + 1
            }
        case 4:
            if self.section["technology"]!.count + 1  < visibleRowsPerSection[section].count {
                return self.section["technology"]!.count + 1
            }
        case 5:
            if self.section["music"]!.count + 1  < visibleRowsPerSection[section].count {
                return self.section["music"]!.count + 1
            }
        case 6:
            if self.section["gaming"]!.count + 1  < visibleRowsPerSection[section].count {
                return self.section["gaming"]!.count + 1
            }
        case 7:
            if self.section["entertainment"]!.count + 1  < visibleRowsPerSection[section].count {
                return self.section["entertainment"]!.count + 1
            }
        default:
            return visibleRowsPerSection[section].count
        }
        return visibleRowsPerSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor["cellIdentifier"] as! String, for: indexPath) as! CustomCell
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
            return cell.setupNormalCell(array[indexPath.section], indexPath: indexPath)
        }
            
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker" {
            return cell.setupValuePickerCell(array[indexPath.section], section: section, indexPath: indexPath)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] = shouldExpandAndShowSubRows as AnyObject?
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow]["additionalRows"] as! Int)) {
                cellDescriptors[indexPath.section][i]["isVisible"] = shouldExpandAndShowSubRows as AnyObject?
                
            }
            
            
        }
        if indexOfTappedRow != 0 {
            self.performSegue(withIdentifier: "PresentRandomViewController", sender: self)
        }
        
        getIndicesOfVisibleRows()
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentRandomViewController" {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let navigationController = segue.destination as! UINavigationController
                let destVC = navigationController.viewControllers[0] as! PresentNewsViewController
                switch selectedIndexPath.section {
                case 0:
                    var array = section["general"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 1:
                    var array = section["business"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 2:
                    var array = section["science-and-nature"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 3:
                    var array = section["sport"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 4:
                    var array = section["technology"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 5:
                    var array = section["music"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 6:
                    var array = section["gaming"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                case 7:
                    var array = section["entertainment"]!
                    destVC.source = array[selectedIndexPath.row - 1].id
                default:
                    return
                }
            }
            
        }
    }
    
    
    //Helper methods :
    
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
    }
    
    
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist") {
            cellDescriptors = NSArray(contentsOfFile: path) as! [[[String : AnyObject]]]
            getIndicesOfVisibleRows()
        }
    }
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells ).count - 1) {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }
        print(visibleRowsPerSection)
        
        
    }
    
    func getCellDescriptorForIndexPath(_ indexPath: IndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = self.cellDescriptors[indexPath.section][indexOfVisibleRow]
        return cellDescriptor
        
    }
    
}

