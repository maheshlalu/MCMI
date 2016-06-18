//
//  CX_Products+CoreDataProperties.swift
//  Silly Monks
//
//  Created by Sarath on 19/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


extension CX_Products {

    @NSManaged var addToCart: String?
    @NSManaged var createdByID: String?
    @NSManaged var favourite: String?
    @NSManaged var itemCode: String?
    @NSManaged var json: String?
    @NSManaged var mallID: String?
    @NSManaged var name: String?
    @NSManaged var pID: String?
    @NSManaged var quantity: String?
    @NSManaged var storeID: String?
    @NSManaged var subCatNameID: String?
    @NSManaged var type: String?
    @NSManaged var tagValue: String?

}
