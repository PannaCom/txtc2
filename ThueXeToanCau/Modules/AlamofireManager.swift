//
//  AlamofireManager.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 1/3/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireManager: NSObject {
    static let sharedInstance = AlamofireManager()

    let manager: SessionManager = {

        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: ServerTrustPolicy.certificates(in: Bundle.main), validateCertificateChain: true, validateHost: true)

        return SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: ["thuexetoancau.vn" : serverTrustPolicy]))

    }()

}
