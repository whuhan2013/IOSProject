//
//  User.swift
//  Autolayout
//
//  Created by SchUser on 16/10/6.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let company: String
    let login: String 
    let password: String
    
    static func login(login: String, password: String) -> User? {
        if let user = datebase[login] {
            if user.password == password {
                return user
            }
        }
        return nil
    }
    //数据库
    static let datebase: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in [
            User(name: "John Appleseed", company: "Apple", login: "japple", password: "foo"),
            User(name: "Madisom Bumgarner", company: "World Champion San Francisco Giants", login: "madbum", password: "foo"),
            User(name: "John Hennessy", company: "Stanford", login: "hennessy", password: "foo"),
            User(name: "Bad Guy", company: "Criminals Inc", login: "baddie", password: "foo")
            ] {
                theDatabase[user.login] = user
        }
        return theDatabase
    }()
    
}