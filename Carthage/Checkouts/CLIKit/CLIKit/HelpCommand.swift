//
//  HelpCommand.swift
//  CLIKit
//
//  Created by Kyle Fuller on 05/07/2014.
//  Copyright (c) 2014 Cocode. All rights reserved.
//

class HelpCommand : Command {
    init() {
        super.init("help", "Show help for the given command.")
    }

    override func run(manager: Manager, arguments: ARGV) {
        if let commandName = arguments.shift() {
            if let command = manager.findCommand(commandName) {
                println("\(command.name):\n")
                println("    \(command.description)")
            } else {
                println("\(commandName) not found.")
            }
        } else {
            for command in manager.commands {
                println("- \(command.name): \(command.description)")
            }
        }
    }
}
