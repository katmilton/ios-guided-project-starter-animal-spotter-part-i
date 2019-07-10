//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    
    var bearer: Bearer? // = nil
    
    // create function for sign up
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signupURL = baseUrl.appendingPathComponent("users").appendingPathComponent("signup")
        
        var request = URLRequest(url: signupURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // The body of the request is JSON.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let error = NSError(domain: "com.LambdaSchool.AnimalSpotter", code: response.statusCode, userInfo: ["Error \(response.statusCode)" : "\(String(describing: error))"])
                completion(error)
                return
            }
            
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }
            
            // Was there an error or not?
            completion(nil)
            
        }.resume()
        
        
    }
    
    // create function for sign in
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signinURL = baseUrl.appendingPathComponent("users").appendingPathComponent("login")
        
        var request = URLRequest(url: signinURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // The body of the request is JSON.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userData = try JSONEncoder().encode(user)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let error = NSError(domain: "com.LambdaSchool.AnimalSpotter", code: response.statusCode, userInfo: ["Error \(response.statusCode)" : "\(String(describing: error))"])
                completion(error)
                return
            }
            
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from sign up.")
                completion(NSError())
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer token: \(error)")
                completion(error)
                return
            }
            
            // Was there an error or not?
            completion(nil)
            
            }.resume()
        
        
    }
    
    
    // create function for fetching all animal names
    
    // create function to fetch image
}
