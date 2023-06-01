//
//  Profile+PersistenceModel.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import CoreData
import DomainModels
import Helpers

extension Profile: PersistenceModel {
    public func createEntity(context: NSManagedObjectContext) -> PersistentProfile {
        let entity = PersistentProfile(context: context)
        entity.id = id.rawValue
        entity.username = username
        entity.avatarURL = avatar?.url?.absoluteString
        return entity
    }

    public init?(entity: PersistentProfile) {
        guard
            let id = entity.id.flatMap(User.ID.init(rawValue:)),
            let username = entity.username
        else {
            return nil
        }

        self.init(
            id: id,
            username: username,
            avatar: entity.avatarURL.flatMap(URL.init(string:)).flatMap(ImageSource.remote)
        )
    }
}
