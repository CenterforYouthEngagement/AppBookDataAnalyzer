//
//  Supported Curriculums.swift
//  AppBookDataAnalyzer
//
//  Created by Jeremy Kelleher on 2/23/22.
//

import Foundation

extension Curriculum {
    
    /// A representation of the INSITE curriculum used in the 2022-04-18 research study
    static let insite20220418 = Curriculum(
        appbooks: [
            AppBook(title: "Intro", pageCount: 22),
            AppBook(title: "Values", pageCount: 19),
            AppBook(title: "GoalSetting", pageCount: 16),
            AppBook(title: "DecisionMaking", pageCount: 19),
            AppBook(title: "Education", pageCount: 10),
            AppBook(title: "Budgeting", pageCount: 14),
            AppBook(title: "ExploringCareers", pageCount: 32),
            AppBook(title: "WaysToWork", pageCount: 20),
            AppBook(title: "GetAJob", pageCount: 23),
            AppBook(title: "Business", pageCount: 13),
            AppBook(title: "Disclosure", pageCount: 19),
            AppBook(title: "SoftSkills", pageCount: 22),
            AppBook(title: "MockInterview", pageCount: 12),
            AppBook(title: "SelfAdvocacy", pageCount: 21),
            AppBook(title: "STEM", pageCount: 10),
        ],
        jobs: [],
        analytics: []
    )
    
}
