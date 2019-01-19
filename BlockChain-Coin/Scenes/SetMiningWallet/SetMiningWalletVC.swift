//  
//  SetMiningWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit
import CenterAlignedCollectionViewFlowLayout

protocol SetMiningWalletDisplayLogic: class {
    func handleUpdate(viewModel: SetMiningWalletViewModel)
    func handleWalletsUpdate(viewModel: NewTransactionWalletsViewModel)
}

class SetMiningWalletVC: ViewController, SetMiningWalletDisplayLogic, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let formView = ScrollableStackView()
    let formFields = SetMiningWalletViews()

    let dataSource = SetMiningWalletDataSource()
    
    let router: SetMiningWalletRoutingLogic
    let interactor: SetMiningWalletBusinessLogic
    
    let itemSpacing: CGFloat = 20.0
    
    let wallet: WalletModel

    // MARK: - View lifecycle
    
    init(selectedWallet: WalletModel) {
        let interactor = SetMiningWalletInteractor()
        let presenter = SetMiningWalletPresenter()
        let router = SetMiningWalletRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.wallet = selectedWallet
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: SetMiningWalletRoutingLogic, interactor: SetMiningWalletBusinessLogic, selectedWallet: WalletModel) {
        self.router = router
        self.interactor = interactor
        
        self.wallet = selectedWallet

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        interactor.fetchWallets()
    }

    // MARK: - Configuration
    
    override func configure() {
        super.configure()
        
        view.backgroundColor = .clear
        
        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formView.stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.collectionView.dataSource = dataSource
        formFields.collectionView.delegate = self
        
        view.layoutSubviews()
        
        (formFields.collectionView.collectionViewLayout as? CenterAlignedCollectionViewFlowLayout)?.minimumLineSpacing = itemSpacing / 2.0
        (formFields.collectionView.collectionViewLayout as? CenterAlignedCollectionViewFlowLayout)?.minimumInteritemSpacing = itemSpacing
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: Actions
    
    @objc func backTapped() {
        router.goBack()
    }
    
    // MARK: - UICollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = dataSource.items.first?.count ?? 0
        
        let sectionInsets = (collectionView.collectionViewLayout as? CenterAlignedCollectionViewFlowLayout)?.sectionInset ?? .zero
        
        if count == 0 {
            return CGSize(width: collectionView.bounds.width - sectionInsets.left - sectionInsets.right, height: 50.0)
        }
        
        let numberOfItemsPerRow = 3
        let availableWidth = collectionView.bounds.width - (itemSpacing * CGFloat(max(0, numberOfItemsPerRow - 1))) - sectionInsets.left - sectionInsets.right
        let itemWidth = availableWidth / CGFloat(numberOfItemsPerRow)
        return CGSize(width: itemWidth, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing / 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let wallet = dataSource.items[indexPath.section][indexPath.item] as? Wallet else { return }
        
        interactor.saveSelectedWallet(wallet: wallet)
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: SetMiningWalletViewModel) {
        
    }
    
    func handleWalletsUpdate(viewModel: NewTransactionWalletsViewModel) {
        switch viewModel.state {
        case .loaded(let wallets):
            dataSource.availableWallets = wallets
        default:
            break
        }
        
        formFields.collectionView.reloadData()
        
        dataSource.items = [ dataSource.availableWallets ]

        formFields.collectionView.reloadData()
        
        self.formFields.collectionView.snp.updateConstraints({
            $0.height.equalTo(self.formFields.collectionView.collectionViewLayout.collectionViewContentSize.height)
        })
        
        if let selectedWalletIndex = dataSource.availableWallets.index(where: { $0.address == wallet.address }) {
            formFields.collectionView.selectItem(at: IndexPath(item: selectedWalletIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
}
