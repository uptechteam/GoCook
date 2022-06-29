//
//  CreateRecipeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import BusinessLogic
import DomainModels
import Foundation
import Helpers

extension CreateRecipeViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var step: Int
        var stepOneState: StepOneState
        var stepTwoState: StepTwoState
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case addIngredientTapped
        case amountChanged(String)
        case amountTapped
        case backTapped
        case categoryItemTapped(IndexPath)
        case closeTapped
        case deleteIngredientTapped(IndexPath)
        case deleteTapped
        case imagePicked(ImageSource)
        case mealNameChanged(String)
        case nextTapped
        case recipeImageTapped
        case servingsAmountChanged(Int)
        case uploadImage(DomainModelAction<String>)
    }

    enum Alert {
        case imagePicker(isDeleteButtonPresent: Bool)
    }

    enum Route {
        case close
        case inputTapped(InputDetails)
    }

    public struct Dependencies {

        // MARK: - Properties

        public let fileClient: FileClienting

        // MARK: - Lifecycle

        public init(fileClient: FileClienting) {
            self.fileClient = fileClient
        }
    }

    public static func makeStore(dependencies: Dependencies) -> Store {
        let uploadImageMiddleware = makeUploadImageMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [uploadImageMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            step: 0,
            stepOneState: StepOneState(recipeImageState: .empty, mealName: "", categories: Set()),
            stepTwoState: StepTwoState(ingredients: [NewIngredient(id: UUID().uuidString, name: "")]),
            alert: nil,
            route: nil
        )
    }
}

extension CreateRecipeViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .addIngredientTapped:
            newState.stepTwoState.ingredients.append(NewIngredient(id: UUID().uuidString, name: ""))

        case .amountChanged(let text):
            newState.stepTwoState.numberOfServings = Int(text)

        case .amountTapped:
            let number = newState.stepTwoState.numberOfServings.flatMap(String.init) ?? ""
            newState.route = .init(value: .inputTapped(.numberOfServings(number)))

        case .backTapped:
            newState.step = max(0, newState.step - 1)

        case .categoryItemTapped(let indexPath):
            guard let category = CategoryType.priorityOrder[safe: indexPath.item] else {
                break
            }

            if newState.stepOneState.categories.contains(category) {
                newState.stepOneState.categories.remove(category)
            } else {
                newState.stepOneState.categories.insert(category)
            }

        case .closeTapped:
            newState.route = .init(value: .close)

        case .deleteIngredientTapped(let indexPath):
            guard newState.stepTwoState.ingredients.indices.contains(indexPath.item) else {
                break
            }

            newState.stepTwoState.ingredients.remove(at: indexPath.item)

        case .deleteTapped:
            newState.stepOneState.recipeImageState = .empty

        case .imagePicked(let imageSource):
            newState.stepOneState.recipeImageState = .uploading(imageSource)

        case .mealNameChanged(let mealName):
            newState.stepOneState.mealName = mealName

        case .nextTapped:
            if newState.step == 0 {
                newState.stepOneState.validate()
                if newState.stepOneState.isDataValid {
                    newState.step = min(3, newState.step + 1)
                }
            }

        case .recipeImageTapped:
            let isDeleteButtonPresent = newState.stepOneState.recipeImageState.uploadedImageSource != nil
            newState.alert = .init(value: .imagePicker(isDeleteButtonPresent: isDeleteButtonPresent))

        case .servingsAmountChanged(let amount):
            newState.stepTwoState.numberOfServings = amount

        case .uploadImage(let modelAction):
            switch modelAction {
            case .success(let imageID):
                newState.stepOneState.recipeImageState.upload(with: imageID)

            default:
                newState.stepOneState.recipeImageState = .empty
            }
        }

        return newState
    }
}

