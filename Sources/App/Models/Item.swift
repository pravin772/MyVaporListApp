//
//  Item.swift
//  App
//
//  Created by Pravin Bendre on 13/6/19.
//

import Vapor
import FluentSQLite

final class Item: SQLiteModel{
    var id:Int?
    var item:String
}

extension Item: Migration {}

extension Item: Content {}

extension Item: Parameter {}

