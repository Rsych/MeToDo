//
//  DataController-CloudKit.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import Foundation
import CloudKit

extension DataController {
    func uploadToiCloud(_ project: Project) {
        let records = project.prepareCloudRecords()
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .allKeys

        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                print("Success")
            case .failure(let error):
                print("Error: \(error.getCloudKitError())")
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    func removeFromCloud(_ project: Project) {
        let name = project.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                print("Deleted")
            case .failure(let error):
                print("Error: \(error.getCloudKitError())")
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
