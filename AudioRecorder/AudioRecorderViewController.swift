//
//  AudioRecorderViewController.swift
//  AudioRecorder
//
//  Created by Paweł Brzozowski on 28/12/2021.
//

import UIKit
import AVFoundation

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate {

    // Decalaration of UI elements
    var contentView:UIView = UIView()
    var recordingButton:UIButton = UIButton()
    var recordingsTableView:UITableView = UITableView()
    
    // Variables to record and play recordings
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!

    // Keep track of record already recorded
    var numberOfRecords:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up session (initalziing)
        recordingSession = AVAudioSession.sharedInstance()
        
        // Ask for permission
        askForMicPermission()
        
        // Loading number of saved records from UserDefaults
        loadNumberOfSavedSounds()
        
        // Setup TableView
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
        
        // Set up contentView as "main" view. It will take almost all screen (safearea) of view.
        setUpContentView()
        // Set up UI elements
        setUpUIElements()
    
        print("number of rec: \(numberOfRecords)")
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
        // Adding recordingButton to view
        contentView.addSubview(recordingButton)
        
        // Set up image cof button
        recordingButton.setBackgroundImage(UIImage(named: "StartRecording"), for: .normal)
        
        // In order to utilize auto layout I need to "activate" it by setting .translatesAutoresizingMaskIntoConstraints to false.
        recordingButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Settings constraints for recordingButton
        recordingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordingButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10).isActive = true
        
        // Adding recognising long press gesture to recordingButton
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(recordingPressed))
        recordingButton.addGestureRecognizer(longPressRecogniser)
        
        // Adding recordingTable to view
        contentView.addSubview(recordingsTableView)
        
        // In order to utilize auto layout I need to "activate" it by setting .translatesAutoresizingMaskIntoConstraints to false.
        recordingsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Settings constraints for recordingsTabelView
        recordingsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        recordingsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        recordingsTableView.topAnchor.constraint(equalTo: recordingButton.bottomAnchor, constant: -15).isActive = true
        recordingsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // Setup cell for tableView
        recordingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
    }

    // Using UserDefaults load and set new value for numberOfRecords
    func loadNumberOfSavedSounds() {
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
            numberOfRecords = number
        }
    }
    
    // Function returning path to directory where I am saving recording.
    func getDirectory() -> URL {
        // Search for all url in document directory, take the first one as a path and return it.
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
    
    func askForMicPermission() {
        // Ask for permison
        AVAudioSession.sharedInstance().requestRecordPermission { permisson in
            if permisson {
                print("Permison to record ✅")
            } else {
                print("Permison dennied ‼️")
            }
        }
    }
    
    // This function is responsible for action when button is long pressed
    @objc func recordingPressed(sender: UILongPressGestureRecognizer) {
        
        // User started to long press
        if sender.state == .began {
        
            // Set up image of button to STOP RECORDING (if user stop pressing it will change back to START RECORDING)
            recordingButton.setBackgroundImage(UIImage(named: "StopRecording"), for: .normal)
            
            // Increasing value of currenlty recorded sounds
            numberOfRecords += 1
            
            // Get path to the file name (and name it as current number of sound)
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            // Setting requaired to record
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            
            // Start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
            } catch {
                displayAlert(title: "Error ‼️", message: "Recording failed.")
            }
        }
        // User stopped to long press
        else if sender.state == .ended {
            // Clear the audioRecorder
            audioRecorder = nil
            
            // Set up image of button to START RECORDING (the same situation as above)
            recordingButton.setBackgroundImage(UIImage(named: "StartRecording"), for: .normal)
            
            // Save value of numberOFRecords to UserDefaults after saving
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            
            // Reload data after adding new recording
            recordingsTableView.reloadData()
            
        }
    }
    
    // Function that dispalys an alert if something goes wrong
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

// tableView funstions:
extension AudioRecorderViewController: UITableViewDelegate, UITableViewDataSource {
    // Set number of rows equal to numberOfSaved sound retrieved from UserDefaults
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }

    // Create a cell forch each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = "Recording \(indexPath.row + 1)"
        
        return cell
    }
    
    // Set custom row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // When suer presses on row play that sound
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Each path (URL) is just a path + name of file (numer of current recording sound).
        // Get it and save to variable.
        let path = getDirectory().appendingPathComponent("\(indexPath.row+1).m4a")
        
        // Try to play sound for selested row, if there is error display alert.
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        } catch {
            displayAlert(title: "Error ‼️", message: "Playing failed.")
        }
    }


}
