Tick
====

[![Build Status](http://img.shields.io/travis/nickswalker/tick/master.svg?style=flat)](https://travis-ci.org/nickswalker/tick)

An iOS interface for [Tock](https://github.com/nickswalker/tock-firmware), the nightstand alarm clock. Independent Study Mentorship project for senior year at Communications Arts High School (2014).

* Configure alarms to match your schedule
* Configure display options like brightness and 24 hour time

Technical Explanation
----

Bluetooth Low Energy development is generally split into two segments, low cost/inflexible and high cost/flexible. Low cost solutions (the only ones within practical reach for most) may offer abstractions like a faux UART interface or a scripting language on top of the module's system on a chip. High cost solutions are bare bones integrated circuits meant to be integrated into hardware designs by electronics engineers. Both of these solutions leave the software-savy, electronics-enamored developer high and dry to start prototyping BLE devices. I am researching better solutions and you can see my progress [here](https://github.com/nickswalker/HM-10-breakout-board).

The adopted approach of this project was to use a cheap ($20) UART-over-BLE module. The core challenge of the project then became handling how to transmit command information in 20 byte packets (a restriction imposed by the module's firmware, probably for good technical reasons). These commands had to be highly flexible and ideally leave room for future changes.

The set of commands is defined as an enum in both the clock firmware and the client software. The command value gets the first byte, then the next 19 are left to the individual command to fill with information. Both platforms must agree to the standard for a command, parsing and packing bits in a uniform fashion. This is not an ideal solution and makes creating commands difficult because two implementations must be created at once, but it's unfortunately the best solution available. Solutions that would facilitate custom BLE services and characteristics are out of the reach of hobbiests.

