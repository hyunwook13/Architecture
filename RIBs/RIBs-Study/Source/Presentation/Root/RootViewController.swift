//
//  RootViewController.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/24/25.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}
//
final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    weak var listener: RootPresentableListener?
    
    private let myNavigationController = UINavigationController()
    private var isNavigationSetup = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    private func setupNavigation() {
        guard !isNavigationSetup else { return }
        
        addChild(myNavigationController)
        view.addSubview(myNavigationController.view)
        myNavigationController.didMove(toParent: self)
        myNavigationController.view.frame = view.bounds
        
        // Auto Layout 설정 (옵션)
        myNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            myNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        isNavigationSetup = true
    }

    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        print("호출")
        // Navigation이 설정되어 있는지 확인
        setupNavigation()
        
        // 첫 번째 ViewController인 경우
        if myNavigationController.viewControllers.isEmpty {
            myNavigationController.setViewControllers([viewController.uiviewController], animated: false)
        } else {
            // 추가 ViewController를 push
            myNavigationController.pushViewController(viewController.uiviewController, animated: animated)
        }
    }

    func popViewController(animated: Bool) {
        myNavigationController.popViewController(animated: animated)
    }
    
    // 메모리 해제 시 디버깅용
    deinit {
        print("RootViewController deinit")
    }
}
