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

        let eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer { try! eventLoopGroup.syncShutdownGracefully() }

        let pools = EventLoopGroupConnectionPool(
            source: mysqlSource,
            on: eventLoopGroup
        )

        let eventLoop: EventLoop = pools.eventLoopGroup.next()

        let pool = pools.pool(for: eventLoop)


        let mysql = pool.database(logger: Logger(label: "MySQL"))
        
        if let rows = try? mysql.simpleQuery("select * from users;").wait() {
            print("Row count: \(rows.count)")
            for row in rows {
                print(row)
            }
            
        } else {
            print("Connection to mysql db failed!")
        }
        

        pools.shutdown() 
    }
}
