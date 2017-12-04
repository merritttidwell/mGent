//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

struct StripeAPIData {
    static let myServer = "http://localhost:3000"
    static let publishableKey = "pk_test_5MG4Sw3JfAGO39ujgbCYkqyD"
}

class StripeAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let sharedClient = StripeAPIClient()
    var baseURLString: String? = StripeAPIData.myServer
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    var cusID = ""
    private(set) var ephemeralKey = [String: AnyObject]();
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, headers: [
            "api_version": apiVersion,
            "customerID": cusID
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    self.ephemeralKey = json as! [String : AnyObject]
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    func createStripeCustomer(email: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("create_customer")
        Alamofire.request(url, method: .post, headers: [
            "email": email
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        description: String,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        
        let url = self.baseURL.appendingPathComponent("charge")
        let params: [String: String] = [
            "card": result.source.stripeID,
            "cus": cusID,
            "amount": "\(amount)",
            "desc": description
        ]
        
        //params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod) as AnyObject
        Alamofire.request(url, method: .post, headers: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                //print(response)
                
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
}
