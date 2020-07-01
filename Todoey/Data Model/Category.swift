//
//  Category.swift
//  Todoey
//
//  Created by Abdelrahman on 6/14/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
}
