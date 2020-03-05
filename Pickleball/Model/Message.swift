//
//  Message.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/15/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Message: NSObject {
    
    var fromId: String?
    var message: String?
    var timeStamp: Double?
    var toId: String?
    var id: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}