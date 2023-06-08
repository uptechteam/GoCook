//
//  ManageRecipePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.03.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Foundation
import Helpers
import UIKit

@MainActor
final class ManageRecipePresenter {

    // MARK: - Properties

    private let fileClient: FileClienting
    private let keyboardManager: KeyboardManaging
    private let recipeFacade: RecipeFacading
    private let recipesFacade: RecipesFacading
    @Published
    private(set) var state: State
    private var uploadImageTask: Task<String, Error>?

    var keyboardHeightChange: any Publisher<CGFloat, Never> {
        return keyboardManager
            .change
            .map { change -> CGFloat in
                switch change.notificationName {
                case UIResponder.keyboardWillHideNotification:
                    return 0

                default:
                    return change.frame.height
                }
            }
            .removeDuplicates()
    }

    // MARK: - Lifecycle

    init(
        envelope: ManageRecipeEnvelope,
        fileClient: FileClienting,
        keyboardManager: KeyboardManaging,
        recipeFacade: RecipeFacading,
        recipesFacade: RecipesFacading
    ) {
        self.fileClient = fileClient
        self.keyboardManager = keyboardManager
        self.recipeFacade = recipeFacade
        self.recipesFacade = recipesFacade
        self.state = State.makeInitialState(envelope: envelope)
        self.uploadImageTask = nil
    }

    // MARK: - Public methods

    func addIngredientTapped() {
        state.stepTwoState.ingredients.append(.makeNewIngredient())
        state.stepTwoState.areIngredientsValid = true
    }

    func addInstructionTapped() {
        state.stepThreeState.instructions.append("")
        state.stepThreeState.areInstructionsValid = true
    }

    func amountChanged(text: String) {
        state.stepTwoState.numberOfServings = Int(text)
        state.stepTwoState.isNumberOfServingsValid = true
    }

    func amountTapped() {
        let number = state.stepTwoState.numberOfServings.flatMap(String.init) ?? ""
        state.route = .init(value: .inputTapped(.numberOfServings(number)))
    }

    func backTapped() {
        state.step = max(0, state.step - 1)
    }

    func categoryItemTapped(index: Int) {
        guard let category = CategoryType.priorityOrder[safe: index] else {
            return
        }

        if state.stepOneState.categories.contains(category) {
            state.stepOneState.categories.remove(category)
        } else {
            state.stepOneState.categories.insert(category)
        }

        state.stepOneState.areCategoriesValid = true
    }

    func closeConfirmed() {
        state.route = .init(value: .close)
    }

    func closeTapped() {
        if state.step == 0 && state.stepOneState.isEmpty {
            state.route = .init(value: .close)
        } else {
            state.alert = .init(value: .deleteProgress)
        }
    }

    func cookingTimeTapped() {
        let time = state.stepThreeState.cookingTime.flatMap(String.init) ?? ""
        state.route = .init(value: .inputTapped(.cookingTime(time)))
    }

    func cookingTimeChanged(amount: String) {
        state.stepThreeState.cookingTime = Int(amount)
        state.stepThreeState.isCookingTimeValid = true
    }

    func deleteIngredientTapped(indexPath: IndexPath) {
        guard state.stepTwoState.ingredients.indices.contains(indexPath.item) else {
            return
        }

        state.stepTwoState.ingredients.remove(at: indexPath.item)
        state.stepTwoState.areIngredientsValid = true
    }

    func deleteInstructionTapped(index: Int) {
        guard state.stepThreeState.instructions.indices.contains(index) else {
            return
        }

        state.stepThreeState.instructions.remove(at: index)
        state.stepThreeState.areInstructionsValid = true
    }

    func deleteTapped() {
        state.stepOneState.recipeImageState = .empty
    }

