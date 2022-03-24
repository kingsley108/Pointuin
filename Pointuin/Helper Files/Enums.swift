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

enum SprintProgress{
    case dev(img:UIImage)
    case planning(img:UIImage)
    case noTeam

    static let indev = SprintProgress.dev(img: UIImage(systemName: "keyboard")!.withTintColor(UIColor.homeColour))
    
    static let inplan = SprintProgress.planning(img: UIImage(systemName: "lightbulb.fill")!.withTintColor(UIColor.homeColour))
    
    init(rawValue: String) {
        
        if rawValue == "My Team" {
            self = SprintProgress.noTeam
        }
        else if rawValue == "?"   {
            self = SprintProgress.indev
        }
        else {
            self = SprintProgress.inplan
        }
    }
    
    static let currentUser = UserProfile(username: "Kingsley Charles", email: "Kingsley108@yahoo.co.uk")
}

