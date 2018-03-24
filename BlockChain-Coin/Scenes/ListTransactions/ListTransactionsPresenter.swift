//  
//  ListTransactionsPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol ListTransactionsPresentationLogic {
    func handleShowTransactions(wallets: [WalletModel])
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class ListTransactionsPresenter: ListTransactionsPresentationLogic {
    weak var viewController: ListTransactionsDisplayLogic?
    
    func handleShowTransactions(wallets: [WalletModel]) {
        let transactions = wallets.sorted(by: { a, b in return a.createdAt < b.createdAt }).enumerated().flatMap { index, wallet -> [ListTransactionItemViewModel]? in
            let transactions = wallet.details?.transactions.map({ transaction -> ListTransactionItemViewModel in
                return ListTransactionItemViewModel(name: R.string.localizable.wallet_list_item_title(index + 1), transaction: transaction)
            })
            
            if transactions?.isEmpty == true {
                return nil
            }
            
            return transactions
        }.flatMap({ $0 }).sorted { (a, b) -> Bool in
            return a.transaction.createdAt < b.transaction.createdAt
        }
        
        let viewModel = ListTransactionsViewModel(state: .loaded(transactions))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ListTransactionsViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = ListTransactionsViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
