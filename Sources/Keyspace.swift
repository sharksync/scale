//
//  Keyspace.swift
//  scale
//
//  Created by Adrian Herridge on 17/02/2017.
//
//

import Foundation
import SWSQLite

class Keyspace : DataObject {
    
    // object vars
    var name: String?
    var replication: NSNumber?
    var size: NSNumber?
    var template: String?
    
    convenience init(_name: String, _replication: Int, _size: Int, _template: String?) {
        self.init()
        self.name = _name
        self.replication = NSNumber(value: _replication)
        self.size = NSNumber(value: _size)
    }
    
    override func populateFromRecord(_ record: Record) {
        self.name = record["name"]?.asString()
        self.template = record["template"]?.asString()
        self.replication = record["replication"]?.asNumber()
        self.size = record["size"]?.asNumber()
    }
    
    override class func GetTables() -> [Action] {
        var actions = [
            Action(createTable: "Keyspace"),
            Action(addColumn: "name", type: .String, table: "Keyspace"),
            Action(addColumn: "replication", type: .Numeric, table: "Keyspace"),
            Action(addColumn: "size", type: .Numeric, table: "Keyspace"),
            Action(addColumn: "template", type: .Numeric, table: "Keyspace")
        ]
        
        actions.append(contentsOf: KeyspaceSchema.GetTables())
        
        return actions
    }
    
    // data manipulation and creation functions
    class func Create(_ keyspace: String, replication: Int, template: String?) -> String {
        let sys = Shards.systemShard()
        var sysKeyspaces: [Keyspace] = []
        for record in sys.read(sql: "SELECT * FROM Keyspace WHERE name = ? LIMIT 1", params: [keyspace]) {
            let k = Keyspace(record)
            sysKeyspaces.append(k)
        }
        var keyspaceId: String? = nil
        if sysKeyspaces.count == 0 {
            let newKeyspace = Keyspace()
            keyspaceId = newKeyspace._id_
            newKeyspace.name = keyspace
            newKeyspace.replication = NSNumber(value: replication)
            newKeyspace.size = 0
            newKeyspace.template = template
            sys.write(newKeyspace.Commit())
        } else {
            
            let record = sysKeyspaces[0]
            keyspaceId = record._id_
            let rep = record.replication
            if rep?.intValue != replication {
                record.replication = NSNumber(value: replication)
                sys.write(record.Commit())
            }
            
        }
        return keyspaceId!
    }
    
    class func Exists(_ keyspace: String) -> Bool {
        let sys = Shards.systemShard()
        let count = sys.read(sql: "SELECT NULL FROM Keyspace WHERE name = ?", params: [keyspace])
        if count.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    class func Get(_ keyspace: String) -> Keyspace? {
        let sys = Shards.systemShard()
        let k = sys.read(sql: "SELECT * FROM Keyspace WHERE name = ?", params: [keyspace])
        if k.count > 0 {
            for record in k {
                let key = Keyspace(record)
                return key
            }
        }
        return nil
    }
    
}
