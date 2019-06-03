//
//  ViewController.swift
//  SSInfiniteExpandableTableView
//
//  Created by Suraj on 6/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayTree:[Parent] = []
    var ssTreeInstance: SSTreeTableView = SSTreeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let filepath: String? = Bundle.main.path(forResource: "Tree", ofType: "json")
        let url = URL(fileURLWithPath: filepath ?? "")
        
        var jsonData: Data?
        do {
            jsonData = try Data(contentsOf: url)
        }catch{
            print("error")
        }
        
        var jsonDictionary: NSDictionary?
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: .init(rawValue: 0)) as? NSDictionary
        }catch{
            print("error")
        }
        
        var arrayParents: NSArray?
        if let treeDictionary = jsonDictionary?.object(forKey: "Tree") as? NSDictionary {
            if let arrayOfParents = treeDictionary.object(forKey: "Parents") as? NSArray {
                arrayParents = arrayOfParents
            }
        }
        
        if let arrayOfParents = arrayParents {
            ssTreeInstance = SSTreeTableView(parents: arrayOfParents, childrenKey: "Children", expandableKey: "Expanded", key: "Id")
        }
        ssTreeInstance.isInitiallyExpanded = true
        ssTreeInstance.animation = .fade
        
        
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let total = ssTreeInstance.tableView(tableView, numberOfRowsInSection: section)
        return total
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let node = ssTreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        
        if indexTuples.count == 1  || indexTuples.count == 4 {
            
            // Parents
            let cellIdentifierParents = "ParentsTableViewCellIdentity"
            var cellParents: ParentsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? ParentsTableViewCell
            if cellParents == nil {
                tableView.register(UINib(nibName: "ParentsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierParents)
                cellParents = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? ParentsTableViewCell
            }
            cellParents?.cellFillUp(indexParam: node.index, tupleCount: indexTuples.count)
            cellParents?.selectionStyle = .none
            
            if node.state == .open {
                cellParents?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cellParents?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cellParents?.buttonState.setImage(nil, for: .normal)
            }
            
            return cellParents!
            
        }else if indexTuples.count == 2 {
            
            // Parents
            let cellIdentifierChilds = "Childs2ndStageTableViewCellIdentity"
            var cellChild: Childs2ndStageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs2ndStageTableViewCell
            if cellChild == nil {
                tableView.register(UINib(nibName: "Childs2ndStageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs2ndStageTableViewCell
            }
            cellChild?.cellFillUp(indexParam: node.index)
            cellChild?.selectionStyle = .none
            
            if node.state == .open {
                cellChild?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cellChild?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cellChild?.buttonState.setImage(nil, for: .normal)
            }
            
            return cellChild!
            
        } else if indexTuples.count == 3 {
            
            // Parents
            let cellIdentifierChilds = "Childs3rdStageTableViewCellIdentity"
            var cellChild: Childs3rdStageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs3rdStageTableViewCell
            if cellChild == nil {
                tableView.register(UINib(nibName: "Childs3rdStageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs3rdStageTableViewCell
            }
            cellChild?.cellFillUp(indexParam: node.index)
            cellChild?.selectionStyle = .none
            
            if node.state == .open {
                cellChild?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
            }else if node.state == .close {
                cellChild?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
            }else{
                cellChild?.buttonState.setImage(nil, for: .normal)
            }
            
            return cellChild!
            
        }else{
            // Childs
            // grab cell
            var tableviewcell = tableView.dequeueReusableCell(withIdentifier: "cellidentity")
            if tableviewcell == nil {
                tableviewcell = UITableViewCell(style: .default, reuseIdentifier: "cellidentity")
            }
            tableviewcell?.textLabel?.text = node.index
            tableviewcell?.backgroundColor = UIColor.yellow
            tableviewcell?.selectionStyle = .none
            return tableviewcell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = ssTreeInstance.tableView(tableView, didSelectRowAt: indexPath)
        print(node.index)
        print(node.key)
        // if you've added any identifier or used indexing format
        print(node.givenIndex)
    }
}

