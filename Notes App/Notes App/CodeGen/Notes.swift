//
//  Notes.swift
//  Notes App
//
//  Created by Decagon on 12/08/2022.
//

import CoreData

@objc(Notes)
class Notes: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var id: NSNumber
}
