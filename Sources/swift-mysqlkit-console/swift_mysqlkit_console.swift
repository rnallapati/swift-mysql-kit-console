import Foundation
import MySQLKit

@main
public struct swift_mysqlkit_console {
    public static func main() {
        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        tlsConfig.certificateVerification = .none

        let configuration = MySQLConfiguration(
            hostname: "localhost",
            port: 3306,
            username: "root",
            password: "users123",
            database: "employees",
            tlsConfiguration: tlsConfig
        )

        let mysqlSource = MySQLConnectionSource(configuration: configuration)
        // Create an instance of the MultiThreadedEventLoopGroup class, which represents a 
        // group of event loops that run on multiple threads. The number of threads is determined 
        // by the System.coreCount property, which returns the number of cores in the system.
        let eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

        // ensure that the code inside the block will be executed before the current scope is exited
        defer { try! eventLoopGroup.syncShutdownGracefully() }

        // Create an instance of the EventLoopGroupConnectionPool class, which provides a 
        // pool of connections to the MySQL database. The MySQLConnectionSource class is used 
        // to create a source of connections to the database, and it is initialized with the 
        // configuration instance.
        let pools = EventLoopGroupConnectionPool(
            source: mysqlSource,
            on: eventLoopGroup
        )

        // Create an instance of the EventLoop class, which is an event loop that can run NIO tasks. 
        // It is obtained from the EventLoopGroup instance by calling its next() method.
        let eventLoop: EventLoop = pools.eventLoopGroup.next()

        // Create an instance of the ConnectionPool class, which represents a pool of connections 
        // to a MySQL database. It is obtained from the EventLoopGroupConnectionPool instance by 
        // calling its pool(for:) method, and passing the eventLoop instance as a parameter.
        let pool = pools.pool(for: eventLoop)

        // Create an instance of the MySQLDatabase class, which represents a database connection to 
        // a MySQL database. It is obtained from the ConnectionPool instance by calling 
        // its database(logger:) method, and passing an instance of Logger as a parameter. 
        // The label of the logger is set to "MySQL".
        let mysql = pool.database(logger: Logger(label: "MySQL"))
        
        if let rows = try? mysql.simpleQuery("select * from users;").wait() {
            print("Row count: \(rows.count)")
            for row in rows {
                print(row)
            }
        } else {
            print("Connection to mysql db failed!")
        }
        
        // Clear out pools before the block ends.
        pools.shutdown() 
    }
}
