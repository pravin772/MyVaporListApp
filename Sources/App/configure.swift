import Leaf
import Vapor
import FluentSQLite
import Fluent

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(LeafProvider())
    try services.register(FluentSQLiteProvider())
    
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Use Leaf for rendering views
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    //Database
    var databaseConfig = DatabasesConfig()
   // let dataFile = "\(directoryConfig.workDir)list.db"
    let sqliteDB = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)list.db"))
    databaseConfig.add(database: sqliteDB, as: .sqlite)
    services.register(databaseConfig)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Item.self, database: .sqlite)
    services.register(migrationConfig)
    
    

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
}
