//
//  LoadPinViewController.swift
//  Reen
//
//  Created by Jimoh Babatunde Olalekan on 27/12/2020.
//  Copyright © 2020 Jimoh Babatunde Olalekan. All rights reserved.
//

import UIKit
import ContactsUI

class LoadPinViewController: GenericViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {
    
    @IBOutlet weak var dropView: UIView?
    @IBOutlet weak var horizontalStackView: UIStackView?
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint?
    @IBOutlet weak var networkTableView: UITableView?
    @IBOutlet weak var sendToMeLbl: UILabel?
    @IBOutlet weak var pinLbl: UILabel?
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint?
    @IBOutlet weak var dropArrowImage: UIImageView?
    @IBOutlet weak var backArrow: UIImageView?
    @IBOutlet weak var networkTextField: UITextField?
    @IBOutlet weak var loadForFriendView: UIView?
    @IBOutlet weak var sendToMeView: UIView?
    
    var isClicked: Bool = false
    var cell:UITableViewCell =  UITableViewCell(style: .default, reuseIdentifier: "networkCell")
    let networkNames = ["MTN", "Airtel", "Glo", "9Mobile"]
    var pinNumber: String = ""
    var friendPhoneNumber: String = ""
    var price: String = ""
    var ussdCode: String = ""
    var ussdCodeForFriend: String = ""
    var networkName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(state: .withBackText)
        
