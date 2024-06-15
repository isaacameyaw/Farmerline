//
//  SelectSurveyViewController.swift
//  Farmerline
//
//  Created by Ikus on 13/06/2024.
//

import UIKit

class SelectSurveyViewController: UIViewController {

    @IBOutlet weak var surveyTable: UITableView!
    var surveyArray = [SurveyObject]()
    
    struct SurveyObject {
        var name = String()
        var url = String()
    }
    
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surveyArray = [
            SurveyObject(name: "Test Survey 1", url: "https://app-testing.mergdata.net/assessment/testjson1.json"),
            SurveyObject(name: "Test Survey 2", url: "https://app-testing.mergdata.net/assessment/testjson2.json")
        ]
        
        let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        containerView.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        let closeImg = UIImageView(frame: CGRect.init(x: 8, y: 2, width: 26, height: 26))
        closeImg.image = UIImage(named: "close")
        containerView.addSubview(closeImg)
        let closeBarButtonItem = UIBarButtonItem(customView: containerView)
        self.navigationItem.rightBarButtonItem = closeBarButtonItem
        
    }
    
}

extension SelectSurveyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        surveyTable.deselectRow(at: indexPath, animated: true)
        let dataObj = surveyArray[indexPath.row]
        let dictObj: [String: String] = ["url": dataObj.url, "title": dataObj.name]
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "loadSurvey"), object: nil, userInfo:dictObj)
        self.dismiss(animated: true)
    }
}

extension SelectSurveyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataObj = surveyArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        let txtTitle = cell?.contentView.viewWithTag(100) as? UILabel
        txtTitle?.text = dataObj.name
        
        return cell!
    }
    
    
}
