//
//  RealmManager.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import RealmSwift
import Realm

class RealmManager {
    
//    MARK: Vars
    enum AppID: String {
        case cactusMain = "cactus-main-sikxw"
    }
    
    enum SubscriptionKey: String {
        case testObject
        case cactusPost
    }
    
    static let mainApp: String = RealmManager.AppID.cactusMain.rawValue
    
    private(set) var apps: [RealmSwift.App] = []
    private(set) var realms: Dictionary<String, Realm> = Dictionary()
    
    var mainRealmConfiguration: Realm.Configuration = Realm.Configuration()
    
//    MARK: Convenience Functions
//    This simply avoids having to type out the 'getCurrentUser' call on authenticationManager
//    and provides a standard error message if no user was found
    func currentUser(_ appID: String? = nil, enumAppID: RealmManager.AppID? = nil) -> RealmSwift.User? {
        if let currentUser = CactusModel.authenticationManager.getCurrentUser(forApp: enumAppID == nil ? appID! : enumAppID!.rawValue ) {
            return currentUser
        }
        print( "No user found for app: \(appID == nil ? enumAppID!.rawValue : appID!)" )
        return nil
    }
    
    func realm(_ appID: String = RealmManager.mainApp) -> Realm? {
        if let realm = self.realms[ appID ] { return realm }
        print( "no realm found for app: \(appID)" )
        return nil
    }
    
    
//    MARK: App Functions
    func getApp(_ appID: String) -> RealmSwift.App? {
        if let app = self.apps.first(where: { app in app.appId == appID }) {
            return app
        }
        return nil
    }
    
    
    private func openApp( _ appID: String ) {
        if getApp( appID ) == nil {
            let app = RealmSwift.App(id: appID)
            self.apps.append(app)
        }
    }
    
    func openInitialApps() {
        openApp( AppID.cactusMain.rawValue )
    }
    
    
//    MARK: Open Realm Functions
    private func openRealm( for appID: String, initialSubs: @escaping @Sendable (SyncSubscriptionSet) -> Void ) async {
        do {
            if let configuration = await generateSyncConfiguration(for: appID, initialSubs: initialSubs) {
                let realm = try await Realm(configuration: configuration)
                self.realms[ appID ] = realm
            }
            
        } catch { print("unable to open realm: \(error.localizedDescription)") }
    }
    
    private func openRealm( for appID: String, configuration: Realm.Configuration ) async {
        do {
            let realm = try await Realm(configuration: configuration)
            self.realms[ appID ] = realm
        } catch { print("unable to open realm: \(error.localizedDescription)") }
    }
    
    private func generateSyncConfiguration(for appID: String, initialSubs: @escaping @Sendable (SyncSubscriptionSet) -> Void ) async -> Realm.Configuration? {
        if let currentUser = currentUser(appID) {
            
            let configuration = currentUser.flexibleSyncConfiguration(initialSubscriptions: initialSubs)
            return configuration
        }
        return nil
    }
        
//    this function should open all but the default realm
//    the default realm will be opened in the responsive UI
    func openInitialRealms() async {
        
        await self.setupMainConfiguration()
        
        await openRealm(for: RealmManager.mainApp, configuration: self.mainRealmConfiguration)
        
    }
    
