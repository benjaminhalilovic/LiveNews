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
    var cellDescriptors: NSMutableArray!
    var visibleRowsPerSection = [[Int]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadCellDescriptors()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(currentCellDescriptor["cellIdentifier"] as! String, forIndexPath: indexPath) as! CustomCell
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
            cell.textNormalCell.text = array[indexPath.section]
            cell.colorView.backgroundColor = UIColor.blueColor()
            switch indexPath.section {
            case 0:
                cell.colorView.backgroundColor = UIColor(red:65/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                return cell
            case 1:
                 cell.colorView.backgroundColor = UIColor(red:255/255.0, green: 198/255.0, blue: 81/255.0, alpha: 1.0)
                return cell
            case 2:
                 cell.colorView.backgroundColor = UIColor(red:255/255.0, green: 221/255.0, blue: 117/255.0, alpha: 1.0)
                return cell
            case 3:
                 cell.colorView.backgroundColor = UIColor(red:31/255.0, green: 225/255.0, blue: 133/255.0, alpha: 1.0)
                return cell
            case 4:
                 cell.colorView.backgroundColor = UIColor(red:236/255.0, green: 135/255.0, blue: 255/255.0, alpha: 1.0)
                return cell
            case 5:
                cell.colorView.backgroundColor = UIColor(red:255/255.0, green: 128/255.0, blue: 127/255.0, alpha: 1.0)
                return cell
            case 6:
                 cell.colorView.backgroundColor = UIColor(red:157/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1.0)
                return cell
            case 7:
                 cell.colorView.backgroundColor = UIColor(red:181/255.0, green: 198/255.0, blue: 225/255.0, alpha: 1.0)
                return cell
            default:
                return cell
            }

            
        }
        
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker" {
            switch indexPath.section {
            case 0:
                var array = self.section["general"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:65/255.0, green: 181/255.0, blue: 255/255.0, alpha: 1.0)
                return cell
            case 1:
                var array = self.section["business"]!
                cell.textExpandCell.text  = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:255/255.0, green: 198/255.0, blue: 81/255.0, alpha: 1.0)
                return cell
            case 2:
                var array = self.section["science-and-nature"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:255/255.0, green: 221/255.0, blue: 117/255.0, alpha: 1.0)
                return cell
            case 3:
                var array = self.section["sport"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:31/255.0, green: 225/255.0, blue: 133/255.0, alpha: 1.0)
                return cell
            case 4:
                var array = self.section["technology"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:236/255.0, green: 135/255.0, blue: 255/255.0, alpha: 1.0)
                return cell
            case 5:
                var array = self.section["music"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:255/255.0, green: 128/255.0, blue: 127/255.0, alpha: 1.0)
                return cell
            case 6:
                var array = self.section["gaming"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:157/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1.0)
                return cell
            case 7:
                var array = self.section["entertainment"]!
                cell.textExpandCell.text = array[indexPath.row - 1].name
                cell.colorExpandView.backgroundColor = UIColor(red:181/255.0, green: 198/255.0, blue: 225/255.0, alpha: 1.0)
                return cell
            default:
                return cell
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            cellDescriptors[indexPath.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow]["additionalRows"] as! Int)) {
                cellDescriptors[indexPath.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        if indexOfTappedRow != 0 {
            self.performSegueWithIdentifier("showSourceNews", sender: self)
        }
        getIndicesOfVisibleRows()
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    //Helper methods : 
    
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.registerNib(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
    }

    
    func loadCellDescriptors() {
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
        }
    }
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1) {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }
        print(visibleRowsPerSection)
    }
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = cellDescriptors[indexPath.section][indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
    }

}

