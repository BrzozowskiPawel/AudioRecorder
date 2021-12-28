//
//  AudioRecorderViewController.swift
//  AudioRecorder
//
//  Created by Paweł Brzozowski on 28/12/2021.
//

import UIKit

class AudioRecorderViewController: UIViewController {

    // Decalaration of UI elements
    var contentView:UIView = UIView()
    var recordingButton:UIButton = UIButton()
    var recordingsTableView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Setup TableView
//        recordingsTableView.delegate = self
//        recordingsTableView.dataSource = self
        
        // Set up contentView as "main" view. It will take almost (safearea) screen of view.
        setUpContentView()
        // Set up UI elements
        setUpUIElements()
    
    }
    
    // This function is responsible for setting up ContentView
    func setUpContentView() {
        // Set up maion view background color to white (in othercase safeare spaces will be differen color).
        self.view.backgroundColor = UIColor.white
        
        // Add it to the main View
        self.view.addSubview(contentView)
        
        // Set up background color to white
        contentView.backgroundColor = UIColor.white
        
        // In order to utilize auto layout I need to "activate" it by setting .translatesAutoresizingMaskIntoConstraints to false.
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set contentView to take almost full screen (on the top and bottom use safe area)
        contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // Set up UI elements by placing it and setting it's constraints
    func setUpUIElements() {
        contentView.addSubview(recordingButton)
        
        recordingButton.setBackgroundImage(UIImage(named: "StartRecording"), for: .normal)
        recordingButton.translatesAutoresizingMaskIntoConstraints = false
        recordingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordingButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10).isActive = true
        
        contentView.addSubview(recordingsTableView)
    }

}

//extension AudioRecorderViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
