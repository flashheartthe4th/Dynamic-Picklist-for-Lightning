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

# Why do I need this?

The Dynamic Picklist is needed when you want to: 
1. Map a lightning-input to a picklist field.
2. Provide a subset of records to a user without having to expose the lookup or allow the user to search (useful for providing a lighter weight experience on a mobile app)
3. Store an Id on a record to create a relationship between two objects, but where you can't use a 'Lookup' field. 

# How it works
To get the Dynamic Picklist plumb into your Lightning Components see below.

This documentation assumes you are using **force:recordData** lightning as per the included example.

## Metadata Based Picklist aka Standard Picklist

The metadata based picklist behaves the same as a normal picklist field in Salesforce.

Below is an example of how you can get the Industry values for an Account, as shown in the screenshot above.

1 Define an attribute to store the picklist values:

    <aura:attribute name='metaDataPicklist' type='DynamicPicklist' />
N.B The '*name*' attribute needs to be unique, and will be referenced by the select input field below.

2 Add the component:

    <c:DynamicPicklist isQuery="false" objectName="Account" fieldName="Industry" picklistValues="{!v.metaDataPicklist}" />

The above will get the picklist values from the standard field 'Industry' on the Account object. For more advanced usage please see Advanced Options below.

3 Add the select tag:

    <lightning:select aura:id="accountIndustry" name="accountIndustry" label="Industry" value="{!v.currentRecord.Industry}" required="true"
    class="slds-size--1-of-1 slds-p-horizontal_x-small">
	    <aura:iteration items="{!v.metaDataPicklist}" var="item">
		    <aura:if isTrue="{!v.currentRecord.Industry == item.value }">
			    <option value="{!item.value}" selected="selected">{!item.label}</option>
			    <aura:set attribute="else">
				    <option value="{!item.value}">{!item.label}</option>
			    </aura:set>
		    </aura:if>
	    </aura:iteration>
    </lightning:select>

The value specified in *items* in the *aura:iteration* must match the *name* from step 1.

![Example of Metadata Based picklist in action](https://raw.githubusercontent.com/flashheartthe4th/dynamicPicklistLightning/alpha/img/example-dynamic-picklist.png)

## Query Based Picklist

The Query Based Picklist acts in a similar way to a lookup / filtered lookup, but with the added benefit of allowing you define your filter criteria on a page by page basis, as opposed to globally.

Below is an example of how you can get a list of all the Contacts for the current Account record so you can select the primary contact, as shown in the screenshot above.

1 Define an attribute to store the picklist values:

    <aura:attribute name='soqlPicklist' type='DynamicPicklist' />
    
N.B The '*name*' attribute needs to be unique, and will be referenced by the select input field below.

2 Add the component:

    <c:DynamicPicklist isQuery="true" queryString="{!'SELECT Id, Name FROM Contact WHERE AccountId = #'+v.recordId+'#'}" labelField="Name" valueField="Id" picklistValues="{!v.soqlPicklist}" />

The above will build a picklist based upon the query, and the field will store the Id of the contact (valueField), but the user will only be asked to select from the contact's Name (labelField).

3 Add the select tag:

    <lightning:select aura:id="accountPrimaryContact" name="accountPrimaryContact" label="Primary Contact" value="{!v.currentRecord.PrimaryContactId__c}" required="true"
    class="slds-size--1-of-1 slds-p-horizontal_x-small">
	    <aura:iteration items="{!v.soqlPicklist}" var="item">
		    <aura:if isTrue="{!v.currentRecord.PrimaryContactId__c == item.value }">
			    <option value="{!item.value}" selected="selected">{!item.label}</option>
			    <aura:set attribute="else">
				    <option value="{!item.value}">{!item.label}</option>
			    </aura:set>
		    </aura:if>
	    </aura:iteration>
    </lightning:select>

The value specified in *items* in the *aura:iteration* must match the *name* from step 1.

![Example of Query based picklist in action](https://raw.githubusercontent.com/flashheartthe4th/dynamicPicklistLightning/alpha/img/example-dynamic-picklist.png)

# Options / Attributes
| Attribute | Description | Default Value |
|--|--|--|
| isQuery | Defines whether the picklist is to be build from a query | TRUE |
| allowNull | Do you want to allow the user to select nothing | TRUE |
| queryString | **Required for isQuery:** What query do you want to execute? If you need to include an Id or a string, enclose these with # as ' are escaped as part of SQL injection prevention. | NULL |
| labelField | **Required for isQuery:** The name of the field you want to use as the value the user selects. Typically this will Name. | 'getLabel()' of 'getPicklistValues()' schema method |
| valueField | **Required for isQuery:** The name of the field you want to store in the field. Typically this will be Id. | 'getValue()' of 'getPicklistValues()' schema method |
| objectName | The API name, including namespace, of the Object where the field you are querying is contained | NULL |
| fieldName | Required for isQuery The API name, including namespace, of the field where the value you require is contained | NULL |