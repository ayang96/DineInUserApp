//
//  SelectFoodPopoverController.swift
//  UserApp
//
//  Created by Alex Yang on 8/11/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit
import Firebase
class SelectFoodPopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tag: Int?
    @objc var indicator: UIActivityIndicatorView?
    var groupObj: Group?
    @IBOutlet weak var PopupView: UIView!
    
    @IBAction func DismissPopup(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        self.title = "Menu"
        navigationController?.navigationBar.isHidden = false
        PopupView.layer.cornerRadius = 10
        PopupView.layer.masksToBounds = true
        
    }
    
    
    @objc func updateData() {
        getMenu(mid: groupObj!.mid) { (disharray) in
            dishes = disharray!
            self.menuTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    //Decides how each row will look like
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMenuCell") as! SelectMenuCell
        cell.DishName.text = dishes[indexPath.item].dishName
        cell.dishinfo = dishes[indexPath.item]
        return cell
    }
    //Row should not be selectable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appendOrderToGroupList(index: indexPath.item, group: groupObj!)
        dismiss(animated:true, completion: nil)
        //addOrder(dishname: dishes[indexPath.item].dishName!, oid: "o1")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
