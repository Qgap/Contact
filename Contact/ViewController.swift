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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactsButton = UIButton.init(type: .custom)
        contactsButton.frame = CGRect.init(x: 100, y: 100, width: 100, height: 30)
        contactsButton.setTitle("获取通讯录", for: UIControlState.normal)
        contactsButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        contactsButton.addTarget(self, action: #selector(getContacts), for: UIControlEvents.touchUpInside)
        self.view.addSubview(contactsButton)
        
    }
    
    @objc func getContacts() -> Void {
        
        CNContactStore().requestAccess(for: .contacts) { (isRight, error) in
            if (isRight) {
                print("success")
                self.loadContactsData()
                
                let contactPicker = CNContactPickerViewController.init()
                contactPicker.delegate = self
                self.present(contactPicker, animated: true, completion: nil)
            }
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let lastName = contact.familyName
        let firstName = contact.givenName
        print("\(lastName)\(firstName)")
        
        for phone in contact.phoneNumbers {
            var label = ""
            if phone.label != nil {
                label = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
            }
            
            let value = phone.value.stringValue
            print("\(label) \(value)")
            
            let alert = UIAlertController.init(title: lastName, message: value, preferredStyle: UIAlertControllerStyle.alert)
            self.navigationController?.pushViewController(alert, animated: true)
            
        }
    }
    
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

