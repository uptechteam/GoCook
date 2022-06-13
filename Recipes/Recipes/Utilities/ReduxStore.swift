//
//  ReduxStore.swift
//  Recipes
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

//import Combine
//import Foundation
//
//final class ReduxStore<State, Action> {
//    typealias Reducer = (State, Action) -> State
//    typealias Dispatch = (Action) -> Void
//    typealias StateProvider = () -> State
//    typealias Middleware = (@escaping Dispatch, @escaping () -> State) -> (@escaping Dispatch) -> Dispatch
//
//    let state: AnyPublisher<State, Never>
//
//    private let reducer: Reducer
//    private let stateVariable: CurrentValueSubject<State, Never>
//    private var dispatchFunction: Dispatch!
//
//    init(
//        initialState: State,
//        reducer: @escaping Reducer,
//        middlewares: [Middleware]
//    ) {
//        let stateVariable = CurrentValueSubject<State, Never>(initialState)
//
//        self.reducer = reducer
//        self.state = stateVariable.eraseToAnyPublisher()
//
//        let defaultDispatch: Dispatch = { action in
//            stateVariable.send(reducer(stateVariable.value, action))
//        }
//        self.stateVariable = stateVariable
//        self.dispatchFunction = middlewares
//            .reversed()
//            .reduce(defaultDispatch) { dispatchFunction, middleware -> Dispatch in
//                let dispatch: Dispatch = { [weak self] in self?.dispatch(action: $0) }
//                let getState: StateProvider = { stateVariable.value }
//                return middleware(dispatch, getState)(dispatchFunction)
//            }
//    }
//
//    func dispatch(action: Action) {
//        dispatchFunction?(action)
//    }
//
//    static func makeMiddleware(worker: @escaping (@escaping Dispatch, StateProvider, Dispatch, Action) -> Void) -> Middleware {
//        return { dispatch, getState in { next in { action in worker(dispatch, getState, next, action) } } }
//    }
//}
//
