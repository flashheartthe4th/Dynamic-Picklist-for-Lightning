public with sharing class DynamicPicklist 
{
    @AuraEnabled
    public string value {get;set;}
    @AuraEnabled
    public string label {get;set;}
    
    public DynamicPickList(string val, string lab)
    {
        value = val;
        label = lab;
    }
}