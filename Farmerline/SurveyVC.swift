//
//  SurveyVCViewController.swift
//  Farmerline
//
//  Created by Ikus on 13/06/2024.
//

import UIKit
import RadioGroup

class SurveyVC: UIViewController {

    @IBOutlet weak var txtTitle: UILabel!
    var dataArray = [QuestionObject]()
    var surveyTitle = ""
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var txtTotalQuestions: UILabel!
    @IBOutlet weak var progressBorderVew: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var totalQueView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var theScrollView: UIScrollView!
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = surveyTitle
        progressBorderVew.layer.cornerRadius = 5
        progressBorderVew.layer.borderWidth = 1
        progressBorderVew.layer.borderColor = .init(gray: 50, alpha: 0.5)
        progressBorderVew.clipsToBounds = true
        statusView.layer.cornerRadius = 10
        totalQueView.layer.cornerRadius = 6
        txtTotalQuestions.text = "\(dataArray.count)"
        prevBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        submitBtn.layer.cornerRadius = 10
        setupPages()
    }
    
    func setupPages() {
        if theScrollView.subviews.count == 2 {
            theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width * CGFloat(dataArray.count), height: theScrollView.frame.size.height)
            theScrollView.isPagingEnabled = true
            theScrollView.showsHorizontalScrollIndicator = false
            theScrollView.delegate = self
            prevBtn.isEnabled = false
            self.prevBtn.alpha = 0.5
            self.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: Int(self.progressBorderVew.frame.size.height))
            self.updateProgress()

            for x in 0..<dataArray.count {
                let page = UIView(frame: CGRect(x: CGFloat(x) * theScrollView.frame.size.width, y: 0, width: theScrollView.frame.size.width, height: theScrollView.frame.size.height))
                page.backgroundColor = .clear
                let questionObj = dataArray[x]
                
                let txtQuestNumber = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                txtQuestNumber.textAlignment = .center
                txtQuestNumber.textColor = UIColor(named: "quest_number")
                txtQuestNumber.font = UIFont.boldSystemFont(ofSize: 18)
                txtQuestNumber.text = "\(questionObj.question_number)."
                page.addSubview(txtQuestNumber)
                
                let txtTitle = UILabel(frame: CGRect(x: 40, y: 0, width: theScrollView.frame.size.width - 50, height: 40))
                txtTitle.textAlignment = .left
                txtTitle.textColor = UIColor(named: "quest_number")
                txtTitle.font = UIFont.systemFont(ofSize: 18)
                txtTitle.text = "\(questionObj.title)"
                page.addSubview(txtTitle)
                
                if questionObj.form_type == "EDIT_TEXT" {
                    
                    let tfHolder = UIView(frame: CGRect(x: 40, y: 50, width: theScrollView.frame.size.width - 50, height: 50))
                    tfHolder.backgroundColor = UIColor(named: "tf_bg")
                    tfHolder.layer.cornerRadius = 8
                    tfHolder.layer.borderWidth = 1
                    tfHolder.layer.borderColor = UIColor(named: "tf_bdr")?.cgColor
                    let txtAnswer = UITextField(frame: CGRect(x: 10, y: 0, width: tfHolder.frame.size.width-20, height: 50))
                    txtAnswer.backgroundColor = .clear
                    txtAnswer.textColor = UIColor(named: "quest_number")
                    txtAnswer.font = UIFont.systemFont(ofSize: 17)
                    txtAnswer.placeholder = "Enter a response"
                    txtAnswer.delegate = self
                    tfHolder.addSubview(txtAnswer)
                    page.addSubview(tfHolder)
                    
                } else {
                    var radioTitleArray = [String]()
                    for i in 0..<questionObj.radio_button_option.count {
                        radioTitleArray.append(questionObj.radio_button_option[i].name)
                    }
                    let radioGroup = RadioGroup(titles: radioTitleArray)
                    radioGroup.selectedIndex = -1
                    radioGroup.addTarget(self, action: #selector(didSelectOption(radioGroup:)), for: .valueChanged)
                    radioGroup.isVertical = true           // default is true => buttons are stacked vertically
                    radioGroup.titleAlignment = .left
                    radioGroup.isButtonAfterTitle = false
                    radioGroup.tintColor = .black       // surrounding ring
                    radioGroup.selectedColor = .black     // inner circle (default is same color as ring)
                    radioGroup.selectedTintColor = .black  // selected radio button's surrounding ring (default is tintColor)

                    radioGroup.titleColor = .black
                    radioGroup.titleFont = UIFont.systemFont(ofSize: 17)
                    radioGroup.buttonSize = 20.0
                    radioGroup.spacing = 12             // spacing between buttons
                    radioGroup.itemSpacing = 12
                    
                    /*RadioButton.appearance().size = 32              // height=width of button
                    RadioButton.appearance().ringWidth = 3
                    RadioButton.appearance().ringSpacing = 7        // space between outer ring and inner circle
                    RadioButton.appearance().selectedColor = .blue*/
                    let hOffset = questionObj.radio_button_option.count * 35
                    radioGroup.frame = CGRect(x: 32, y: 50, width: page.frame.size.width-40, height: radioGroup.frame.size.height + CGFloat(hOffset))
                    page.addSubview(radioGroup)
                }
               
                
                theScrollView.addSubview(page)
            }
        }
    }
    
    @objc func didSelectOption(radioGroup: RadioGroup) {
            print(radioGroup.titles[radioGroup.selectedIndex] ?? "")
        }
    
    @IBAction func prevBtn(_ sender: Any) {
        currentPage = currentPage - 1
        if currentPage <= 0 {
            self.currentPage = 0
            self.prevBtn.isEnabled = false
            self.prevBtn.alpha = 0.5
            self.nextBtn.isEnabled = true
            self.nextBtn.alpha = 1
        } else {
            self.nextBtn.isEnabled = true
            self.nextBtn.alpha = 1
        }
        theScrollView.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * theScrollView.frame.size.width, y: 0), animated: true)
        updateProgress()
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        currentPage = currentPage + 1
        if currentPage >= self.dataArray.count - 1 {
            self.currentPage = self.dataArray.count - 1
            self.prevBtn.isEnabled = true
            self.prevBtn.alpha = 1
            self.nextBtn.isEnabled = false
            self.nextBtn.alpha = 0.5
        } else {
            self.prevBtn.isEnabled = true
            self.prevBtn.alpha = 1
        }
        theScrollView.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * theScrollView.frame.size.width, y: 0), animated: true)
        updateProgress()
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Submit Survey", message: "Would you like to submit this Survey now?", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
         
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
                  
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProgress() {
        let pWidth = Float(self.progressBorderVew.frame.size.width)
        let pageNum = Float(currentPage + 1)
        let percProg = Int(pageNum/Float(self.dataArray.count) * pWidth)
        print("pageNum: ",pageNum)
        print("percProg: ",percProg)
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.progressView.frame = CGRect(x: 0, y: 0, width: percProg, height: Int(self.progressBorderVew.frame.size.height))
        }, completion: nil)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SurveyVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        self.view.endEditing(true)
        if currentPage <= 0 {
            self.currentPage = 0
            self.prevBtn.isEnabled = false
            self.prevBtn.alpha = 0.5
            self.nextBtn.isEnabled = true
            self.nextBtn.alpha = 1
        } else {
            self.nextBtn.isEnabled = true
            self.nextBtn.alpha = 1
            self.prevBtn.isEnabled = true
            self.prevBtn.alpha = 1
        }
        
        if currentPage >= self.dataArray.count - 1 {
            self.currentPage = self.dataArray.count - 1
            self.prevBtn.isEnabled = true
            self.prevBtn.alpha = 1
            self.nextBtn.isEnabled = false
            self.nextBtn.alpha = 0.5
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateProgress()
    }
}

extension SurveyVC: UITextFieldDelegate {
    
}
