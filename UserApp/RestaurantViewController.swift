//
//  RestaurantViewController.swift
//  UserApp
//
//  Created by Alex Yang on 5/31/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tag: Int?
    @objc var indicator: UIActivityIndicatorView?
    var colormaker = ColorCreator()
    var restaurantObj: Restaurant?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Restaurants"
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor =  colormaker.UIColorFromHex(hex: 0xEB5757)
        updateData()
    }
    @IBOutlet weak var ProfileButton: UIBarButtonItem!

    
    @objc func updateData() {
        // YOUR CODE HERE
        getRestaurant() { (restarray) in
            restaurants = restarray!
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    //Decides how each row will look like
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        cell.RestaurantName.text = restaurants[indexPath.item].name
        cell.restinfo = restaurants[indexPath.item]
        cell.restrauntType.text = restaurants[indexPath.item].type
        cell.restrauntHours.text = restaurants[indexPath.item].hours
        cell.restrauntRating.text = restaurants[indexPath.item].rating
        
        //cell.blurImageView.

        return cell
    }
    @IBAction func AccountButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ButtonToAccountPage", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         restaurantObj = restaurants[indexPath.item]
         performSegue(withIdentifier: "RestaurantToMenu", sender: self)
         tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantToMenu" {
            if let menuViewController = segue.destination as? MenuViewController {
                menuViewController.restaurantObj = restaurantObj
            }
        }

    }
    
}
