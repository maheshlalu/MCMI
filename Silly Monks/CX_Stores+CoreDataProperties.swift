//
//  CX_Stores+CoreDataProperties.swift
//  Silly Monks
//
//  Created by Sarath on 04/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


extension CX_Stores {

    @NSManaged var sID: String?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var json: String?
    @NSManaged var favourite: String?
    @NSManaged var createdById: String?
    @NSManaged var itemCode: String?
    @NSManaged var mallID: String?

}
