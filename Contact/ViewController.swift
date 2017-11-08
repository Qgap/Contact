//
//  ViewController.swift
//  Contact
//
//  Created by gap on 2017/11/8.
//  Copyright © 2017年 gap. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController,CNContactPickerDelegate {

    var nameField:UITextField!
    var phoneField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactsButton = UIButton.init(type: .custom)
        contactsButton.frame = CGRect.init(x: 100, y: 100, width: 100, height: 30)
        contactsButton.setTitle("获取通讯录", for: UIControlState.normal)
        contactsButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        contactsButton.addTarget(self, action: #selector(getContacts), for: UIControlEvents.touchUpInside)
        self.view.addSubview(contactsButton)
        
        let viewWidth = self.view.frame.size.width
        
        self.nameField = UITextField.init(frame: CGRect.init(x: 0, y: 150, width: viewWidth, height: 30))
        self.nameField.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.nameField)
        
        self.phoneField = UITextField.init(frame: CGRect.init(x: 0, y: 200, width: viewWidth, height: 30))
        self.phoneField.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.phoneField)
    }

    // MARK: Button action
    
    @objc func getContacts() -> Void {
        
        CNContactStore().requestAccess(for: .contacts) { (isRight, error) in
            if (isRight) {
            
//                self.loadContactsData()
                
                let contactPicker = CNContactPickerViewController.init()
                contactPicker.delegate = self
                self.present(contactPicker, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Delegate
    
    // Singular delegate methods.
    // contact detail
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let detail = contactProperty.contact
        self.contactMessage(contact: detail)
    }
    
    // select
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        self.contactMessage(contact: contact)
//    }
    
    //MARK: Pravite Method
    
    func contactMessage(contact:CNContact) {
        
        let lastName = contact.familyName
        let firstName = contact.givenName
        print("\(lastName)\(firstName)")
        
        var value = ""
        for phone in contact.phoneNumbers {
            var label = ""
            if phone.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
            }
            
            let stringValue = phone.value.stringValue
            value = stringValue.replacingOccurrences(of: "-", with: "")
            value = value.trimmingCharacters(in: .whitespacesAndNewlines)
            print("\(label) \(value)")
        }
        
        self.nameField.text = lastName + firstName
        self.phoneField.text = value
    }
    
    
    // get phone contact
    func loadContactsData() {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        guard status == .authorized else {return}
        
        let store = CNContactStore()
        
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey,
                    CNContactOrganizationNameKey, CNContactJobTitleKey,
                    CNContactDepartmentNameKey, CNContactNoteKey, CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                    CNContactDatesKey, CNContactInstantMessageAddressesKey
        ]
        
        let request = CNContactFetchRequest.init(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact:CNContact, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                let lastName = contact.familyName
                let firstName = contact.givenName
                print("name :\(lastName)\(firstName)")
                
                let nickName = contact.nickname
                print("nickName +\(nickName)")
                
                for phone in contact.phoneNumbers {
                    var label = ""
                    if phone.label != nil {
                        label = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
                    }
                    
                    let value = phone.value.stringValue
                    print("\(label) \(value)")
                }
            })
        } catch  {
            print("error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

