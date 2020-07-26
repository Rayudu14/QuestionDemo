//
//  QuestionExampleTests.swift
//  QuestionExampleTests
//
//  Created by Raidu on 7/26/20.
//  Copyright © 2020 Raidu. All rights reserved.
//

import XCTest
@testable import QuestionExample

class QuestionExampleTests: XCTestCase {

    var urlSession: URLSession!
    override func setUp() {
       
         urlSession = URLSession(configuration: .default)
    }

    override func tearDown() {
       
         urlSession = nil
    }

    func testValidCallToGetsHTTPStatusCode200() {
           let url = URL(string: URLConstants.questionsURL)
           let promise = expectation(description: "Status code: 200")
           let dataTask = urlSession.dataTask(with: url!) { data, response, error in
               if let error = error {
                   XCTFail("Error: \(error.localizedDescription)")
                   return
               } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                   if statusCode == 200 {
                   promise.fulfill()
                       
                   } else {
                       XCTFail("Status code: \(statusCode)")
                   }
               }
           }
           dataTask.resume()
           wait(for: [promise], timeout: 5)
       }
       
       func testCheckForRowsCountNotZeroAndCheckTitle() {
           let promise = expectation(description: "Rows count not equal to zero")
           Network.getApiCallWithRequestURLString(requestString: URLConstants.questionsURL, completionBlock: { (data) in
               do {
                   let str = String(decoding: data, as: UTF8.self)
                   if let data = str.data(using: .utf8) {
                       let jsonDecoder = JSONDecoder()
                       /// Converting response to our custom model
                       let responseModel = try jsonDecoder.decode(MainJson.self, from: data)
                       XCTAssertNotNil(responseModel)
                       promise.fulfill()
                   }
               }
               catch(let error) {
                   XCTFail("Status code: \(error.localizedDescription)")
               }
           }) { (error) in
               XCTFail("Status code: \(error.localizedDescription)")
           }
           wait(for: [promise], timeout: 5)
       }

}
