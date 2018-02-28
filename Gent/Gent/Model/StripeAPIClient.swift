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
import SwiftyJSON

struct StripeAPIData {
    static let myServer = "https://us-central1-gent-53de7.cloudfunctions.net"   //"http://localhost:3000"
    
#if PROD
    static let publishableKey = "pk_live_c7Jnj340U7R2mZInbLRIEDb0"//"pk_test_5MG4Sw3JfAGO39ujgbCYkqyD"
#else
    static let publishableKey = "pk_test_5MG4Sw3JfAGO39ujgbCYkqyD"
#endif
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
        #if PROD
            let url = self.baseURL.appendingPathComponent("ephemeral_keys_prod")
        #else
            let url = self.baseURL.appendingPathComponent("ephemeral_keys_dev")
        #endif
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

    func createStripeCustomer(email: String, cardSourceID: String? = nil, initCharge: Int, monthCharge: Int, completion: @escaping STPJSONResponseCompletionBlock) {
        var url : URL!
        
        if cardSourceID != nil {
            #if PROD
                url = self.baseURL.appendingPathComponent("create_customer_with_card_prod")
            #else
                url = self.baseURL.appendingPathComponent("create_customer_with_card_dev")
            #endif
        } else {
            #if PROD
                url = self.baseURL.appendingPathComponent("create_customer_prod")
            #else
                url = self.baseURL.appendingPathComponent("create_customer_dev")
            #endif
        }
        var hdrs : [String: String] = ["email": email]
        if cardSourceID != nil {
            hdrs["source"] = cardSourceID
            hdrs["initCharge"] = String(initCharge)
            hdrs["monthCharge"] = String(monthCharge)
        }
        Alamofire.request(url, method: .post, headers: hdrs)
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
                        completion: @escaping STPJSONResponseCompletionBlock) {
        
        #if PROD
            let url = self.baseURL.appendingPathComponent("charge_prod")
        #else
            let url = self.baseURL.appendingPathComponent("charge_dev")
        #endif
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
                    let json = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    completion(json as? [AnyHashable : Any], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func subscribePlan(planID: String = "GentsBasicPlan", completion: @escaping (JSON?)->(Void)) {
        
        let url = self.baseURL.appendingPathComponent("subscribePlan")
        
        let params: [String: String] = [
            "cus": cusID
        ]
        
        Alamofire.request(url, method: .post, headers: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                //print(response)
                
                switch response.result {
                case .success:
                    guard response.data != nil else {
                        completion(nil)
                        return
                    }
                    completion(try? JSON(data: response.data!))
                case .failure:
                    completion(nil)
                }
        }
    }
}
