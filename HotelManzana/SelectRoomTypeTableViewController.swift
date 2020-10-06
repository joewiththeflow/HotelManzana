//
//  SelectRoomTypeTableViewController.swift
//  HotelManzana
//
//  Created by Joseph on 09/04/2020.
//  Copyright © 2020 Joseph Doogan. All rights reserved.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate:class {
    // A function that allows us to pass in a RoomType instance which can then be implemented by the implementing instance
    func didSelect(roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    
    // A reference must be held to the instance which actually implements the protocol above
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
    var roomType: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        
        let roomType = RoomType.all[indexPath.row]
        
        cell.textLabel?.text = roomType.name
        cell.detailTextLabel?.text = "£ \(roomType.price)"
        
        // Compare the roomType associated with the row to the roomType stored in the controller variable (i.e. the selected roomType)
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK:- Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row to remove grey highlight
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Set the roomType variable to hold the user's selection
        roomType = RoomType.all[indexPath.row]
        
        // Call the delegate method so that we can pass the selected roomType back
        delegate?.didSelect(roomType: roomType!)
        
        // Reload the table view to reflect the selection
        tableView.reloadData()
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
