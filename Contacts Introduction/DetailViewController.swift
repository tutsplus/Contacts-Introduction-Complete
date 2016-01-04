//
//  DetailViewController.swift
//  Contacts Introduction
//
//  Created by Davis Allie on 2/01/2016.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import Contacts

class DetailViewController: UIViewController {

    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var email: UILabel!
    
    var contactItem: CNContact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let oldContact = self.contactItem {
            let store = CNContactStore()
            
            do {
                let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactImageDataKey, CNContactImageDataAvailableKey]
                let contact = try store.unifiedContactWithIdentifier(oldContact.identifier, keysToFetch: keysToFetch)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if contact.imageDataAvailable {
                        if let data = contact.imageData {
                            self.contactImage.image = UIImage(data: data)
                        }
                    }
                    
                    self.fullName.text = CNContactFormatter().stringFromContact(contact)
                    
                    self.email.text = contact.emailAddresses.first?.value as? String
                    
                    if contact.isKeyAvailable(CNContactPostalAddressesKey) {
                        if let postalAddress = contact.postalAddresses.first?.value as? CNPostalAddress {
                            self.address.text = CNPostalAddressFormatter().stringFromPostalAddress(postalAddress)
                        } else {
                            self.address.text = "No Address"
                        }
                    }
                })
            } catch {
                print(error)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

