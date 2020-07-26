//
//  NetworkManager.swift
//  QuestionExample
//
//  Created by Raidu on 7/22/20.
//  Copyright © 2020 Raidu. All rights reserved.
//

import Foundation
import UIKit
enum Errors: Error {
    case invalidURL
    case invalidResponse(error:String)
    case invalidData
}

// A global container for URL
struct URLConstants {
    static let questionsURL = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple"
}

class Network {
    
  static func getApiCallWithRequestURLString(requestString:String,completionBlock:@escaping((_ response:Data) -> Void), failureBlock:@escaping((_ error: Errors)->Void)) {
       
           guard let url = URL(string: requestString) else {
            failureBlock(.invalidURL)
               return;
           }
       
           let dataTask = URLSession.shared.dataTask(with: url) { (responseData, httpResponse, error) in
               if ( error == nil ) {
                   if ( responseData == nil || responseData?.count == 0 ) {
                    failureBlock(.invalidData)
                   }else {
                       completionBlock(responseData!)
                   }
               }else {
                failureBlock(.invalidResponse(error: error?.localizedDescription ?? ""))
               }
           }
           dataTask.resume();
       }
}

struct ShowAlert {
    static func showAlert(_ title : String ,_ message : String) {
        DispatchQueue.main.async {
            guard let vc  = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
