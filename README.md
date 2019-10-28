# Dynamic Picklist for Lightning

Dynamic Picklist for Lightning allows you to display items from Salesforce Metadata as or results from a SOQL query as a Select / Option list in a Lightning Component or Lightning Web Component, without having to write code each time.

You will need to use SFDX to push this code to your development environment.

## Example
The below shows a picklist that has been dynamically created to populate the 'Primary Contact' (custom field) on the Account object:

![Example of Dynamic Picklist in action](https://raw.githubusercontent.com/flashheartthe4th/dynamicPicklistLightning/alpha/img/example-dynamic-picklist.png)

To view this example push the code to your development environment and follow these steps:

 1. **Push the code to your development environment**: sfdx force:source:push
 2. **Import the test data**: sfdx force:data:tree:import -p example-data/dynamicPicklist-Account-Contact-plan.json
 3. **Override the 'Edit' button on the Account Object**: Setup > Object Manager > Account > Buttons, Links, and Actions > Edit > Edit > Lightning Experience Override	> c:DynamicPicklist_ExampleRecord > Save
 4. **Edit the account record 'Test Account'**

# Getting Started

