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
        var stepThreeState: StepThreeState
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
        case cookingTimeTapped
        case cookingTimeChanged(amount: String)
        case deleteIngredientTapped(IndexPath)
        case deleteTapped
        case imagePicked(ImageSource)
        case ingredientAmountTapped(IndexPath)
        case ingredientAmountChanged(id: String, amount: String, unit: IngredientUnit)
        case ingredientNameTapped(IndexPath)
        case ingredientNameChanged(id: String, name: String)
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
            stepTwoState: StepTwoState(ingredients: [.makeNewIngredient()]),
            stepThreeState: StepThreeState(),
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
            newState.stepTwoState.ingredients.append(.makeNewIngredient())

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

        case .cookingTimeTapped:
            let time = newState.stepThreeState.cookingTime.flatMap(String.init) ?? ""
            newState.route = .init(value: .inputTapped(.cookingTime(time)))

        case .cookingTimeChanged(let amount):
            newState.stepThreeState.cookingTime = Int(amount)

        case .deleteIngredientTapped(let indexPath):
            guard newState.stepTwoState.ingredients.indices.contains(indexPath.item) else {
                break
            }

            newState.stepTwoState.ingredients.remove(at: indexPath.item)

        case .deleteTapped:
            newState.stepOneState.recipeImageState = .empty

        case .imagePicked(let imageSource):
            newState.stepOneState.recipeImageState = .uploading(imageSource)

        case .ingredientAmountTapped(let indexPath):
            guard let ingredient = newState.stepTwoState.ingredients[safe: indexPath.item] else {
                break
            }

            let inputDetails = InputDetails.ingredientAmount(
                id: ingredient.id,
                amount: ingredient.amount.flatMap(String.init) ?? "",
                unit: ingredient.unit
            )
            newState.route = .init(value: .inputTapped(inputDetails))

        case let .ingredientAmountChanged(id, amount, unit):
            guard let index = newState.stepTwoState.ingredients.firstIndex(where: { $0.id == id }) else {
                break
            }

            newState.stepTwoState.ingredients[index].amount = Int(amount)
            newState.stepTwoState.ingredients[index].unit = unit

        case .ingredientNameTapped(let indexPath):
            guard let ingredient = newState.stepTwoState.ingredients[safe: indexPath.item] else {
                break
            }

            newState.route = .init(value: .inputTapped(.ingredientName(id: ingredient.id, name: ingredient.name)))

        case let .ingredientNameChanged(id, name):
            guard let index = newState.stepTwoState.ingredients.firstIndex(where: { $0.id == id }) else {
                break
            }

            newState.stepTwoState.ingredients[index].name = name

        case .mealNameChanged(let mealName):
            newState.stepOneState.mealName = mealName

        case .nextTapped:
            var isDataValid = false
            if newState.step == 0 {
                newState.stepOneState.validate()
                isDataValid = newState.stepOneState.isDataValid
            } else if newState.step == 1 {
                newState.stepTwoState.validate()
                isDataValid = newState.stepTwoState.isDataValid
            } else if newState.step == 2 {
                newState.stepThreeState.validate()
                isDataValid = newState.stepThreeState.isDataValid
            }

            if isDataValid {
                newState.step = min(3, newState.step + 1)
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

