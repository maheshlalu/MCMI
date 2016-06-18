//
//  CX_Product_Category+CoreDataProperties.swift
//  Silly Monks
//
//  Created by Sarath on 13/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


extension CX_Product_Category {

    @NSManaged var categoryMall: String?
    @NSManaged var createdByFullName: String?
    @NSManaged var createdById: String?
    @NSManaged var createdOn: String?
    @NSManaged var currentJobStatus: String?
    @NSManaged var icon_name: String?
    @NSManaged var icon_url: String?
    @NSManaged var itemCode: String?
    @NSManaged var jobTypeID: String?
    @NSManaged var jobTypeName: String?
    @NSManaged var name: String?
    @NSManaged var overallRating: String?
    @NSManaged var packageName: String?
    @NSManaged var pid: String?
    @NSManaged var productDescription: String?
    @NSManaged var publicUrl: String?
    @NSManaged var storeID: String?
    @NSManaged var totalReviews: String?
    @NSManaged var mallID: String?

}
