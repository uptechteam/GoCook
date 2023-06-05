//
//  DependencyContainer.swift
//
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Dip
import DomainModels
import Foundation

@MainActor
public final class AppContainer {

    // MARK: - Properties

    public static let dependencyContainer = createDependencyContainer()

    // MARK: - Public methods

    static public func resolve<Service>(tag: DependencyTagConvertible? = nil) -> Service {
        try! dependencyContainer.resolve(tag: tag)
    }

    static public func resolve<Arguments, Service>(arguments: Arguments) -> Service {
        try! dependencyContainer.resolve(arguments: arguments)
    }

    // MARK: - Private methods

    // swiftlint:disable:next function_body_length
    static private func createDependencyContainer() -> DependencyContainer {
        return DependencyContainer { container in

            // MARK: - Apple frameworks

            container.register(.singleton, type: NotificationCenter.self, factory: { .default })

            // MARK: - Networking

            container.register(.singleton, type: NetworkClient.self, factory: NetworkClientImpl.init)
            container.register(.singleton, type: FileClienting.self, factory: FileClient.init)
            container.register(.singleton, type: ProfileClienting.self, factory: ProfileClient.init)
            container.register(.singleton, type: RecipesClienting.self, factory: RecipesClient.init)

            // MARK: - Facades

            container.register(.singleton, type: FavoriteRecipesFacading.self, factory: FavoriteRecipesFacade.init)
            container.register(
                .singleton,
                type: FiltersFacading.self,
                tag: FiltersFacadeTag.favorites,
                factory: FiltersFacade.init
            )
            container.register(
                .singleton,
                type: FiltersFacading.self,
                tag: FiltersFacadeTag.home,
                factory: FiltersFacade.init
            )
            container.register(.singleton, type: HomeFeedFacading.self, factory: HomeFeedFacade.init)
            container.register(.singleton, type: ProfileFacading.self, factory: ProfileFacade.init)
            container.register(.singleton, type: ProfileRecipesFacading.self, factory: ProfileRecipesFacade.init)
            container.register(.unique, type: RecipeFacading.self) { (recipeID: Recipe.ID) in
                let factory: RecipeFacadeFactory = try container.resolve()
                return try factory.produceFacade(
                    recipeID: recipeID,
                    producer: {
                        RecipeFacade(
                            recipeID: recipeID,
                            recipesClient: try container.resolve(),
                            recipesStorage: try container.resolve()
                        )
                    }
                )
            }
            container.register(.unique, type: RecipeFacading.self) { (recipeID: Recipe.ID?) in
                guard let recipeID else {
                    return MockRecipeFacade()
                }

                let factory: RecipeFacadeFactory = try container.resolve()
                return try factory.produceFacade(
                    recipeID: recipeID,
                    producer: {
                        RecipeFacade(
                            recipeID: recipeID,
                            recipesClient: try container.resolve(),
                            recipesStorage: try container.resolve()
                        )
                    }
                )
            }
            container.register(.singleton, type: RecipesFacading.self, factory: RecipesFacade.init)
            container.register(.singleton, type: SearchRecipesFacading.self, factory: SearchRecipesFacade.init)
            container.register(.unique, type: UserRecipesFacading.self) { (userID: User.ID) in
                let factory: UserRecipesFacadeFactory = try container.resolve()
                return try factory.produceFacade(
                    userID: userID,
                    producer: {
                        UserRecipesFacade(
                            userID: userID,
                            recipesClient: try container.resolve(),
                            recipesStorage: try container.resolve()
                        )
                    }
                )
            }

            // MARK: - Factories

            container.register(.singleton, type: UserRecipesFacadeFactory.self, factory: UserRecipesFacadeFactory.init)
            container.register(.singleton, type: RecipeFacadeFactory.self, factory: RecipeFacadeFactory.init)

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
        }
    }
}
