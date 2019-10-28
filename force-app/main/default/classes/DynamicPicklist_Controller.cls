public with sharing class DynamicPicklist_Controller {
    
    @AuraEnabled
    public static DynamicPickList[] getPicklistforQuery(String queryString,String labelField,String valueField,String objectName,String fieldName,boolean isQuery,string dataSource,boolean allowNull){
        DynamicPickList[] Picklist = new DynamicPickList[]{};

        if(allowNull)
        {
            system.debug(System.LoggingLevel.FINE,'Adding Empty Value');
            DynamicPickList PicklistItem = new DynamicPickList('','');
            Picklist.add(PicklistItem);
        }
        
        //this runs a query that you specified in the 
        if(isQuery)
        {
            system.debug(System.LoggingLevel.DEBUG,'labelField: '+labelField);
            system.debug(System.LoggingLevel.DEBUG,'valueField: '+valueField);
            system.debug(System.LoggingLevel.DEBUG,'Raw Query: '+queryString);
            
            string escapedQuery = string.escapeSingleQuotes(queryString).replaceAll('#','\'');
            system.debug(System.LoggingLevel.DEBUG,'Escaped Query: '+escapedQuery);
            
            for(sObject sObj:database.query(escapedQuery))
            {
                DynamicPickList PicklistItem = new DynamicPickList(
                    String.valueOf(sObj.get(valueField)),
                    String.valueOf(sObj.get(labelField))
                );
                system.debug(System.LoggingLevel.FINE,'PicklistItem Value: "'+PicklistItem.value+'/'+PicklistItem.label+'"');
                Picklist.add(PicklistItem);
            }
        }
        //this runs a metadata query based upon the record object name and field name provided
        else
        {
            Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectName);
            Schema.DescribeSObjectResult res = convertToObj.getDescribe();
            Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fieldName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            if(ple.size() == 0)
            {
                system.debug(System.LoggingLevel.ERROR,'The field you have specified: '+fieldName+' is not a picklist. No values to return');
            }
            else
            {
                for( Schema.PicklistEntry pickListVal : ple){
                    DynamicPickList PicklistItem = new DynamicPickList(
                        pickListVal.getValue(),
                        pickListVal.getLabel()
                    );
                    system.debug(System.LoggingLevel.FINE,'PicklistItem Value: "'+PicklistItem.value+'/'+PicklistItem.label+'"');
                    Picklist.add(PicklistItem);
                }
            }
        }
        
        system.debug(System.LoggingLevel.DEBUG,'Returning: ('+Picklist.size()+') items.');
        
        return Picklist;
    }
}