        let tapDropView = UITapGestureRecognizer(target: self, action: #selector(self.dropDownAction))
        self.dropView?.addGestureRecognizer(tapDropView)
        
        let tapBackArrow = UITapGestureRecognizer(target: self, action: #selector(self.popViewController))
        self.backArrow?.addGestureRecognizer(tapBackArrow)
        
        self.tableViewHeight?.constant = 0;
        self.networkTableView?.delegate = self
        self.networkTableView?.dataSource = self
        
        self.networkTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "networkCell")
        self.dropView?.layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(formatTextFromCropping) , name: Notification.Name.DidGetTextFromCropping, object: nil)
        
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight < 600 {
            self.scrollViewTop?.constant = 0
        }
        self.networkTextField?.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.displayDropDownAlertWithTitle(title: "Pin Loading ...", message: "", error: false)
    }
    
    @objc func formatTextFromCropping(notification: Notification) {
        let sender = notification.object
        //We only want messages from the cart manager
        guard ((sender as? HomeViewControllerViewController) != nil) else {
            return
        }
        
        guard let userInfo = notification.userInfo else {return}
        let pinInfo = userInfo["pin"] as? String
        guard let pin = pinInfo else {return}
        self.validatePin(pin: pin)
    }
    
    func validatePin(pin: String) {
        if pin.count == 17 || pin.count == 18 || pin.count == 19
            || pin.count == 20 || pin.count == 21 {
            if pin.contains(" ") {
                self.pinNumber = pin.replacingOccurrences(of: " ", with: "")
                self.pinLbl?.text = ""
                self.pinLbl?.text =  "Pin: \(self.pinNumber)"

            }
            else if pin.contains("-") {
                 self.pinNumber = pin.replacingOccurrences(of: " ", with: "")
                 self.pinLbl?.text = ""
                 self.pinLbl?.text =  "Pin: \(self.pinNumber)"
            }
            else {
                self.displayDropDownAlertWithTitle(title: "Fail to get pin", message: "Please make sure you only crop the pin", error: true)
            }
        }
        else {
            self.displayDropDownAlertWithTitle(title: "Fail to get pin", message: "Please make sure you only crop the pin", error: true)
        }
    }
    
    @objc func dropDownAction() {
        if self.pinNumber != "" {
            if self.isClicked == false {
                self.tableViewHeight?.constant = 90;
                self.dropArrowImage?.image = UIImage(named: "icon_chevron_up")
                self.isClicked = true
            }
            else {
                self.isClicked = false
                self.tableViewHeight?.constant = 0;
                self.dropArrowImage?.image = UIImage(named: "icon_chevron_down")
            }
        }
        
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "networkCell", for: indexPath)
        cell.textLabel?.text = self.networkNames[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-medium", size: CGFloat(14))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.networkName = self.networkNames[indexPath.row]
        self.networkTextField?.text = self.networkName
        switch networkName {
        case "MTN":
            self.ussdCode = "*555*"
            self.ussdCodeForFriend = "*777*"
            self.sendToMeLbl?.text = "\(self.ussdCode)\(self.pinNumber)"
        case "9Mobile":
            self.ussdCode = "*222*"
            self.ussdCodeForFriend = "*222*"
            self.sendToMeLbl?.text = "\(self.ussdCode)\(self.pinNumber)"
        case "Glo":
            self.ussdCode = "*123*"
            self.ussdCodeForFriend = ""
            self.sendToMeLbl?.text = "\(self.ussdCode)\(self.pinNumber)"
        case "Airtel":
            self.ussdCode = "*126*"
            self.ussdCodeForFriend = ""
            self.sendToMeLbl?.text = "\(self.ussdCode)\(self.pinNumber)"
        default:
            print("default guy")
        }
        self.isClicked = false
        self.tableViewHeight?.constant = 0
    }
    
    func showFriendsOnContact() {
//        let contactViewController = CNContactPickerViewController()
//        contactViewController.hidesBottomBarWhenPushed = true
//        contactViewController.allowsEditing = false
//        contactViewController.allowsActions = false
//        // 3
//        navigationController?.navigationBar.tintColor = .appBlue
//        navigationController?.pushViewController(contactViewController, animated: true)
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        // 2
//        contactPicker.predicateForEnablingContact = NSPredicate(
//          format: "emailAddresses.@count > 0")
        present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumbers = contact.phoneNumbers
        let phoneNumber = phoneNumbers[0].value.stringValue
        
        if phoneNumber.count > 0 {
            if phoneNumber.isValidNumericValueOnly() == true {
                self.friendPhoneNumber = phoneNumber
            }
        }
        print("the number is \(phoneNumber)")
        self.dismiss(animated: true, completion: nil)
        self.isLoadForFriendSupported()
        
    }
    
    func isLoadForFriendSupported() {
        if self.ussdCodeForFriend != "" {
            if self.networkName == "MTN"{
                self.showAlertForAirtimePrice()
            }
            else if self.networkName == "9Mobile" {
                self.dialPinForFriend()
            }
        }
        else {
            self.displayDropDownAlertWithTitle(title: "", message: "Network doesn't support this", error: true)
        }
    }
    
    func showAlertForAirtimePrice() {
        let alertController = UIAlertController(title: "Please enter price", message: "", preferredStyle: UIAlertController.Style.alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter price here"
        }
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let priceText = firstTextField.text else {return}
            self.validatePrice(price: priceText)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:nil)
        
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validatePrice(price: String) {
        if price.isValidNumericValueOnly() == true {
            self.price = price
            print("the \(self.ussdCodeForFriend) \(self.friendPhoneNumber) \(self.pinNumber)")
            self.dialPinForFriend()
        }
        else {
            self.displayDropDownAlertWithTitle(title: "", message: "Please enter a valid amount", error: true)
        }
    }
    
    func validatePhoneNumber(phoneNumber: String) {
        if phoneNumber.isValidNumericValueOnly() == true && phoneNumber.count == 11 {
            self.friendPhoneNumber = phoneNumber
            //self.showAlertForAirtimePrice()
            self.isLoadForFriendSupported()
        }
        else {
            self.displayDropDownAlertWithTitle(title: "", message: "Please enter a valid phone number", error: true)
        }
    }
    
    
    
    func dialPinForFriend() {
        if self.friendPhoneNumber != "" && self.price != "" {
            var fullCode = ""
            if self.networkName == "MTN" {
                fullCode = "\(self.ussdCodeForFriend)\(self.friendPhoneNumber)*\(self.price)*\(self.pinNumber)#"
            }
            else if self.networkName == "9Mobile" {
                fullCode = "\(self.ussdCodeForFriend)\(self.pinNumber)*\(self.friendPhoneNumber)#"
            }
            
            let url: NSURL = URL(string: "TEL://\(fullCode)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }
        
    }
    
    @IBAction func rechargeMe(_ sender: UIButton) {
        if self.pinNumber != "" && self.networkName != "" {
            let fullCode = "\(self.ussdCode)\(self.pinNumber)#"
            let url: NSURL = URL(string: "TEL://\(fullCode)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        else {
            self.displayDropDownAlertWithTitle(title: "", message: "Please select a network", error: true)
        }
    }
    
    
    @IBAction func sendToMyFriend(_ sender: UIButton) {
        if self.pinNumber != "" && self.networkName != "" {
            if self.ussdCodeForFriend != "" {
                let alertController = UIAlertController(title: "Friend Phone Number", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Enter phone number"
                }
                
                let okAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { alert -> Void in
                    let firstTextField = alertController.textFields![0] as UITextField
                    guard let phoneText = firstTextField.text else {return}
                    self.validatePhoneNumber(phoneNumber: phoneText)
                })
                let pickFromContactAction = UIAlertAction(title: "Pick from contact", style: UIAlertAction.Style.default, handler: {
                    (action : UIAlertAction!) -> Void in
                    self.showFriendsOnContact()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
                
                
                alertController.addAction(okAction)
                alertController.addAction(pickFromContactAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                self.displayDropDownAlertWithTitle(title: "", message: "\(self.networkName) does not have support for this", error: true)
            }
            
        }
        else {
            self.displayDropDownAlertWithTitle(title: "", message: "Please select a network", error: true)
        }
    }
    
}
