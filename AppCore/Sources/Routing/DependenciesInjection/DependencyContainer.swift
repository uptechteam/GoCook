//
//  DependencyContainer.swift
//
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import BusinessLogic
import Dip
import DomainModels
import Foundation

extension DependencyContainer {
    @MainActor
    public static func configure() -> DependencyContainer {
        return DependencyContainer { container in

            // MARK: - Apple frameworks

            container.register(.singleton, type: NotificationCenter.self, factory: { .default })

            // MARK: - Networking

            container.register(.singleton, type: NetworkClient.self, factory: NetworkClientImpl.init)

            container.register(.singleton, type: FileClienting.self, factory: FileClient.init)
            container.register(.singleton, type: ProfileClienting.self, factory: ProfileClient.init)
            container.register(.singleton, type: RecipesClienting.self, factory: RecipesClient.init)

            // MARK: - Facades

            container.register(.singleton, type: ProfileFacading.self, factory: ProfileFacade.init)
            container.register(.singleton, type: ProfileRecipesFacading.self, factory: ProfileRecipesFacade.init)
            container.register(.unique, type: RecipesFacading.self) { (userID: User.ID) in
                let factory: RecipesFacadeFactory = try container.resolve()
                return try factory.produceFacade(
                    userID: userID,
                    producer: {
                        RecipesFacade(
                            userID: userID,
                            recipesClient: try container.resolve(),
                            recipesStorage: try container.resolve()
                        )
                    }
                )
            }

            // MARK: - Factories

            container.register(.singleton, type: RecipesFacadeFactory.self, factory: RecipesFacadeFactory.init)

            // MARK: - Managers

            container.register(.singleton, type: KeyboardManaging.self, factory: KeyboardManager.init)

            // MARK: - Storages

            container.register(.singleton, type: ProfileStoraging.self) {
                ProfileStorage(persistenceManager: try container.resolve() as PersistenceManager<Profile>)
            }
            container.register(.singleton, type: PersistenceManager<Profile>.self) {
                PersistenceManager<Profile>(containerName: "PersistentProfile", entityName: "PersistentProfile")
            }
            container.register(.singleton, type: RecipesStoraging.self, factory: RecipesStorage.init)
            container.register(.singleton, type: SecureStorage.self, factory: KeychainStorage.init)
            container.register(.singleton, type: Storage.self, factory: { UserDefaults.standard })
            container.register(.singleton, type: UserCredentialsStoraging.self, factory: UserCredentialsStorage.init)

            // MARK: - View controllers injection

            injectViewControllers(container: container)
        }
    }
}
