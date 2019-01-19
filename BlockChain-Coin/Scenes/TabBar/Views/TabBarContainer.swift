//
//  TabBarContainer.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class HomeContainer: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var didSelectTab: (Int) -> Void = { _ in }
    
    var childControllers: [UIViewController] = [] {
        didSet {
            guard let firstVC = childControllers.first else { return }
            
            setViewControllers([ firstVC ], direction: .forward, animated: false, completion: nil)
        }
    }
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        dataSource = self
        delegate = self
        
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.bounces = false
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Datasource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = childControllers.index(of: viewController), viewController != childControllers.first else {
            return nil
        }
        
        return childControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = childControllers.index(of: viewController), viewController != childControllers.last else {
            return nil
        }
        
        return childControllers[index + 1]
    }
    
    // MARK: - Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentController = pageViewController.viewControllers?.first else { return }
        
        guard let index = childControllers.index(of: currentController) else { return }
        
        didSelectTab(index)
    }
    
    // MARK: - Actions
    
    func setSelectedIndex(index: Int, animated: Bool = true) {
        guard index < childControllers.count else { return }
        
        setViewControllers([ childControllers[index] ], direction: .forward, animated: animated, completion: nil)
    }
    
}
