import Vapor

struct task: Content {
    var id: String
    var title: String
    var completed: String
    
    init(id: String, title: String, completed: String) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}

struct taskId: Content {
    var id: String
}

var tasks = [task]()


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get("tasks") { req -> [task] in
        return tasks
    }

    router.get("tasks/active") { req -> [task] in
        return tasks.filter { $0.completed == "false" }
    }
    
    router.post("create") { req -> Future<HTTPStatus> in
        return try req.content.decode(task.self).map(to: HTTPStatus.self) { t in
            let t = task(id: t.id, title: t.title, completed: t.completed)
            tasks.append(t)
            return .ok
        }
    }
    
    router.put("update") { req -> Future<HTTPStatus> in
        return try req.content.decode(task.self).map(to: HTTPStatus.self) { t in
            
            if let index = tasks.index(where: {$0.id == t.id }) {
                tasks[index].title = t.title
                tasks[index].completed = t.completed
            }
            return .ok
        }
    }
    
    router.delete("delete") { req -> Future<HTTPStatus> in
        return try req.content.decode(taskId.self).map(to: HTTPStatus.self) { tid in
            
            if let index = tasks.index(where: {$0.id == tid.id }) {
                tasks.remove(at: index)
            }
            return .ok
        }
    }

    
    //router.get("route", ":key", "route2", ":key2")

    // Example of configuring a controller
   // let todoController = TodoController()
    //router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
}
