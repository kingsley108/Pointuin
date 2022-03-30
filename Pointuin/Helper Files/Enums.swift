//
//  Enums.swift
//  Pointuin
//
//  Created by Kingsley Charles on 24/03/2022.
//

import Foundation
import UIKit

enum MemberType: String {
    
  case admin =  "Scrum Master"
  case dev = "Developer"
  case non_dev = "Non Developer"
  case error
  case none
}

enum SessionOptions {
    case dev(img:UIImage)
    case planningStart(img:UIImage)
    case noTeamSession

    static let indev = SessionOptions.dev(img: UIImage(systemName: "keyboard")!.withTintColor(UIColor.homeColour))
    
    static let inplan = SessionOptions.planningStart(img: UIImage(systemName: "lightbulb.fill")!.withTintColor(UIColor.homeColour))
    
    init(state: SessionState) {
        
        switch state {
        case .noSession:
            self = SessionOptions.noTeamSession
        case .active:
           self = SessionOptions.inplan
        case .inactive:
            self = SessionOptions.indev
        }
    }
}


enum SessionState: String {
    case active = "active"
    case inactive = "inactive"
    case noSession = "noSession"
    
    
    init(sessionSate: String) {
        self = SessionState(rawValue: sessionSate) ?? .noSession
    }
}
