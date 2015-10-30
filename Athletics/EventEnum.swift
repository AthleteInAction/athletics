//
//  EventEnum.swift
//  Athletics
//
//  Created by grobinson on 10/30/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

extension Event {
    
    enum Key {
        
        case Practice
        case GameLeague
        case GameNonLeague
        case GamePreseason
        case Scrimmage
        case Fundraiser
        case Other
        
        var string: String {
            
            switch self {
            case .Practice: return "practice"
            case .GameLeague: return "game_league"
            case .GameNonLeague: return "game_non_league"
            case .GamePreseason: return "game_preseason"
            case .Scrimmage: return "scrimmage"
            case .Fundraiser: return "fundraiser"
            default: return "other"
            }
            
        }
        
        var display: String {
            
            switch self {
            case .Practice: return "Practice"
            case .GameLeague: return "League Game"
            case .GameNonLeague: return "Non-League Game"
            case .GamePreseason: return "Preseason Game"
            case .Scrimmage: return "Scrimmage"
            case .Fundraiser: return "Fundraiser"
            default: return "Other"
            }
            
        }
        
    }
    
}

extension String {
    
    func toEventKey() -> Event.Key {
        
        switch self {
        case "practice": return .Practice
        case "game_league": return .GameLeague
        case "game_non_league": return .GameNonLeague
        case "game_preseason": return .GamePreseason
        case "scrimmage": return .Scrimmage
        case "fundraiser": return .Fundraiser
        default: return .Other
        }
        
    }
    
}