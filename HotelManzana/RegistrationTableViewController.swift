//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Joseph on 10/04/2020.
//  Copyright © 2020 Joseph Doogan. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    var registrations: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedRegistrations = Registration.loadFromFile() {
            registrations = savedRegistrations
        } else {
            registrations = Registration.loadSampleRegistrations()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)

        let registration = registrations[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        cell.textLabel?.text = "\(registration.firstName) \(registration.lastName)"
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: registration.checkInDate)) - \(dateFormatter.string(from: registration.checkOutDate))   \(registration.roomType.name)"
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registrations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            // Save Registrations after deletion
            Registration.saveToFile(registrations: registrations)
        }
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? UINavigationController,
            let addRegistrationViewController = destinationViewController.topViewController as? AddRegistrationTableViewController,
            segue.identifier == "EditRegistration" else {return}
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let registration = registrations[selectedIndexPath.row]
            addRegistrationViewController.existingRegistration = registration
            
        }
    }
    
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
        
        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
            let registration = addRegistrationTableViewController.registration else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            registrations[selectedIndexPath.row] = registration
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: registrations.count, section: 0)
            registrations.append(registration)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        // Save Registrations
        Registration.saveToFile(registrations: registrations)
    }

}
