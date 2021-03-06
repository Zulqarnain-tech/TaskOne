//
//  Constants.swift
//  MultiplayerGame Demo
//
//  Created by Dhaval Trivedi on 18/12/19.
//  Copyright © 2019 Dhaval Trivedi. All rights reserved.
//

import UIKit

class Constants: NSObject {

    static let appdel = UIApplication.shared.delegate as! AppDelegate
    
    struct NETSERVICE {
        static let type = "_servicetype._tcp."
        static let name = "Tic-Tac-Toe"
        static let domain = "local."
        static let host_port: UInt16 = 8080
        static let joinSoc = "Join_soc"
        static let hostSoc = "Host_soc"
        static let acceptedMsg = "Accepted"
        static let socketConnected = "SOCKET CONNECTION TESTED"
    }    
}
