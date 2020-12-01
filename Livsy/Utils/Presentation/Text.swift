//
//  Text.swift
//  Livsy
//
//  Created by Artem on 23.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

enum Text {
    
    enum Common {
        
        static let empty = ""
        static let ok = "OK"
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let close = NSLocalizedString("Close", comment: "")
        static let tryAgain = NSLocalizedString("Try again", comment: "")
        static let search = NSLocalizedString("Search", comment: "")
        static let save = NSLocalizedString("Save", comment: "")
        static let openVideo = NSLocalizedString("▶ Tap the video to open", comment: "")
        
    }
    
    
    enum Post {
        
        static let comment = NSLocalizedString("Comments", comment: "")
        static let addedTF = NSLocalizedString("Added to favorites", comment: "")
        static let removedFF = NSLocalizedString("Removed from favorites", comment: "")
        
    }
    
    enum Comments {
        
        static let beTheFirst = NSLocalizedString("Be the first", comment: "")
        static let loginToReply = NSLocalizedString("Login to reply", comment: "")
        static let reply = NSLocalizedString("reply", comment: "")
        static let replies = NSLocalizedString("replies", comment: "")
        
    }
    
    enum Login {
        
        static let login = NSLocalizedString("Login", comment: "")
        static let forgotPassword = NSLocalizedString("Forgot password?", comment: "")
        static let dontHaveAccount = NSLocalizedString("Don't have an account?  ", comment: "")
        
    }
    
    enum SignUp {
        
        static let signUp = NSLocalizedString("Sign up", comment: "")
        static let username = NSLocalizedString("Username", comment: "")
        static let password = NSLocalizedString("Password", comment: "")
        
    }
    
    enum Profile {
        
        static let profile = NSLocalizedString("Profile", comment: "")
        static let leaveComments = NSLocalizedString("Leave comments", comment: "")
        static let seeProfileInfo = NSLocalizedString("See your profile information", comment: "")
        static let noFavPosts = NSLocalizedString("No favorite posts yet", comment: "")
        static let favPosts = NSLocalizedString("Favorite posts", comment: "")
        static let signOut = NSLocalizedString("Sign out", comment: "")
        static let continueToLogin = NSLocalizedString("Continue", comment: "")
        static let supportEmail = NSLocalizedString("info@livsy.me", comment: "")
        static let emailSent = NSLocalizedString("Email sent", comment: "")
        static let appVersion = NSLocalizedString("App version", comment: "")
        static let noMailAccount = NSLocalizedString("You have not set up the Mail app", comment: "")
        static let feedbackSubject = NSLocalizedString("Feedback on the Livsy.me app", comment: "")
        static let feedback = NSLocalizedString("Feedback", comment: "")
    }
    
    enum Tags {
        
        static let tags = NSLocalizedString("Tags", comment: "")
        
    }
    
    enum Categories {
        
        static let categories = NSLocalizedString("Categories", comment: "")
        
    }
    
    enum Pages {
        
        static let pages = NSLocalizedString("Pages", comment: "Детализация факта")
    }
    
}
