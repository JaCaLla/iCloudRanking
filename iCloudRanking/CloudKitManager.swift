//
//  CloudKitManager.swift
//  CloudKitRanking
//
//  Created by JAVIER CALATRAVA LLAVERIA on 23/4/25.
//
import CloudKit
import Foundation


class CloudKitManager: ObservableObject {
    @Published var scores: [PlayerScore] = []
    private var database = CKContainer(identifier: "iCloud.jca.iCloudRanking").publicCloudDatabase
    
    init() {
        fetchScores()
        setupSubscription()

        NotificationCenter.default.addObserver(
            forName: .cloudKitUpdate,
            object: nil,
            queue: .main
        ) { _ in
            self.fetchScores()
        }
    }

    func fetchScores() {
        let query = CKQuery(recordType: "Score", predicate: NSPredicate(value: true))
        let sort = NSSortDescriptor(key: "points", ascending: false)
        query.sortDescriptors = [sort]

        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let records = records {
                    self.scores = records.map { PlayerScore(record: $0) }.sorted { $0.points > $1.points }
                    print("Fetching successfull")
                } else if let error = error {
                    print("Error fetching scores: \(error.localizedDescription)")
                }
            }
        }
    }

    func addScore(name: String, points: Int) {
        let record = CKRecord(recordType: "Score")
        record["name"] = name as CKRecordValue
        record["points"] = points as CKRecordValue

        database.save(record) { _, error in
            if let error = error {
                print("Error saving score: \(error.localizedDescription)")
            } else {
                print("Saving successfull")
                
                
                // Make sure to fetch entries on the main thread
                DispatchQueue.main.async { [weak self] in
                    self?.localAddScore(record: record)
//                    guard let record else { return }
//                    scores.append(PlayerScore(record: record))
//                    scores = scores.sorted { $0.points > $1.points } ?? []
                }
             //   self.fetchScores()
            }
        }
    }
    
    private func localAddScore(record: CKRecord) {
        
        scores.append(PlayerScore(record: record))
        scores = scores.sorted { $0.points > $1.points }
    }
    
    func setupSubscription() {
        let subscriptionID = "ranking-changes"

        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(
            recordType: "Score",
            predicate: predicate,
            subscriptionID: subscriptionID,
            options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
        )

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true  // Silent
        subscription.notificationInfo = notificationInfo

        database.save(subscription) { returnedSub, error in
            if let error = error {
                print("❌ Subscription error: \(error.localizedDescription)")
            } else {
                print("✅ Subscription saved!")
            }
        }
    }
}
