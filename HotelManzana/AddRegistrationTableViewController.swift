//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Joseph on 04/04/2020.
//  Copyright © 2020 Joseph Doogan. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var roomTypeChargeLabel: UILabel!
    @IBOutlet weak var wifiChargeLabel: UILabel!
    @IBOutlet weak var totalChargesLabel: UILabel!
    
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var roomType: RoomType?
    
    let wifiPricePerDay = 10
    
    var registration: Registration? {
        guard let roomType = roomType,
        let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        let email = emailTextField.text else { return nil }
        
        //let firstName = firstNameTextField.text ?? ""
        //let lastName = lastNameTextField.text ?? ""
        //let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomType: roomType, wifi: hasWifi)
    }
    
    // Have a variable in case this is an Edit
    var existingRegistration: Registration?
    
    // constant variables to refer to the index path of date label cells
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    // constant variables to refer to index path of date picker cells
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    // variables to track whether the date pickers are shown or hidden
    var isCheckInDatePickerShown: Bool = false {    // default value is false
        didSet {
            // the date picker's hidden state will be the opposite of this variable e.g. if 'shown' is false, 'hidden' is true, and if 'shown' is true, 'hidden' is false
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {    // default value is false
        didSet {
            // the date picker's hidden state will be the opposite of this variable e.g. if 'shown' is false, 'hidden' is true, and if 'shown' is true, 'hidden' is false
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if pre-existing registration exists i.e. this is an edit
        if let existingRegistration = existingRegistration {
            populateViews(with: existingRegistration)
        } else {
            
            // Create Date instance representing start of today
            let midnightToday = Calendar.current.startOfDay(for: Date())
            
            // Use start of today as the minimum date for check-in date picker
            checkInDatePicker.minimumDate = midnightToday
            
            // Update check-in date picker to use minimum date i.e. today
            checkInDatePicker.date = midnightToday
        }
        // Call updateViews() to update the check-out date picker minimum date and update the date labels
        updateViews()
        
        // Call updateNumberOfGuests() to update the number of Adult and Children labels
        updateNumberOfGuests()
        
        // Call updateRoomType() to update which RoomType has been selected
        updateRoomType()
        
        // Call enableOrDisableDoneButton() to enable Done button if all fields have a value
        enableOrDisableDoneButton()
        
        // Call to updateCharges() to update the charges labels and total
        updateCharges()
        
    }
    
    func enableOrDisableDoneButton() {
        // Only proceed to possibly enable the Done button if registration is not nil, else disable the Done button and return
        guard let registration = registration else {
            doneBarButton.isEnabled = false
            return
        }
        
        // enable the Done button by default as all fields have a value
        doneBarButton.isEnabled = true
        
        // finally, if there is an existingRegistration, disable the Done button if there have been no changes to the information
        if let existingRegistration = existingRegistration {
            doneBarButton.isEnabled = (existingRegistration == registration) ? false : true
        }
    }
    
    func populateViews(with registration: Registration) {
        firstNameTextField.text = registration.firstName
        lastNameTextField.text = registration.lastName
        emailTextField.text = registration.emailAddress
        checkInDatePicker.date = registration.checkInDate
        checkOutDatePicker.date = registration.checkOutDate
        numberOfAdultsStepper.value = Double(registration.numberOfAdults)
        numberOfChildrenStepper.value = Double(registration.numberOfChildren)
        wifiSwitch.setOn(registration.wifi, animated: false)
        roomType = registration.roomType
    }
    
    func updateViews() {
        // Update check-out date picker to have minimum date of 24 hours after check-in date picker date value
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        
        // Create DateFormatter instance
        let dateFormatter = DateFormatter()
        // Set dateStyle property to .medium (e.g. "Nov 23, 1937")
        dateFormatter.dateStyle = .medium
        
        // Update Check-In date label using Check-In Date Picker value
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
    
        // Update Check-Out date label using Check-Out Date Picker value
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    func updateCharges() {
        
        var total = 0
        
        // Update number of nights (an extension has been created to allow easy subtraction of dates in 'DateHelpers.swift')
        let interval = checkOutDatePicker.date - checkInDatePicker.date
        let numberOfNights = interval.day!
        numberOfNightsLabel.text = "\(numberOfNights)"
        
        // Update room type and charge of room type for number of nights
        if let roomType = roomType {
            let costOfRoom = roomType.price * numberOfNights
            roomTypeChargeLabel.text = "\(roomType.shortName)       $\(costOfRoom)"
            total += costOfRoom
        } else {
            roomTypeChargeLabel.text = "Not Set"
        }
        
        // Update wi-fi is yes or no and cost for number of nights
        if wifiSwitch.isOn {
            let costOfWifi = wifiPricePerDay * numberOfNights
            wifiChargeLabel.text = "Yes       $\(costOfWifi)"
            total += costOfWifi
        } else {
            wifiChargeLabel.text = "No"
        }
        
        // Update Total charges
        totalChargesLabel.text = "$\(total)"
    }
    
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateCharges()
        enableOrDisableDoneButton()
    }
    
    @IBAction func textValueChanged(_ sender: UITextField) {
        enableOrDisableDoneButton()
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateViews()
        updateCharges()
        enableOrDisableDoneButton()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
        enableOrDisableDoneButton()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateCharges()
        enableOrDisableDoneButton()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK:- Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Check the current indexPath
        switch indexPath {
            
        // Does the current indexPath match the check-in date picker cell?
        case checkInDatePickerCellIndexPath:
            // If yes, should the check-in date picker currently be shown?
            if isCheckInDatePickerShown {
                // If yes, return a height of 216 (the height required to display the date picker correctly)
                return 216.0
            } else {
                // Otherwise return a height of 0, effectively collapsing the cell and hiding from view
                return 0.0
            }
            
        // Does the current indexPath match the check-out date picker cell?
        case checkOutDatePickerCellIndexPath:
            // If yes, should the check-out date picker currently be shown?
            if isCheckOutDatePickerShown {
                // If yes, return a height of 216 (the height required to display the date picker correctly)
                return 216.0
            } else {
                // Otherwise return a height of 0, effectively collapsing the cell and hiding from view
                return 0.0
            }
        
        // The indexPath does not match either of the date picker cells
        default:
            // Return the default cell height of 44.0
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the tapped cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Check the current index path
        switch indexPath {
            
        // Does the current indexPath match the check-in date label cell?
        case checkInDateLabelCellIndexPath:
            
            // If yes, is the check-in date picker already showing?
            if isCheckInDatePickerShown {
                // If yes, hide the check-in date picker
                isCheckInDatePickerShown = false
                
            // Otherwise, is the check-out date picker already showing?
            } else if isCheckOutDatePickerShown {
                // If yes, hide the check-out date picker and show the check-in date picker
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
                
            } else {
                // Otherwise, both date pickers are currently hidden, therefore show the check-in date picker
                isCheckInDatePickerShown = true
            }
            
            // Have the table re-query its attributes, including height
            tableView.beginUpdates()
            tableView.endUpdates()
            
        // Does the current indexPath match the check-out date label cell?
        case checkOutDateLabelCellIndexPath:
            
            // If yes, is the check-out date picker already showing?
            if isCheckOutDatePickerShown {
                // If yes, hide the check-out date picker
                isCheckOutDatePickerShown = false
                
            // Otherwise, is the check-in date picker already showing?
            } else if isCheckInDatePickerShown {
                // If yes, hide the check-in date picker and show the check-out date picker
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
                
            } else {
                // Otherwise, both date pickers are currently hidden, therefore show the check-out date picker
                isCheckOutDatePickerShown = true
            }
            
            // Have the table re-query its attributes, including height
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check to see if the segue we are about to perform is the one we gave the identifier "SelectRoomType"
        if segue.identifier == "SelectRoomType" {
            // Attempt to downcast the destination view controller as a SelectRoomTypeViewController
            let destinationViewController = segue.destination as? SelectRoomTypeTableViewController
            // If the destination was successfully downcast, set the delegate for the destination to be this controller
            destinationViewController?.delegate = self
            // If the destination was successfully downcast, set the roomType property on the destination to have the value of roomType in this controller
            destinationViewController?.roomType = roomType
        }
    }
    
}
