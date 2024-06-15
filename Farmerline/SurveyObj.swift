//
//  SurveyObj.swift
//  Farmerline
//
//  Created by Ikus on 13/06/2024.
//

import UIKit

class DataAdapter: NSObject {

}

struct RadioObject {
    var id = Int()
    var name = String()
}
struct QuestionObject {
    var id = Int()
    var title = String()
    var question_number = Int()
    var form_type = String()
    var radio_button_option = [RadioObject]()
    var defaultAnswer = String()
}

