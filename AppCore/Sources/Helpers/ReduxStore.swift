//
//  ReduxStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Combine

@MainActor
public class ReduxStore<State, Action> {
    public typealias Reducer = @MainActor (State, Action) -> State
    public typealias Dispatch = (Action) async -> Void
    public typealias StateProvider = () -> State
    public typealias Middleware = (@escaping Dispatch, @escaping () -> State) -> (@escaping Dispatch) -> Dispatch

    @Published
    public var state: State
    private let reducer: Reducer
    private var dispatchFunction: Dispatch!

    public init(
        initialState: State,
        reducer: @escaping Reducer,
        middlewares: [Middleware]
    ) {
        self.state = initialState
        self.reducer = reducer
        let defaultDispatch: Dispatch = { [unowned self] action in
            state = reducer(state, action)
        }
        self.dispatchFunction = middlewares
            .reversed()
            .reduce(defaultDispatch) { dispatchFunction, middleware -> Dispatch in
                let dispatch: Dispatch = { [weak self] in self?.dispatch(action: $0) }
                let getState: StateProvider = { [weak self] in self?.state ?? initialState }
                return middleware(dispatch, getState)(dispatchFunction)
            }
    }

    public func dispatch(action: Action) {
        Task {
            await dispatchFunction?(action)
        }
    }

    public static func makeMiddleware(worker: @escaping (@escaping Dispatch, StateProvider, Dispatch, Action) async -> Void) -> Middleware {
        return { dispatch, getState in { next in { action in await worker(dispatch, getState, next, action) } } }
    }
}
