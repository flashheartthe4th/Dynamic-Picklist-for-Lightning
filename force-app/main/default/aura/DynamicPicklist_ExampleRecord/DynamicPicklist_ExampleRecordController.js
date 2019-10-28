({
	doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        if (recId) {
            component.set("v.modalContext", "Edit");   
        }
        
        if (!recId) {
            component.find("forceRecord").getNewRecord(
                component.get("v.objectName"),
                recordTypeId,
                false,
                $A.getCallback(function() {
                    var rec = component.get("v.propertyRecord");
                    var error = component.get("v.recordError");
                    if (error || (rec === null)) {
                        console.log("Error initializing record template: " + error);
                        return;
                    }
                })
            );
        }  
    },

    saveRecord : function(component, event, helper) {
        
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        component.set("v.currentRecord.RecordTypeId",recordTypeId);

        var tempRec = component.find("forceRecord");
        tempRec.saveRecord($A.getCallback(function(result) {
            console.log(result.state);
            var resultsToast = $A.get("e.force:showToast");
            if (result.state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was saved."
                });
                resultsToast.fire();
                var recId = result.recordId;
                helper.navigateTo(component, recId);              
            } else if (result.state === "ERROR") {
                console.log('Error: ' + JSON.stringify(result.error));
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record: " + JSON.stringify(result.error)
                });
                resultsToast.fire();
            } else {
                console.log('Unknown problem, state: ' + result.state + ', error: ' + JSON.stringify(result.error));
            }
        }));
    },
    
    cancelDialog: function(component, event, helper) {
        var recId = component.get("v.recordId");
        if (!recId) {
            var homeEvt = $A.get("e.force:navigateToObjectHome");
            homeEvt.setParams({
                "scope": "Account"
            });
            homeEvt.fire();
        } else {
            helper.navigateTo(component, recId);
        }
    },

    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
         component.set("v.Spinner", true); 
    },
     
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
      // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})