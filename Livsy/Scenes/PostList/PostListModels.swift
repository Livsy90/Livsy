//
//  PostListModels.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

/*
 for imgURL use this
 
 add_action('rest_api_init', 'register_rest_images' );
 function register_rest_images(){
     register_rest_field( array('post'),
         'fimg_url',
         array(
             'get_callback'    => 'get_rest_featured_image',
             'update_callback' => null,
             'schema'          => null,
         )
     );
 }
 function get_rest_featured_image( $object, $field_name, $request ) {
     if( $object['featured_media'] ){
         $img = wp_get_attachment_image_src( $object['featured_media'], 'app-thumb' );
         return $img[0];
     }
     return false;
 }
 */

struct Post: Codable {
    let id: Int
    let date: String
    let title: Title?
    let excerpt: Excerpt?
    let imgURL: String?
    let link: String
    let content: Content?
    let author: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case title
        case excerpt
        case imgURL = "fimg_url"
        case link
        case content
        case author
    }
    
    init(
        id: Int,
        date: String,
        title: Title?,
        excerpt: Excerpt?,
        imgURL: String?,
        link: String,
        content: Content?,
        author: Int
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.excerpt = excerpt
        self.imgURL = imgURL
        self.link = link
        self.content = content
        self.author = author
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        title = try? container.decode(Title.self, forKey: .title)
        excerpt = try? container.decode(Excerpt.self, forKey: .excerpt)
        imgURL = try? container.decode(String.self, forKey: .imgURL)
        link = try container.decode(String.self, forKey: .link)
        content = try? container.decode(Content.self, forKey: .content)
        author = try container.decode(Int.self, forKey: .author)
    }
    
}

struct Title: Codable {
    let rendered: String
}

struct Content: Codable {
    let rendered: String?
    let protected: Bool?
}

struct Excerpt: Codable {
    let rendered: String?
    let protected: Bool
}

struct Guid: Codable {
    let rendered: String
}

enum PostListModels {
    
    // MARK: - PostList
    
    enum PostList {
        
        struct Request {
            var page: Int = 1
            var searchTerms: String = ""
        }
        
        struct Response {
            let error: CustomError?
        }
        
        struct ViewModel {
            let isStopRereshing: Bool
        }
    }
    
    // MARK: - FilteredPostList
    
    enum FilteredPostList {
        
        struct Request {
            var isTag: Bool
            var page: Int = 1
            var id: Int
        }
        
        struct Response {
            let error: CustomError?
        }
        
        struct ViewModel {
            let isStopRereshing: Bool
        }
    }
    
    // MARK: - Login
    
    enum Login {
        
        struct Request {
            var username: String
            var password: String
        }
        
        struct Response {
            let error: CustomError?
            
        }
        
        struct ViewModel {
            let error: CustomError?
        }
    }
    
    // MARK: - Tags
    
    enum Tags {
        
        struct Request {
            var isTags: Bool
        }
        
        struct Response {
            var isTags: Bool
        }
        
        struct ViewModel {
            var isTags: Bool
        }
    }
    
    enum PageList {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum PostPage {
        
        struct Request {
            var post: Post
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum PostFromLink {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
}
