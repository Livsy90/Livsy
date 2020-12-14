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
        static let livsy = NSLocalizedString("Livsy", comment: "")
        static let at = NSLocalizedString("at", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let close = NSLocalizedString("Close", comment: "")
        static let back = NSLocalizedString("Back", comment: "")
        static let tryAgain = NSLocalizedString("Try again", comment: "")
        static let search = NSLocalizedString("Search", comment: "")
        static let save = NSLocalizedString("Save", comment: "")
        static let openVideo = NSLocalizedString("Tap the video to open", comment: "")
        static let yes = NSLocalizedString("Yes", comment: "")
        static let no = NSLocalizedString("No", comment: "")
        
    }
    
    
    enum Post {
        
        static let publishedOn = NSLocalizedString("Published on", comment: "")
        static let comment = NSLocalizedString("Comment", comment: "")
        static let comments = NSLocalizedString("Comments", comment: "")
        static let addedTF = NSLocalizedString("Added to favorites", comment: "")
        static let addTF = NSLocalizedString("Add to favorites", comment: "")
        static let removedFF = NSLocalizedString("Removed from favorites", comment: "")
        static let removeFF = NSLocalizedString("Remove from favorites", comment: "")
        static let postNotFound = NSLocalizedString("Post not found", comment: "")
        
    }
    
    enum Comments {
        static let enterComment = NSLocalizedString("Enter comment", comment: "")
        static let answer = NSLocalizedString("Answer", comment: "")
        static let beTheFirst = NSLocalizedString("Be the first", comment: "")
        static let loginToReply = NSLocalizedString("Login to reply", comment: "")
        static let reply = NSLocalizedString("reply", comment: "")
        static let replies = NSLocalizedString("replies", comment: "")
        static let noReplies = NSLocalizedString("no replies yet", comment: "")
        static let repliesCapital = NSLocalizedString("Replies", comment: "")
        static let discussion = NSLocalizedString("Discussion", comment: "")
    }
    
    enum Login {
        
        static let login = NSLocalizedString("Login", comment: "")
        static let forgotPassword = NSLocalizedString("Forgot password?", comment: "")
        static let dontHaveAccount = NSLocalizedString("Don't have an account?  ", comment: "")
        static let sendInstructions = NSLocalizedString("Send instructions", comment: "")
        static let logingOrEmail = NSLocalizedString("Login or email", comment: "")
        
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
        static let loginOrSignUp = NSLocalizedString("Login or sign up to:", comment: "")
        static let youAreLoggedOut = NSLocalizedString("You are logged out", comment: "")
        static let areYouSure = NSLocalizedString("Are you sure?", comment: "")
        
    }
    
    enum Tags {
        
        static let tags = NSLocalizedString("Tags", comment: "")
        
    }
    
    enum Categories {
        
        static let categories = NSLocalizedString("Categories", comment: "")
        
    }
    
    enum Pages {
        
        static let pages = NSLocalizedString("Pages", comment: "")
    }
    
}
