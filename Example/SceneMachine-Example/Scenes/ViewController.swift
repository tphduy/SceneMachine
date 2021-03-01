//
//  ViewController.swift
//  SceneMachine-Example
//
//  Created by Duy Tran on 01/03/2021.
//

import UIKit
import SceneMachine

final class ViewController: UIViewController {
    
    // MARK: UIs
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = Asset.accentColor.color
        view.addAction(
            UIAction { [weak self] (_) in
                self?.reload()
            },
            for: .valueChanged)
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.refreshControl = refreshControl
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    private(set) lazy var statefulView = StatefulView()
    
    // MARK: - Dependencies
    
    private(set) var state: Loadable<[Int]>? {
        didSet {
            guard let state = self.state else { return }
            sceneMachine.present(
                state: state,
                provider: self)
        }
    }
    
    let sceneMachine: AnySceneMachine<[Int]>
    
    let dataRepository: DataRepository
    
    // MARK: - Init
    
    init(
        stateMachine: AnySceneMachine<[Int]> = DefaultSceneMachine().eraseToAnySceneMachine(),
        dataRepository: DataRepository = DefaultDataRepository()) {
        self.sceneMachine = stateMachine
        self.dataRepository = dataRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.sceneMachine = DefaultSceneMachine().eraseToAnySceneMachine()
        dataRepository = DefaultDataRepository()
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    // MARK: - Methods
    
    func reload() {
        state = .isLoading(last: state?.value)
        
        dataRepository.data { [weak self] (result) in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            
            switch result {
            case let .success(data):
                self.state = .loaded(data)
            case let .failure(error):
                self.state = .failed(error)
            }
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return state?.value?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = state?.value.map { String($0[indexPath.row]) }
        return cell
    }
}

// MARK: - StateMachineViewProvider

extension ViewController: SceneMachineViewProvider {
    
    var parentView: UIView {
        view
    }
    
    var constrainedTargetView: UIView {
        tableView
    }
    
    var contentView: UIView {
        tableView
    }
    
    func emptyView() -> UIView {
        statefulView.configure(
            withTitle: NSLocalizedString("Just me and you", comment: ""),
            image: Asset.empty.image,
            actionTitle: NSLocalizedString("Reload", comment: "")) { [weak self] in
            self?.reload()
        }
        
        return statefulView
    }
    
    func loadingView() -> UIView {
        statefulView.configure(
            withTitle: NSLocalizedString("A few seconds before happiness ...", comment: ""),
            image: Asset.loading.image,
            actionTitle: "")
        
        return statefulView
    }
    
    func errorView(error: Error) -> UIView {
        statefulView.configure(
            withTitle: NSLocalizedString("Something went wrong", comment: ""),
            image: Asset.error.image,
            actionTitle: NSLocalizedString("Retry", comment: "")) { [weak self] in
            self?.reload()
        }
        
        return statefulView
    }
}
