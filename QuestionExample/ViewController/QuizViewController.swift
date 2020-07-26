//
//  ViewController.swift
//  QuestionExample
//
//  Created by Raidu on 7/22/20.
//  Copyright © 2020 Raidu. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionsTblView: UITableView!
    
    var questionsVM = QuestionsViewModel()
    var results = [Results]()
    var optionsArr = [String]()
    var nextBtnClicked = false
    var selectedAnswer = ""
    var counter = 0
    var points  = 10
    
    
    var stopWatchCounter = 0.0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTblView.isHidden = true
        questionsVM.getRowsInfoFromService { [weak self](mainJson) in
            
            if let resultsData = mainJson.results {
                self?.results = resultsData
                DispatchQueue.main.async {
                    self?.questionsTblView.isHidden = false
                    self?.questionsTblView.reloadData()
                    self?.startTimer()
                }
            }
        }
        questionsTblView.register(UINib(nibName: "ChoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "choice")
        questionsTblView.sectionHeaderHeight =  UITableView.automaticDimension
        questionsTblView.estimatedSectionHeaderHeight = 100;
        
        
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
    }
    @objc func UpdateTimer() {
        stopWatchCounter = stopWatchCounter + 1
    }
    /// since we are getting incorrect answers and correct answers separately , combining both to show as options and shuffling the options array
    func formOptionsArray() {
        for option in results[counter].incorrect_answers! {
            optionsArr.append(option)
        }
        optionsArr.append(results[counter].correct_answer!)
        optionsArr = optionsArr.shuffled()
    }
    
    func displayAlertWithTime() {
        let alert = UIAlertController(title: "Result", message: "Marks Obtained : \(points) \n Time : \(calculateTime())", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func calculateTime() -> String {
        let hours = Int(stopWatchCounter) / 3600
        let minutes = Int(stopWatchCounter) / 60 % 60
        let seconds = Int(stopWatchCounter) % 60
        return String(format:"%02i:%02i.%02i", hours, minutes, seconds)
    }
    @IBAction func nextBtnClicked(_ sender : UIButton) {
        // if answer is not selected not allowing to go to next question
        if selectedAnswer == "" {
            return
        }
        nextBtn.isEnabled = false
        nextBtnClicked = true
        questionsTblView.reloadData()
        /// if counter is reached to the no of questions returned by the api then it will end the exam and goes to root view
        if results.count - 1 == counter {
            timer.invalidate()
            displayAlertWithTime()
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.optionsArr  = [String]()
            self.counter += 1
            self.nextBtnClicked = false
            self.nextBtn.isEnabled = true
            self.selectedAnswer = ""
            self.questionsTblView.reloadData()
        }
    }
    
    
}
/// TableView Data soruce and delegate methods
extension QuizViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count > 0 && counter < results.count{
            if !nextBtnClicked {
                formOptionsArray()
            }
            return optionsArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "choice", for: indexPath) as! ChoiceTableViewCell
        cell.backgroundColor = .clear
        cell.choiceLbl.text = optionsArr[indexPath.row].htmlDecoded
        
        if nextBtnClicked && selectedAnswer != "" {
            if results[counter].correct_answer! == optionsArr[indexPath.row] {
                cell.backgroundColor = .green
            }
            else if selectedAnswer == optionsArr[indexPath.row] && results[counter].correct_answer! != optionsArr[indexPath.row] {
                points -= 1
                cell.backgroundColor = .red
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choice") as! ChoiceTableViewCell
        if results.count > 0 {
            cell.choiceLbl.font = .boldSystemFont(ofSize: 20)
            cell.choiceLbl.text = results[counter].question!.htmlDecoded
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswer = ""
        selectedAnswer.append(optionsArr[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = .clear
    }
}
extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
