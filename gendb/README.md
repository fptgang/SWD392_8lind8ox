```
seed: 
- project categories
- skills

simulation:
- create account
  if freelancer -> create profile, profile skills
- create project -> create milestones
                 -> project required skills
- create proposal
- make deposit
- request withdrawal

dump order
    account
    files
    messages
    milestones
    profile_skills
    profiles
    project_categories [x]
    project_required_skills
    projects
    proposals
    refresh_token
    skills [x]
    transactions

Write a Typescript class to present the table using the appropriate typescript data types
Import: import {escapeSingleQuotes} from "../utils.js";

The constructor accepts Partial<T>
The constructor need to explicitly set each field individually with proper default values

Then, write a static dump() function that accept an array of model objects and print out MySQL-compatible SQL command that bulk insert. 

Remember:
- format the value as appropriate to let it work with the data type declared in table fields. For string, use escapeSingleQuotes()
- For ID (primary key and foreign key), in the typescript model, should be [number]

Do not write the examples
Export all 





CREATED ---------> COURIER_ACCEPTED ----> SHIPPING ----> DELIVERED -------> RECEIVED ---------> COMPLETED
(system)               (staff)           (3rd system)   (3rd system)    (system/customer)
         |                |                   |                      
      CANCELED(1)      CANCELED(2)         CANCELED(3)       [       (4)    ]    [        (5)       ]
  (system/customer)   (customer)         (3rd system)


Edge flows:
(1) If the balance does not have enough credits / or the deposit of credits at the time of checkout fails, then the order is CANCELED
(1,2) Before the status is SHIPPING, the customer can cancel the order and get their credits back
(3) During the shipping, if the shipper cannot deliver the package, the order is cancelled, and he takes the package back to us
(4) After DELIVERED, the system auto marks RECEIVED after some days if the custom has not yet done so
(5) After RECEIVED, the system auto marks COMPLETED after some days


```