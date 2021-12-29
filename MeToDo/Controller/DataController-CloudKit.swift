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
                print("Error: \(error.localizedDescription)")
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
