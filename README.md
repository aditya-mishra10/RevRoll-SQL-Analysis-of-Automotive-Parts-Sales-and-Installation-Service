# RevRoll-SQL-Analysis-of-Automotive-Parts-Sales-and-Installation-Services
RevRoll is an auto parts dealer and installer. They offer a full range of automotive parts replacement services. This project uncovers the intricacies of RevRoll's business through detailed SQL analysis. By examining sales, installations, and customer data, the study aims to reveal insights that can optimize operations and improve service quality.

Data Dictionary

Table 1-- customers: customer details

customer_id: unique customer ID (key, integer)

preferred_name: name preferred by the customer (varchar(50))

Table 2-- installers: information about installers

installer_id: unique installer ID (key, integer)

name: name of the installer (varchar(50))

Table 3-- installs: records of installations

install_id: unique install ID (key, integer)

order_id: ID of the order (integer)

installer_id: ID of the installer (integer)

install_date: date of installation (date)

Table 4-- orders: details of customer orders

order_id: unique order ID (key, integer)

customer_id: ID of the customer (integer)

part_id: ID of the part ordered (integer)

quantity: number of parts ordered (integer)

Table 5-- parts: information about parts

part_id: unique part ID (key, integer)

name: name of the part (varchar(50))

price: price of the part (numeric)

Table 6-- install_derby: records of installer competitions

derby_id: unique derby ID (key, integer)

installer_one_id: ID of the first installer (integer)

installer_two_id: ID of the second installer (integer)

installer_one_time: time taken by the first installer (integer)

installer_two_time: time taken by the second installer (integer)