    private func setupMainConfiguration() async {
        
        if let config = await generateSyncConfiguration(for: RealmManager.mainApp, initialSubs: { subs in
            let _:CactusPost? = self.addGenericSubscriptionToInitialSubs(RealmManager.SubscriptionKey.cactusPost.rawValue, subscriptions: subs) { obj in
                obj.ownerID == CactusModel.ownerID
            }
        }) {
            self.mainRealmConfiguration = config
            Realm.Configuration.defaultConfiguration = config
        }
        
        
    }
    
    
//    MARK: Subscriptions
//    when creating a realm with a set of initial subscriptions, call this function to quickly create a sub in that block
    private func addGenericSubscriptionToInitialSubs<T: RealmSwiftObject>(_ name: String, subscriptions: SyncSubscriptionSet, query: @escaping ((Query<T>) -> (Query<Bool>)) ) -> T? {
        let subsExist = subscriptions.first(named: name)
            
        if (subsExist != nil) { return nil } else {
            let subscription = QuerySubscription(name: name, query: query)
            subscriptions.append(subscription)
        }
        
        return nil
    }
    
    
    func addGenericSubcriptions<T>( for appID: String, name: String, query: @escaping ((Query<T>) -> Query<Bool>) ) async -> T? where T:RealmSwiftObject  {
            
        if let realm = self.realm(appID) {
            let subscriptions = realm.subscriptions
            
            do {
                try await subscriptions.update {
                    
                    let querySub = QuerySubscription(name: name, query: query)
                    
                    if checkSubscription(name: name, realm: realm) {
                        let foundSubscriptions = subscriptions.first(named: name)!
                        foundSubscriptions.updateQuery(toType: T.self, where: query)
                    }
                    else { subscriptions.append(querySub) }
                }
            } catch { print("error adding subcription: \(error)") }
            
        }
        return nil
    }
    
    private func checkSubscription(name: String, realm: Realm) -> Bool {
        let subscriptions = realm.subscriptions
        let foundSubscriptions = subscriptions.first(named: name)
        return foundSubscriptions != nil
    }
    
    func removeSubscription(for appID: String, name: String) async {
            
        if let realm = self.realm(appID) {
            let subscriptions = realm.subscriptions
            let foundSubscriptions = subscriptions.first(named: name)
            if foundSubscriptions == nil {return}
            
            do {
                try await subscriptions.update{
                    subscriptions.remove(named: name)
                }
            } catch { print("error adding subcription: \(error)") }
        }
    }
    
    
//    MARK: Realm Functions
    
//    in all add, update, and delete transactions, the user has the option to pass in a realm
//    if they want to write to a different realm.
//    This is a convenience function either choose that realm
    static func getRealm(from appID: RealmManager.AppID ) -> Realm {
        CactusModel.realmManager.realms[ appID.rawValue ]!
    }
    
    static func writeToRealm(_ appID: RealmManager.AppID = .cactusMain, _ block: () -> Void ) {
        do {
            if getRealm(from: appID).isInWriteTransaction { block() }
            else { try getRealm(from: appID).write(block) }
            
        } catch { print("ERROR WRITING TO REALM:" + error.localizedDescription) }
    }
    
    static func updateObject<T: Object>(_ appID: RealmManager.AppID = .cactusMain, _ object: T, _ block: (T) -> Void, needsThawing: Bool = true) {
        RealmManager.writeToRealm(appID) {
            guard let thawed = object.thaw() else {
                print("failed to thaw object: \(object)")
                return
            }
            block(thawed)
        }
    }
    
    static func addObject<T:Object>( _ object: T, _ appID: RealmManager.AppID = .cactusMain ) {
        self.writeToRealm(appID) { getRealm(from: appID).add(object) }
    }
    
    static func retrieveObject<T:Object>( _ appID: RealmManager.AppID = .cactusMain, where query: ( (Query<T>) -> Query<Bool> )? = nil ) -> Results<T> {
        if query == nil { return getRealm(from: appID).objects(T.self) }
        else { return getRealm(from: appID).objects(T.self).where(query!) }
    }
    
    @MainActor
    static func retrieveObjects<T: Object>( _ appID: RealmManager.AppID = .cactusMain, where query: ( (T) -> Bool )? = nil) -> [T] {
        if query == nil { return Array(getRealm(from: appID).objects(T.self)) }
        else { return Array(getRealm(from: appID).objects(T.self).filter(query!)  ) }
        
        
    }
    
    static func deleteObject<T: RealmSwiftObject>( _ object: T, _ appID: RealmManager.AppID = .cactusMain, where query: @escaping (T) -> Bool ) where T: Identifiable {
        
        if let obj = getRealm(from: appID).objects(T.self).filter( query ).first {
            self.writeToRealm {
                getRealm(from: appID).delete(obj)
            }
        }
    }
}


//MARK: TestObject

class TestObject: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerID: String = ""
    
    @Persisted var name: String = ""
    
    convenience init(ownerID: String, name: String) {
        self.init()
        
        self.ownerID = ownerID
        self.name = name
    }
    
}
