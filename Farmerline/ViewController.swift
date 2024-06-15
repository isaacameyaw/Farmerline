//
//  ViewController.swift
//  Farmerline
//
//  Created by Ikus on 12/06/2024.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper

class ViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startBtn.layer.cornerRadius = 10
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "loadSurvey"), object:nil, queue:nil, using:fetchSurvey)
    }
    
    func performBlock(block: @escaping () -> Void, afterDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
    }
    
    func fetchSurvey (notification: Notification) -> Void {
        if let userInfo = notification.userInfo! as? [String: String] {
            let url = userInfo["url"]!
            self.startBtn.setTitle("Loading survey...", for: .normal)
            self.startBtn.isUserInteractionEnabled = false
            
            performBlock(block: {
                AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        let resJSON = response.value as? [String: Any]
                        //print("resJSON: ", resJSON)
                        var dataArray  = [QuestionObject]()
                        let questionsArray = resJSON!["questions"] as! Array<Any>
                        for i in 0..<questionsArray.count {
                            let theData = questionsArray[i] as! Dictionary<String, AnyObject>
                            let id = theData["id"] as! Int
                            let title = theData["title"] as! String
                            let question_number = theData["question_number"] as! Int
                            let form_type = theData["form_type"] as! String
                            let defaultAnswer = theData["defaultAnswer"] as! String
                            let radioArray = theData["radio_button_option"] as! Array<Any>
                            var radioOptionsArray = [RadioObject]()
                            for j in 0..<radioArray.count {
                                let radioData = radioArray[j] as! Dictionary<String, AnyObject>
                                radioOptionsArray.append(RadioObject(id: radioData["id"] as! Int, name: radioData["name"] as! String))
                            }
                            
                            dataArray.append(QuestionObject(id: id, title: title, question_number: question_number, form_type: form_type, radio_button_option: radioOptionsArray, defaultAnswer: defaultAnswer))
                        }
                        
                        //navigate to survey questions
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SurveyVC") as! SurveyVC
                        vc.dataArray = dataArray
                        vc.surveyTitle = userInfo["title"]!
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                    self.startBtn.setTitle("Start Survey", for: .normal)
                    self.startBtn.isUserInteractionEnabled = true
                })
            }, afterDelay: 0.5)
            
            
            
        }
    }
    
    @IBAction func startSurvey(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectSurveyViewController") as! SelectSurveyViewController
        vc.title = "Select a Survey"
        let navC = UINavigationController.init(rootViewController: vc)
        navC.modalPresentationStyle = .pageSheet
        if let sheet = navC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        self.present(navC, animated: true, completion: nil)
    }
    
}

