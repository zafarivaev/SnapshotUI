//
//  ViewController.swift
//  SnapshotUI
//
//  Created by Zafar on 3/31/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    func takeScreenshot(of view: UIView) {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: view.bounds.width, height: view.bounds.height),
            false,
            2
        )
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
    }
    
    @objc func actionButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.actionButton.backgroundColor = .blue
        }) { _ in
            self.actionButton.backgroundColor = .systemBlue
        }
        
        takeScreenshot(of: backgroundShadowView)
    }
    
    // MARK: - Properties
    let sampleData = ["First item",
                      "Second item",
                      "Third item",
                      "Fourth item",
                      "Fifth item",
                      "Sixth item"]
    
    lazy var backgroundShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView
            .translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Create Snapshot", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

}

// MARK: - UITableView Data Source
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = sampleData[indexPath.row]
        return cell
    }
    
}

// MARK: - UI Setup
extension ViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(backgroundShadowView)
        backgroundShadowView.addSubview(tableView)
        self.view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            backgroundShadowView.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            backgroundShadowView.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            backgroundShadowView.widthAnchor
                .constraint(equalToConstant: self.view.frame.width * 0.8),
            backgroundShadowView.heightAnchor
                .constraint(equalToConstant: self.view.frame.height * 0.5),
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor
                .constraint(equalTo: backgroundShadowView.leadingAnchor),
            tableView.trailingAnchor
                .constraint(equalTo: backgroundShadowView.trailingAnchor),
            tableView.topAnchor
                .constraint(equalTo: backgroundShadowView.topAnchor,
                            constant: 20),
            tableView.bottomAnchor
                .constraint(equalTo: backgroundShadowView.bottomAnchor,
                            constant: -20)
        ])
        
        
        NSLayoutConstraint.activate([
            actionButton.widthAnchor
                .constraint(equalToConstant: self.view.frame.width * 0.8),
            actionButton.heightAnchor
                .constraint(equalToConstant: 50),
            actionButton.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            actionButton.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                            constant: -20),
        ])
    }
}

