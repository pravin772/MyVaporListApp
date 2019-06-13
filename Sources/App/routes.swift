import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("/") { request -> Future<View> in
        return Item.query(on: request).all().flatMap { list in
            let context = ListContext(itemList: list)
            return try request.view().render("list", context)
        }
    }
    
    router.post("create") { request -> Future<Response> in
            return try request.content.decode(Item.self).flatMap { item in
                item.save(on: request).map { item in
                return request.redirect(to: "/")
            }
        }
    }
    
    router.get("/delete", Item.parameter ) { request -> Future<Response> in
        let item = try request.parameters.next(Item.self)
        return item.delete(on: request).map { _ in
            return request.redirect(to: "/") 
        }
    }
    
    router.get("/edit", Item.parameter) { request -> Future<View> in
        return try request.parameters.next(Item.self).flatMap { item in
            let context = EditContext(item: item)
            return try request.view().render("edit", context)
        }
    }
    
    router.post("/edit", Item.parameter) { request -> Future<Response> in
        return try request.parameters.next(Item.self).flatMap { item in
            return try request.content.decode(Item.self).flatMap { editedItem in
                item.item = editedItem.item
                return item.save(on: request).map {item in
                    return request.redirect(to: "/")
                }
                
            }
        }
    }
}

struct ListContext: Encodable
{
    let itemList: [Item]
}
struct EditContext: Encodable
{
    let item: Item
}
