//
//  RootViewController.swift
//  QuestionExample
//
//  Created by Raidu on 7/23/20.
//  Copyright © 2020 Raidu. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
      let quizVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "quizVC") as! QuizViewController
      self.navigationController?.pushViewController(quizVC, animated: true)
    }
    
}
