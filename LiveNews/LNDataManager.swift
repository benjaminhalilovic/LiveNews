//
//  LNDataManager.swift
//  LiveNews
//
//  Created by mac on 15/12/16.
//  Copyright © 2016 Benjamin Halilovic. All rights reserved.
//

import UIKit
import CoreData

class LNDataManager {
    static let sharedInstance = LNDataManager()
    private var cachedMainMOC: NSManagedObjectContext?
    private var cachedBackgroundMOC: NSManagedObjectContext?
    lazy var persistanStack = LNPersistantStack()
    
    private init(){
        setManagedObjectContext(persistanStack.mainQueueContext, background: persistanStack.backgroundQueueContext)
    }
    
    private func setManagedObjectContext(main: NSManagedObjectContext, background: NSManagedObjectContext) {
        cachedMainMOC = main
        cachedBackgroundMOC = background
    }
    
    var mainMOC: NSManagedObjectContext {
        get{
            if cachedMainMOC != nil {
                return cachedMainMOC!
            } else {
                fatalError("trying to access managed context without initializing it")
            }
        }
    }
    
    var backgroundMOC: NSManagedObjectContext {
        get{
            if cachedBackgroundMOC != nil {
                return cachedBackgroundMOC!
            } else {
                fatalError("trying to access managed context without initializing it")
            }
        }
    }

}
