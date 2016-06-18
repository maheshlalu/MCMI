//
//  CX_SingleMall+CoreDataProperties.swift
//  Silly Monks
//
//  Created by Sarath on 03/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


extension CX_SingleMall {

    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var mallDesc: String?
    @NSManaged var mobile: String?
    @NSManaged var coverImage: String?
    @NSManaged var address: String?
    @NSManaged var location: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var countryName: String?
    @NSManaged var countryCode: String?
    @NSManaged var mallID: String?
    @NSManaged var fbLink: String?

}
