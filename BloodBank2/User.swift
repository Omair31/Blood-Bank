//
//  User.swift
//  BloodBank2
//
//  Created by Omeir on 16/05/2017.
//  Copyright © 2017 Omeir. All rights reserved.
//

import Foundation
import UIKit

class User {
    let userName:String
    let userContact:String
    let bloodGroup:String
    var RHValue:String
    let userType:userType
    // Implementing Singleton :P
    static var sharedInstance:User!
    enum userType : String{
        case Donor,Recipient,Both
    }
    
    init(userName:String,userContact:String,bloodGroup:String,RHValue:String,userType:userType) {
        self.userName = userName
        self.userContact = userContact
        self.bloodGroup = bloodGroup
        self.RHValue = RHValue
        self.userType = userType
    }
    
}
