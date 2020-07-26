//
//  QuestionsViewModel.swift
//  QuestionExample
//
//  Created by Raidu on 7/22/20.
//  Copyright © 2020 Raidu. All rights reserved.

import Foundation
import UIKit

class QuestionsViewModel {
    
    /// Get Questions  API Call
    func getRowsInfoFromService( completion : @escaping(_ response:MainJson)-> Void) {
        
        Network.getApiCallWithRequestURLString(requestString: URLConstants.questionsURL, completionBlock: { (data) in
            do {
                let str = String(decoding: data, as: UTF8.self)
                if let data = str.data(using: .utf8) {
                    let jsonDecoder = JSONDecoder()
                    /// Converting response to our custom model
                    let responseModel = try jsonDecoder.decode(MainJson.self, from: data)
                    completion(responseModel)
                }
            }
            catch(let error) {
                ShowAlert.showAlert("Alert", "\(error.localizedDescription)")
            }
        }) { (error) in
            ShowAlert.showAlert("Alert", "\(error.localizedDescription)")
        }
    }
   
}
