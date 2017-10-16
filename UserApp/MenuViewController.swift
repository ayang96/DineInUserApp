//
//  MenuViewController.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//
import UIKit
import Firebase
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tag: Int?
    @objc var indicator: UIActivityIndicatorView?
    var restaurantObj: Restaurant?
    var groupObj: Group?
    var orderCreated = false
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMenu()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        self.title = "Menu"
        navigationController?.navigationBar.isHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    @objc func updateMenu() {
        getMenu(mid: (restaurantObj?.mid)!) { (disharray) in
            if(disharray != nil){
                dishes = disharray!
                self.menuTableView.reloadData()
            }
            
        }
    }
    
    
    @objc func updateData() {
        // YOUR CODE HERE
        checkIfCreatedGroup(completion: { (answer) in
            print(answer)
            if(answer){
                self.viewOrEatHere.title = "View Order"
                getMyGroup(){ (returnedgroup) in
                    self.groupObj = returnedgroup
                    self.orderCreated = true
                }
            } else {
                 self.viewOrEatHere.title = "Eat Here"
                self.orderCreated = false
                
            }
        })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let dish = dishes[indexPath.item]
        cell.DishName.text = dish.dishName
        cell.dishinfo = dish
        cell.dishLabel.text = dish.dishDescription
        cell.dishPrice.text = "$\(dish.price!)"
        return cell
    }
    //Row should not be selectable
    var selectedDish:Dish?
    var selectedIndex:Int?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Auth.auth().currentUser != nil) {
            selectedDish = dishes[indexPath.item]
            selectedIndex = indexPath.item
            performSegue(withIdentifier: "MenuToDishInfo", sender: self)
        }
        //addOrder(dishname: dishes[indexPath.item].dishName!, oid: "o1")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBOutlet weak var viewOrEatHere: UIBarButtonItem!
    //really view order button
    @IBAction func EatHereButtonPressed(_ sender: Any) {
        
        if(viewOrEatHere.title == "Eat Here") {
            if(Auth.auth().currentUser != nil) {
                let titlestring = (Auth.auth().currentUser?.displayName)! + "'s Group"
                createGroup(groupName: titlestring, restObj: restaurantObj!) {
                    (group) in
                    self.groupObj = group
                    
                }
            }
        } else {
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"update"), object: nil)
        performSegue(withIdentifier: "MenuToPopover", sender: self)
            
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuToPopover" {
            if let destinationVC = segue.destination as? OrderSessionController {
                destinationVC.groupObj = groupObj
            }
            
        }
        if segue.identifier == "MenuToDishInfo" {
            if let destinationVC = segue.destination as? DishInfoViewController {
                destinationVC.dishObj = selectedDish
                destinationVC.restaurantObj = restaurantObj
                destinationVC.orderCreated = orderCreated
                destinationVC.selectedIndex = selectedIndex
            }
        }
    }
    
}