    func finishTapped() async {
        guard
            state.stepOneState.isDataValid,
            state.stepTwoState.isDataValid,
            state.stepThreeState.isDataValid
        else {
            return
        }

        state.isUploadingRecipe = true
        do {
            if let id = state.recipeID {
                _ = try await recipesFacade.edit(recipe: state.getRecipeUpdate(recipeID: id))
                try? await recipeFacade.refreshRecipe()
            } else {
                _ = try await recipesFacade.create(recipe: state.getNewRecipe())
            }

            state.isUploadingRecipe = false
            state.route = .init(value: .close)
        } catch {
            state.isUploadingRecipe = false
        }
    }

    func imagePicked(image: ImageSource) async {
        state.stepOneState.recipeImageState = .uploading(image)
        state.stepOneState.isRecipeImageValid = true
        do {
            guard let imageID = try await upload(imageSource: image) else {
                return
            }

            state.stepOneState.recipeImageState.upload(with: imageID)
        } catch {
            state.stepOneState.recipeImageState = .error(message: .manageRecipeStepOneUploadError)
        }
    }

    func ingredientAmountTapped(indexPath: IndexPath) {
        guard let ingredient = state.stepTwoState.ingredients[safe: indexPath.item] else {
            return
        }

        let inputDetails = InputDetails.ingredientAmount(
            id: ingredient.id,
            amount: ingredient.amount.flatMap(String.init) ?? "",
            unit: ingredient.unit
        )
        state.route = .init(value: .inputTapped(inputDetails))
    }

    func ingredientAmountChanged(id: String, amount: String, unit: IngredientUnit) {
        guard let index = state.stepTwoState.ingredients.firstIndex(where: { $0.id == id }) else {
            return
        }

        state.stepTwoState.ingredients[index].amount = Int(amount)
        state.stepTwoState.ingredients[index].unit = unit
        state.stepTwoState.areIngredientsValid = true
    }

    func ingredientNameTapped(indexPath: IndexPath) {
        guard let ingredient = state.stepTwoState.ingredients[safe: indexPath.item] else {
            return
        }

        state.route = .init(value: .inputTapped(.ingredientName(id: ingredient.id, name: ingredient.name)))
    }

    func ingredientNameChanged(id: String, name: String) {
        guard let index = state.stepTwoState.ingredients.firstIndex(where: { $0.id == id }) else {
            return
        }

        state.stepTwoState.ingredients[index].name = name
        state.stepTwoState.areIngredientsValid = true
    }

    func instructionChanged(index: Int, text: String) {
        state.stepThreeState.instructions[safe: index] = text
        state.stepThreeState.areInstructionsValid = true
    }

    func mealNameChanged(name: String) {
        state.stepOneState.mealName = name
        state.stepOneState.isMealNameValid = true
    }

    func nextTapped() {
        var isDataValid = false
        if state.step == 0 {
            state.stepOneState.validate()
            isDataValid = state.stepOneState.isDataValid
        } else if state.step == 1 {
            state.stepTwoState.validate()
            isDataValid = state.stepTwoState.isDataValid
        } else if state.step == 2 {
            state.stepThreeState.validate()
            isDataValid = state.stepThreeState.isDataValid
        }

        if isDataValid {
            state.step = min(3, state.step + 1)
        }
    }

    func recipeImageTapped() {
        guard !state.stepOneState.recipeImageState.isUploading else {
            uploadImageTask?.cancel()
            state.stepOneState.recipeImageState = .empty
            return
        }

        let isDeleteButtonVisible = state.stepOneState.recipeImageState.uploadedImageSource != nil
        state.alert = .init(value: .imagePicker(isDeleteButtonVisible: isDeleteButtonVisible))
    }

    func servingsAmountChanged(amount: Int) {
        state.stepTwoState.numberOfServings = amount
    }

    // MARK: - Private methods

    private func upload(imageSource: ImageSource) async throws -> String? {
        guard let data = imageSource.image?.pngData() else {
            log.info("Can't get data from picked image")
            return nil
        }

        uploadImageTask = Task {
            try await fileClient.uploadRecipeImage(data: data)
        }
        let imageID = try await uploadImageTask?.value
        let isCancelled = uploadImageTask?.isCancelled ?? true
        return isCancelled ? nil : imageID
    }
}
